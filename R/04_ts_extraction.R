# 1. Required packages ----

library(tidyverse) # Core tidyverse packages
library(sf)

# 2. Import tropical storms (TS) data and modify CRS ----

load(file = "data/03_tropical-storms_raw/data_cyclones.RData")

data_cyclones <- st_transform(data_cyclones, crs = 7801) %>% # CRS in meters
  st_make_valid()

# 3. Import data on benthic cover and extract sites coordinates ----

load("data/04_benthic-cover_site-coordinates.RData")

site_coord_points <- site_coordinates %>% 
  st_as_sf(., coords = c("long", "lat"), crs = "+proj=longlat +datum=WGS84") %>% 
  st_transform(., crs = 7801) # CRS in meters

rm(site_coordinates)

# 4. Create a buffer around each sites coordinates ----

site_coord_buffer <- site_coord_points %>% 
  st_buffer(., dist = 100000) # 100,000 m = 100 km