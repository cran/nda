\name{predict.ndrlm}
\alias{predict.ndrlm}

\title{
Calculation of predicted values of Generalized Network-based Dimensionality Reduction and Regression with Linear Models (NDRLM)
}
\description{
Calculation of predicted values of Generalized Network-based Dimensionality Reduction and Regression with Linear Models (NDRLM)
}
\usage{
\method{predict}{ndrlm}(object, newdata,
         se.fit = FALSE, scale = NULL, df = Inf,
        interval = c("none", "confidence", "prediction"),
        level = 0.95, type = c("response", "terms"),
        terms = NULL, na.action = stats::na.pass,
        pred.var = 1/weights, weights = 1, ...)
}

\arguments{
  \item{object}{An object of class 'ndrlm'.}
  \item{newdata}{An optional data frame in which to look for variables with which to predict. If omitted, the fitted values are used.}
  \item{se.fit}{A switch indicating if standard errors are required.}
  \item{scale}{Scale parameter for std.err. calculation.}
  \item{df}{Degrees of freedom for scale.}
  \item{interval}{Type of interval calculation. Can be abbreviated.}
  \item{level}{Tolerance/confidence level.}
  \item{type}{Type of prediction (response or model term). Can be abbreviated.}
  \item{terms}{If type = "terms", which terms (default is all terms), a character vector.}
  \item{na.action}{function determining what should be done with missing values in newdata. The default is to predict NA.}
  \item{pred.var}{the variance(s) for future observations to be assumed for prediction intervals. See ‘Details’.}
  \item{weights}{the variance(s) for future observations to be assumed for prediction intervals. See ‘Details’.}
  \item{...}{further arguments passed to or from other methods.}
}

\details{
predict.ndrlm produces predicted values, obtained by evaluating the multiple regression function and model reduction by GNDA in the frame newdata (which defaults to model.frame(object)). If the logical se.fit is TRUE, standard errors of the predictions are calculated. If the numeric argument scale is set (with optional df), it is used as the residual standard deviation in the computation of the standard errors, otherwise this is extracted from the model fit. Setting intervals specifies computation of confidence or prediction (tolerance) intervals at the specified level, sometimes referred to as narrow vs. wide intervals.

If the fit is rank-deficient, some of the columns of the design matrix will have been dropped. Prediction from such a fit only makes sense if newdata is contained in the same subspace as the original data. That cannot be checked accurately, so a warning is issued.

If newdata is omitted the predictions are based on the data used for the fit. In that case how cases with missing values in the original fit are handled is determined by the na.action argument of that fit. If na.action = na.omit omitted cases will not appear in the predictions, whereas if na.action = na.exclude they will appear (in predictions, standard errors or interval limits), with value NA. See also napredict.

The prediction intervals are for a single observation at each case in newdata (or by default, the data used for the fit) with error variance(s) pred.var. This can be a multiple of res.var, the estimated value of standard deviation: the default is to assume that future observations have the same error variance as those used for fitting. If weights is supplied, the inverse of this is used as a scale factor. For a weighted fit, if the prediction is for the original data frame, weights defaults to the weights used for the model fit, with a warning since it might not be the intended result. If the fit was weighted and newdata is given, the default is to assume constant prediction variance, with a warning.


}

\value{

predict.ndrlm produces list of a vector of predictions or a matrix of predictions and bounds with column names fit, lwr, and upr if interval is set. For type = "terms" this is a matrix with a column per term and may have an attribute "constant".

The 'prediction' list contains the following element:

\item{fit}{vector or matrix as above}
\item{se.fit}{residual standard deviations}
\item{residual.scale}{residual standard deviations}
\item{df}{degrees of freedom for residual}

}
\references{
Kosztyán, Z. T., Katona, A. I., Kurbucz, M. T., & Lantos, Z. (2024). Generalized network-based dimensionality analysis. Expert Systems with Applications, 238, 121779. <URL:
https://doi.org/10.1016/j.eswa.2023.121779>.
}

\note{
Variables are first looked for in newdata and then searched for in the usual way (which will include the environment of the formula used in the fit). A warning will be given if the variables found are not of the same length as those in newdata if it was supplied.

Notice that prediction variances and prediction intervals always refer to future observations, possibly corresponding to the same predictors as used for the fit. The variance of the residuals will be smaller.

Strictly speaking, the formula used for prediction limits assumes that the degrees of freedom for the fit are the same as those for the residual variance. This may not be the case if res.var is not obtained from the fit.
}

\author{
Zsolt T. Kosztyan*, Marcell T. Kurbucz, Attila I. Katona

e-mail*: kosztyan.zsolt@gtk.uni-pannon.hu
}


\seealso{\code{\link{plot}}, \code{\link{print}}, \code{\link{ndr}}.}


\examples{
# Example of prediction function of NDRLM without optimization of fittings

set.seed(1)
X<-as.data.frame(freeny.x)
Y<-as.data.frame(freeny.y)
sample <- sample(c(TRUE, FALSE), nrow(X), replace=TRUE, prob=c(0.9,0.1))
train.X <- X[sample, ] # Split the dataset X to train and test
test.X <- X[!sample, ]
train.Y <- as.data.frame(Y[sample,]) # Split the dataset Y to train and test
colnames(train.Y)<-colnames(Y)
test.Y <- as.data.frame(Y[!sample,])
colnames(test.Y)<-colnames(Y)
train<-cbind(train.Y,train.X)
test<-cbind(test.Y,test.X)
res<-predict(lm(x~.,train),test)
cor(test.Y,res) # The correlation between original and predicted values

# Use NDRLM without optimization
NDRLM<-ndrlm(train.Y,train.X,optimize=FALSE)

# Calculate the prediction to the test dataset
res<-predict(NDRLM,test)
cor(test.Y,res[[1]]) # The correlation between original and predicted values

}
\keyword{multivariate}
