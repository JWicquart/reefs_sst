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




# 3. List of NetCDF4 files ----

ncdf_files <- list.files(path = "data/01_sst_raw/", pattern = "\\.nc$", full.names = TRUE)

# 4. Check if files are missing ----

real_files_list <- str_remove_all(str_split_fixed(ncdf_files, "_", n = 5)[,5], "\\.nc")

theoric_files_list <- str_remove_all(seq(as.Date("1985-01-01"), as.Date("2020-12-31"), by = "days"), "-")

setdiff(theoric_files_list, real_files_list)

rm(theoric_files_list, real_files_list)

# 5. File of site coordinates ----

load("data/data_joined.RData")

# 5.5 Transform to sp --

data_reefs <- as_Spatial(data_joined)

# 5.6 Plot for visual inspection --

png("figs/05-sst_method-polygon_dataviz.png", width = 1000, height = 500)

plot(raster(ncdf_files[1], varname = "analysed_sst"))

plot(gcrmn_sp, add = TRUE, border = "black")

dev.off()





results_sst_raw <- enframe(ncdf_files, name = NULL, value = "paths") %>% 
  dplyr::mutate(values = future_map(paths, ~extractncdf_raster(data_raster = ., data_polygon = data_reefs)))
















# 6. Extract SST values ----

data_dhw <- enframe(ncdf_files, name = NULL, value = "paths") %>% 
  mutate(values = future_map(paths, ~extractncdf_map(., coordinates = site_coordinates))) %>% 
  unnest(values) %>% 
  dplyr::select(-paths)

# 7. Calculation of DHW ----

data_dhw <- dhw_calculation(data = data_dhw) %>% 
  mutate(date = as.Date(date),
         year = year(date),
         month = month(date))

# 8. Export the file ----

save(data_dhw, file = "data/05_sst_dhw-by-site-and-day.RData")
