# 1. Load packages

library(tidyverse)
library(sf)
sf_use_s2(FALSE) # Switch from S2 to GEOS

# 2. Load and transform Reefs at Risk (RAR) data ----

data_rar <- read_sf("data/02_reefs-at-risk_reef-data/reef_500_poly.shp") %>% 
  st_transform(crs = 4326) %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>% 
  st_make_valid() %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>% 
  st_make_valid()

# 3. Load and transform Veron ecoregions data ----

load("data/ecoregions.RData")

ecoregions <- ecoregions %>% 
  st_transform(crs = 4326) %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>% 
  st_make_valid() %>% 
  st_wrap_dateline(options = c("WRAPDATELINE=YES")) %>% 
  st_make_valid()
  
# 4. Check if the CRS transformation has worked ---

ggplot() +
  geom_sf(data = ecoregions) +
  geom_sf(data = data_rar, col = "red")

# 5. Make the join ----

data_joined <- st_intersection(data_rar, ecoregions)

# 6. Save the data ----

save(data_joined, file = "data/data_joined.RData")
