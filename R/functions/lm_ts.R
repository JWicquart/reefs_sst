lm_ts <- function(data){
  
  lm_fit <- lm(formula = sst~date, data = data)
  
  data <- data %>% 
    bind_cols(., sst_fit = predict(lm_fit))
  
  return(data)
  
}