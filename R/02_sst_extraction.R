# 1. Required packages ----

library(tidyverse) # Core tidyverse packages
library(lubridate)
library(ncdf4)
library(raster)
library(sp)
library(sf)
library(furrr) # For parallelization

plan(multisession, workers = 6) # Set parallelization with 6 cores

# 2. Required functions ----

source("R/functions/extractncdf_raster.R")

# 3. Set parameters ----

plan(multisession, workers = 6) # Set parallelization with 6 cores

rasterOptions(maxmemory = 1e+09) # Set max memory for raster

# 4. Define the CRS ----

crs_used <- 4326

# 5. List of NetCDF4 files ----

#ncdf_files <- list.files(path = "data/01_sst_raw/", pattern = "\\.nc$", full.names = TRUE)
ncdf_files <- list.files(path = "/home/jwicquart/nasephe/disturbance/data/05_sst_raw", pattern = "\\.nc$", full.names = TRUE)

# 6. Check if files are missing ----

real_files_list <- str_remove_all(str_split_fixed(ncdf_files, "_", n = 5)[,5], "\\.nc")

theoric_files_list <- str_remove_all(seq(as.Date("1985-01-01"), as.Date("2020-12-31"), by = "days"), "-")

setdiff(theoric_files_list, real_files_list)

rm(theoric_files_list, real_files_list)

# 7. File of site coordinates ----

load("data/data_joined.RData")

# 7.1 Transform to sp --

data_reefs <- as_Spatial(data_joined)

# 7.2 Plot for visual inspection --

#png("figs/05-sst_method-polygon_dataviz.png", width = 1000, height = 500)

#plot(raster(ncdf_files[1], varname = "analysed_sst"))

#plot(gcrmn_sp, add = TRUE, border = "black")

#dev.off()

# 8. Apply the function fo each file ----

results_sst_raw <- enframe(ncdf_files, name = NULL, value = "paths") %>% 
  dplyr::mutate(values = future_map(paths, ~extractncdf_raster(data_raster = ., data_polygon = data_reefs)))

# 9. Unlist and select variables ----

results_sst <- results_sst_raw %>% 
  unnest(values) %>% 
  rename(sst = analysed.sea.surface.temperature, ecoregion = Ecoregion) %>% 
  mutate(date = str_split_fixed(paths, "_", 5)[,5],
         date = paste(str_sub(date, 1, 4), str_sub(date, 5, 6), str_sub(date, 7, 8), sep = "-"),
         date = as.Date(date)) %>% 
  dplyr::select(date, ecoregion, sst)

# 10. Export the file ----

save(results_sst, file = "data/02_sst-extracted.RData")
