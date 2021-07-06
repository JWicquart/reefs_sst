ts_decomp <- function(data){
  
  # Transform to TS object
  data_ts <- ts(data$sst, frequency = 365.25, start = as.Date("1985-01-01"))
  
  # Decompose the TS
  data_ts_decomp <- decompose(data_ts, type = "additive")
  
  # Add to the data
  data <- data %>% 
    bind_cols(., 
              seasonal = data_ts_decomp$seasonal, 
              trend = data_ts_decomp$trend, 
              random = data_ts_decomp$random)
  
  return(data)
  
}