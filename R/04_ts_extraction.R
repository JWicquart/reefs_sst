# 1. Required packages ----

library(tidyverse) # Core tidyverse packages
library(sf)

# 2. Import tropical storms (TS) data and modify CRS ----

load(file = "data/03_tropical-storms_raw/data_cyclones.RData")

data_cyclones <- st_transform(data_cyclones, crs = 7801) %>% # CRS in meters
  st_make_valid()

# 3. Import reefs distribution data and modify CRS ----

load("data/data_joined.RData")


ggplot() +
  geom_sf(data = data_joined)


data_joined <- data_joined %>% 
  st_transform(crs = 7801) %>% # CRS in meters
  st_make_valid() %>% 
  st_buffer(dist = 100000)


ggplot() +
  geom_sf(data = data_joined)
