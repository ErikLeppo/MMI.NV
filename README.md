# MMIcalcNV
Generate predicted metrics for Nevada MMI (USU 2012).

Installation
------------
library(devtools)

install.git_hub("leppott/MMIcalcNV")

Purpose
------------
Helper functions for the benthic macroinvertebrate Nevada multi-metric index developed by Utah State University (Jacob Vander Laan 2012) for NV DEP.

metrics.predicted() generates the predicted metric scores based on StationID and site predictors.  Generate predicted metric scores based on site location predictors in O/E (RandomForest) model.  Output is table (stations by metrics). 
input data frame:  

[1] "Sitecode"   "ELVmax_WS"  "PrdCond"    "SQ_KM"      "Tmax_WS"    "Pmin_WS" 

[7] "WDmax_WS"   "BFI_WS"     "HYDR_WS"    "Pmax_PT"    "ELVmin_WS"  "Tmax_PT" 

[13] "ELVcv_PT"   "ELVmean_WS" "Pmax_WS"    "Slope_WS"  

rarify() allows the user to generate a subsample at a fixed count.  Original R code by John Van Sickle (USEPA, Corvallis) version 1.0 2005-06-10.  Modified with a set "seed" so can reproduce results.

