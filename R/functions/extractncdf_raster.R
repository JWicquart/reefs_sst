extractncdf_raster <- function(data_raster, data_polygon){
  
  # Load raster file
  ncdf_i <- raster(data_raster, varname = "analysed_sst")
  
  # Transform its crs
  crs(ncdf_i) <- crs_used
  
  # Extract mean SST for each polygon
  sst_extracted <- raster::extract(ncdf_i, data_polygon, fun = mean, na.rm = TRUE, sp = TRUE)
  
  # Transform to dataframe and add date
  sst_extracted <- as_tibble(sst_extracted@data)
  
  return(sst_extracted)
  
}