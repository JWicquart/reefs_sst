# 1. Required packages ----

library(tidyverse) # Core tidyverse packages
library(lubridate)
library(ncdf4)
library(raster)
library(sp)
library(furrr) # For parallelization

plan(multisession, workers = 6) # Set parallelization with 6 cores

# 2. Required functions ----

source("R/functions/extractncdf_map.R") # NetCDF SST extraction
source("R/functions/dhw_calculation.R") # DHW calculation

# 3. List of NetCDF4 files ----

ncdf_files <- list.files(path = "data/05_sst_raw/", pattern = "\\.nc$", full.names = TRUE)

# 4. Check if files are missing ----

real_files_list <- str_remove_all(str_split_fixed(ncdf_files, "_", n = 5)[,5], "\\.nc")

theoric_files_list <- str_remove_all(seq(as.Date("1985-01-01"), as.Date("2020-12-31"), by = "days"), "-")

setdiff(theoric_files_list, real_files_list)

rm(theoric_files_list, real_files_list)

# 5. File of site coordinates ----

load("data/04_benthic-cover_site-coordinates.RData")

site_coordinates <- SpatialPointsDataFrame(
  # Coordinates
  coords = site_coordinates[, c("long", "lat")],
  # Data
  data = as.data.frame(site_coordinates[, "timeseries_id"]),
  # Projection (crs)
  proj4string = CRS("+proj=eqc +lat_ts=0 +lat_0=0 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"))

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
