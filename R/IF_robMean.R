#' @title Influence Function - Robust M-Estimator of Mean
#' 
#' @description \code{IF.robMean} returns the data and plots the shape of either the IF or the IF TS for the M-estimator of Mean.
#'
#' @param returns Returns data of the asset or portfolio. This can be a numeric or an xts object.
#' @param family Family for robust m-estimator of Mean. Must be one of "mopt" (default), "opt" or "bisquare".
#' @param eff Tuning parameter for the normal distribution efficiency. Default is 0.99.
#' @param evalShape Evaluation of the shape of the IF risk or performance measure if TRUE. Otherwise, a TS of the IF of the provided returns is computed.
#' @param retVals Values used to evaluate the shape of the IF.
#' @param nuisPars Nuisance parameters used for the evaluation of the shape of the IF (if no returns are provided).
#' @param k Range parameter for the shape of the IF (the SD gets multiplied k times).
#' @param IFplot If TRUE, the plot of the IF shape or IF TS of the returns is produced.
#' @param IFprint If TRUE, the data for the IF shape or the IF TS of the returns is returned.
#' @param prewhiten Boolean variable to indicate if the IF TS is pre-whitened (TRUE) or not (FALSE).
#' @param ar.prewhiten.order Order of AR parameter for the pre-whitening. Default is AR(1).
#' @param ... Addtional parameters.
#'
#' @return Influence function for M-estimator of Mean
#' 
#' @details 
#' For further details on the usage of the \code{nuisPars} argument, please refer to Section 3.1 for the \code{RPEIF} vignette.
#'
#' @author Anthony-Alexander Christidis, \email{anthony.christidis@stat.ubc.ca}
#'
#' @export
#'
#' @examples
#' data(edhec, package = "PerformanceAnalytics")
#' colnames(edhec) = c("CA", "CTAG", "DIS", "EM","EMN", "ED", "FIA",
#'                     "GM", "LS", "MA", "RV", "SS", "FoF") 
#'                     
#' # Plot of IF shape
#' outIF <- IF.robMean(returns = edhec[,"CA"], evalShape = TRUE, 
#'                     retVals = NULL, 
#'                     IFplot = TRUE, IFprint = TRUE)
#' 
#' # Plot of IF a specified TS 
#' outIF <- IF.robMean(returns = edhec[,"CA"], evalShape = TRUE, 
#'                     retVals = seq(-0.1, 0.1, by = 0.001), 
#'                     IFplot = TRUE, IFprint = TRUE)
#' 
#' # Computing the IF of the returns (with prewhitening) with a plot of IF TS
#' outIF <- IF.robMean(returns = edhec[,"CA"], evalShape = FALSE, 
#'                     retVals = NULL, 
#'                     IFplot = TRUE, IFprint = TRUE,
#'                     prewhiten = FALSE)
#'
IF.robMean <- function(returns = NULL, family = c("mopt", "opt", "bisquare")[1], eff = 0.95,
                       evalShape = FALSE, retVals = NULL, nuisPars = NULL, k = 4,
                       IFplot = FALSE, IFprint = TRUE,
                       prewhiten = FALSE, ar.prewhiten.order = 1,
                       ...){
  
  # Checking input data
  DataCheckRob(returns = returns, family = family, eff = eff, 
               evalShape = evalShape, retVals = retVals, nuisPars = nuisPars, k = k,
               IFplot = IFplot, IFprint = IFprint,
               prewhiten = prewhiten, ar.prewhiten.order = ar.prewhiten.order)
  
  # Evaluation of nuisance parameters
  nuisPars <- NuisanceData(nuisPars)
  
  # Storing the dates
  if(xts::is.xts(returns))
    returns.dates <- zoo::index(returns)
  
  # Plot for shape evaluation
  if(evalShape){
    IFvals <- EvaluateShape(estimator = "robMean", family = family, eff = eff, 
                            retVals = retVals, returns = returns, k = k, nuisPars = nuisPars,
                            IFplot = IFplot, IFprint = IFprint)
    if(IFprint)
      return(IFvals) else{
        opt <- options(show.error.messages = FALSE)
        on.exit(options(opt)) 
        stop() 
      }
  }
  
  # IF Computation
  IF.robMean.vector <- IF.robMean.fn(x = returns, returns = returns, family = family, eff = eff)
  
  # Adding the pre-whitening functionality  
  if(prewhiten)
    IF.robMean.vector <- as.numeric(arima(x = IF.robMean.vector, order = c(ar.prewhiten.order,0,0), include.mean = TRUE)$residuals)
  
  # Adjustment for data (xts)
  if(xts::is.xts(returns))
    IF.robMean.vector <- xts::xts(IF.robMean.vector, returns.dates)
  
  # Plot of the IF TS
  if(isTRUE(IFplot)){
    print(plot(IF.robMean.vector, type = "l", main = "robMean Estimator Influence Function Transformed Returns", ylab = "IF"))
  }
  
  # Stop if no printing of the TS
  if(!IFprint){
    opt <- options(show.error.messages = FALSE)
    on.exit(options(opt)) 
    stop() 
  }
  
  # Returning the IF vector for robMean
  if(xts::is.xts(returns))
    return(xts::xts(IF.robMean.vector, returns.dates)) else
      return(IF.robMean.vector)
}