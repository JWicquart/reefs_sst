dhw_calculation <- function(data){
  
  require(tidyverse)
  require(RcppRoll) # For rolling functions
  require(lubridate)
  
  results <- data %>% 
    # Calculate mean sst by month for each site
    dplyr::mutate(month = month(date)) %>% 
    dplyr::group_by(ecoregion, month) %>% 
    dplyr::summarise(mean = mean(sst)) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(-month) %>% 
    # Extract Maximum Monthly Mean (MMM) for each site
    dplyr::group_by(ecoregion) %>% 
    dplyr::filter(mean == max(mean)) %>% 
    # Calculate the bleaching threshold (MMM + 1°C)
    dplyr::mutate(threshold = mean + 1) %>% 
    dplyr::ungroup() %>% 
    # Join with the SST data
    dplyr::left_join(data, .) %>%
    # Calculate Degree Heating Weeks
    dplyr::group_by(ecoregion) %>% 
    dplyr::mutate(delta = ifelse(sst >= threshold, sst - threshold, 0)) %>% 
    dplyr::arrange(date) %>% 
    # 7 days * 12 weeks = 84 days
    dplyr::mutate(dhw = roll_sum(x = delta, n = 84, align = "center", fill = NA)) %>% 
    dplyr::select(-delta, -mean) %>% 
    # Calculate SST anomaly
    mutate(mean = mean(sst, na.rm = TRUE),
           sst_anomaly = sst - mean,
           sst_anomaly_mean = roll_mean(x = sst_anomaly, n = 365, align = "center", fill = NA),
           sst_anomaly_type = ifelse(sst_anomaly_mean > 0,"#ec644b", "#59abe3"))
  
  return(results)
  
}