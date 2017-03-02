#' Predicted Metrics
#' 
#' This function allows you to generate predicted metric scores based on data frame of stationIDs and site predictors.
#' Generate predicted metric scores based on site location predictors in O/E (RandomForest) model.  Output is table (stations by metrics). 
#' 
#' input data frame: 
#' head(NV.predictors)  
#' [1] "Sitecode"   "ELVmax_WS"  "PrdCond"    "SQ_KM"      "Tmax_WS"    "Pmin_WS"  
#' [7] "WDmax_WS"   "BFI_WS"     "HYDR_WS"    "Pmax_PT"    "ELVmin_WS"  "Tmax_PT"   
#' [13] "ELVcv_PT"   "ELVmean_WS" "Pmax_WS"    "Slope_WS"  
#
##############################################################################
# Nevada - MMI - predicted metrics
# modification of USU code (Vander Laan)
# cut down to just the predicted metric scores
# Erik.Leppo@tetratech.com
# 20170215
##################################
#
#
#' @param fun.df data frame of station IDs and site predictors.
#' @return Returns a data frame of stations and predicted metric values.
#' @keywords Nevada, NV, MMI, predicted, metrics, random forest
#' @examples
#' # Location of files.
#'path <- getwd()
#' setwd(path)
#' 
#' library("MMIcalcNV")
#' 
#' # Load Station Predictors
#' #prednew <- read.csv("predictors.20170215.csv")
#' prednew <- NV.predictors
#' head(prednew)
#' # Run function to get predicted metrics
#' new.metrics.pred <- metrics.predicted(prednew)
#' # Save the file
#' #write.csv(new.metrics.pred,"metrics_predicted.csv",row.names=FALSE)



##################
##Function
#' @export
metrics.predicted <- function(fun.df){##FUNCTION.metrics.predicted.START
  #
  #load("OE_MMI_models.rdata")
  #library(randomForest)
  #
  predictors <- fun.df
  # metrics
  INSET.pred      <- predict(INSET.rf, newdata=predictors, type="response")
  PER_CFA.pred    <- predict(PER_CFA.rf, newdata=predictors, type="response")
  PER_EPHEA.pred  <- predict(PER_EPHEA.rf, newdata=predictors, type="response")
  NONSET.pred     <- predict(NONSET.rf, newdata=predictors, type="response")
  CLINGER.pred    <- predict(CLINGER.rf, newdata=predictors, type="response")
  PER_PLECA.pred  <- predict(PER_PLECA.rf, newdata=predictors, type="response")
  SHDIVER.pred    <- NA
  #
  new.metrics.pred <- data.frame(prednew[,"Sitecode"]
                                 , INSET.pred
                                 , PER_EPHEA.pred
                                 , SHDIVER.pred
                                 , PER_CFA.pred
                                 , PER_PLECA.pred
                                 , NONSET.pred
                                 , CLINGER.pred)
  colnames(new.metrics.pred) <- c("Sitecode"
                                  , "INSET.pred"
                                  , "PER_EPHEA.pred"
                                  , "SHDIVER.pred"
                                  , "PER_CFA.pred"
                                  , "PER_PLECA.pred"
                                  , "NONSET.pred"
                                  , "CLINGER.pred")
  #
  return(new.metrics.pred)
  #
}##FUNCTION.metrics.predicted.START
##################