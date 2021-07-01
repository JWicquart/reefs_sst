# **Historical regime (1985-2020) of climate related disturbances in coral reefs ecoregions**


This repository contains code associated to the article:

Wicquart, J., Planes, S. Historical regime (1985-2020) of climate related disturbances in coral reefs ecoregions. Global Change Biology, _in prep_ (2021).

## How to download this project?

On the project main page on GitHub, click on the green button `Code` and then click on `Download ZIP`


## Description of the project

### 2.1 Project organization

This project is divided in 4 folders:

* :open_file_folder:	`data` folder contains 3 folders and 2 datasets (see part _2.2 Datasets description_).
* :open_file_folder:	`R` folder contains 5 _R_ codes and a `functions` folder (see part _2.3 Code description_).
* :open_file_folder:	`figs` folder contains the figures produced by the different R codes. 

### 2.2 Datasets description

The :open_file_folder: `data` folder contains three folders:

* * :open_file_folder: `01_sst_raw`
* * :open_file_folder: `02_reefs-at-risk_reef-data`
* * :open_file_folder: `03_tropical-storms_raw`

### 2.3 Code description

The :open_file_folder: `R` folder contains 5 R scripts:

* `01_reef-ecoregions-join`
* `02_sst_extraction`
* `03_ts_cleaning`
* `04_ts_extraction`
* `05_analyses`

## How to report issues?

Please report any bugs or issues [HERE](https://github.com/JWicquart/reefs_sst/issues).


## Reproducibility parameters

```R
R version 4.1.0 (2021-05-18)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 18363)

Matrix products: default

locale:
[1] LC_COLLATE=French_France.1252  LC_CTYPE=French_France.1252   
[3] LC_MONETARY=French_France.1252 LC_NUMERIC=C                  
[5] LC_TIME=French_France.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] forcats_0.5.1   stringr_1.4.0   dplyr_1.0.6     purrr_0.3.4     readr_1.4.0    
[6] tidyr_1.1.3     tibble_3.1.2    ggplot2_3.3.4   tidyverse_1.3.1

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.6       cellranger_1.1.0 pillar_1.6.1     compiler_4.1.0   dbplyr_2.1.1    
 [6] tools_4.1.0      jsonlite_1.7.2   lubridate_1.7.10 lifecycle_1.0.0  gtable_0.3.0    
[11] pkgconfig_2.0.3  rlang_0.4.11     reprex_2.0.0     cli_2.5.0        rstudioapi_0.13 
[16] DBI_1.1.1        haven_2.4.1      xml2_1.3.2       withr_2.4.2      httr_1.4.2      
[21] fs_1.5.0         generics_0.1.0   vctrs_0.3.8      hms_1.1.0        grid_4.1.0      
[26] tidyselect_1.1.1 glue_1.4.2       R6_2.5.0         fansi_0.5.0      readxl_1.3.1    
[31] modelr_0.1.8     magrittr_2.0.1   backports_1.2.1  scales_1.1.1     ellipsis_0.3.2  
[36] rvest_1.0.0      assertthat_0.2.1 colorspace_2.0-1 utf8_1.2.1       stringi_1.6.2   
[41] munsell_0.5.0    broom_0.7.7      crayon_1.4.1    

```
