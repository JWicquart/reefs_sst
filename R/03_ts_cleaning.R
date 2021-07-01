# 1. Required packages ----

library(tidyverse) # Core tidyverse packages
library(sf) # To plot maps

# 2. Load and modify data ----

# To skip the second row
all_content <- readLines("data/03_tropical-storms_raw/ibtracs.ALL.list.v04r00.csv")
all_content <- all_content[-2]
# data_cyclones <- read.csv("./../data/ibtracs.ALL.list.v04r00.csv") # Without skipping the 2nd row

data_cyclones <- read.csv(textConnection(all_content), header = TRUE, stringsAsFactors = FALSE) %>% 
  # Select useful variables
  select(SID, NAME, ISO_TIME, LAT, LON, STORM_SPEED,
         ends_with("WIND"), # Select all columns ending by WIND (wind speed of each RSMC)
         -WMO_WIND) %>% 
  # Coalesce to put all wind speed in a unique column
  mutate(WIND_SPEED = coalesce(MLC_WIND, TOKYO_WIND, CMA_WIND,
                               HKO_WIND, NEWDELHI_WIND, REUNION_WIND, BOM_WIND, 
                               NADI_WIND, WELLINGTON_WIND, DS824_WIND, TD9636_WIND, 
                               TD9635_WIND, NEUMANN_WIND, USA_WIND)) %>% 
  select(-ends_with("WIND")) %>% 
  mutate(WIND_SPEED = WIND_SPEED*1.852, # Convert from knots to km/h
         WIND_SPEED = ifelse(WIND_SPEED < 0, NA, WIND_SPEED), # NA values if below 0
         NAME = ifelse(NAME == "NOT_NAMED", NA, NAME),
         STORM_SPEED = STORM_SPEED*1.852) %>% # Convert from knots to km/h
  rename(ts_id = SID, name = NAME, time = ISO_TIME,
         lat = LAT, long = LON, storm_speed = STORM_SPEED, wind_speed = WIND_SPEED) %>% 
  mutate(long = ifelse(long > 180, long - 360, long)) %>% # Transform long greater than 180
  st_as_sf(., coords = c("long", "lat"), crs = 4326) %>% 
  st_make_valid()

# 3. Save transformed data ----

save(data_cyclones, file = "data/03_tropical-storms_raw/data_cyclones.RData")