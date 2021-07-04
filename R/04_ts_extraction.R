# 1. Required packages ----

library(tidyverse) # Core tidyverse packages
library(sf)

# 2. Import tropical storms (TS) data and make some transformations ----

load(file = "data/03_tropical-storms_raw/data_cyclones.RData")

# 2.1 Points data (TS position every ) --

data_cyclones_points <- data_cyclones %>% 
  group_by(ts_id) %>% 
  mutate(wind_speed = max(wind_speed)) %>% 
  st_transform(crs = 4326) %>% 
  st_make_valid()

# 2.2 Lines data (TS trajectories) --

data_cyclones_lines <- data_cyclones_points %>% 
  # Transform points to lines
  group_by(ts_id, wind_speed) %>%
  summarise(do_union = FALSE) %>%
  st_cast("LINESTRING") %>% 
  # Remove linestring with only one point (else error with the st_intersection() function)
  mutate(n = str_count(geometry, ",")) %>% 
  filter(n > 1) %>% 
  select(-n) %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>% 
  st_make_valid() %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>% 
  st_make_valid() %>% 
  st_transform(crs = 7801) %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>% 
  st_make_valid() %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>% 
  st_make_valid()



ggplot() +
  geom_sf(data = data_cyclones_lines)













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
