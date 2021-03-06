% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IF_SoR.R
\name{IF.SoR}
\alias{IF.SoR}
\title{Influence Function - Sortino Ratio}
\usage{
IF.SoR(
  returns = NULL,
  evalShape = FALSE,
  retVals = NULL,
  nuisPars = NULL,
  k = 4,
  IFplot = FALSE,
  IFprint = TRUE,
  threshold = c("const", "mean")[1],
  const = 0,
  rf = 0,
  prewhiten = FALSE,
  ar.prewhiten.order = 1,
  cleanOutliers = FALSE,
  cleanMethod = c("locScaleRob")[1],
  eff = 0.99,
  ...
)
}
\arguments{
\item{returns}{Returns data of the asset or portfolio. This can be a numeric or an xts object.}

\item{evalShape}{Evaluation of the shape of the IF risk or performance measure if TRUE. Otherwise, a TS of the IF of the provided returns is computed.}

\item{retVals}{Values used to evaluate the shape of the IF.}

\item{nuisPars}{Nuisance parameters used for the evaluation of the shape of the IF (if no returns are provided).}

\item{k}{Range parameter for the shape of the IF (the SD gets multiplied k times).}

\item{IFplot}{If TRUE, the plot of the IF shape or IF TS of the returns is produced.}

\item{IFprint}{If TRUE, the data for the IF shape or the IF TS of the returns is returned.}

\item{threshold}{Parameter of threshold is either "mean" or "const". Default is "mean".}

\item{const}{The threshold if threshold is "const".}

\item{rf}{Risk-free interest rate.}

\item{prewhiten}{Boolean variable to indicate if the IF TS is pre-whitened (TRUE) or not (FALSE).}

\item{ar.prewhiten.order}{Order of AR parameter for the pre-whitening. Default is AR(1).}

\item{cleanOutliers}{Boolean variable to indicate whether outliers are cleaned with a robust location and scale estimator.}

\item{cleanMethod}{Robust method used to clean outliers from the TS. Default choice is "locScaleRob".}

\item{eff}{Tuning parameter for the normal distribution efficiency for the "locScaleRob" robust data cleaning.}

\item{...}{Addtional parameters.}
}
\value{
Influence function of SoR.
}
\description{
\code{IF.SoR} returns the data and plots the shape of either the IF or the IF TS for the Sortino Ratio.
}
\details{
For further details on the usage of the \code{nuisPars} argument, please refer to Section 3.1 for the \code{RPEIF} vignette.
}
\examples{
# Plot of IF with nuisance parameter with return value
outIF <- IF.SoR(returns = NULL, evalShape = TRUE, 
                retVals = NULL, nuisPars = NULL,
                 IFplot = TRUE, IFprint = TRUE)

data(edhec)
colnames(edhec) = c("CA", "CTAG", "DIS", "EM","EMN", "ED", "FIA",
                    "GM", "LS", "MA", "RV", "SS", "FoF") 

# Plot of IF a specified TS 
outIF <- IF.SoR(returns = edhec[,"CA"], evalShape = TRUE, 
                retVals = seq(-0.1, 0.1, by = 0.001), nuisPars = NULL,
                IFplot = TRUE, IFprint = TRUE)

# Computing the IF of the returns (with prewhitening) with a plot of IF TS
outIF <- IF.SoR(returns = edhec[,"CA"], evalShape = FALSE, 
                retVals = NULL, nuisPars = NULL,
                IFplot = TRUE, IFprint = TRUE,
                prewhiten = FALSE)

}
\author{
Anthony-Alexander Christidis, \email{anthony.christidis@stat.ubc.ca}
}
