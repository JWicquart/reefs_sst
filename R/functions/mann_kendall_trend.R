mann_kendall_trend <- function(data){
  
  require(trend)
  
  data_ts <- ts(data$sst, frequency = 365.25, start = as.Date("1985-01-01"))
  
  data_mk <- tibble(p_value = mk.test(data_ts)$p.value)
  
  return(data_mk)
  
}