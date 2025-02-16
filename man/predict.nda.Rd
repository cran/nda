\name{predict.nda}
\alias{predict.nda}

\title{
Calculation of predicted values of Generalized Network-based Dimensionality Reduction and Analysis (GNDA)
}
\description{
Calculation of predicted values of Generalized Network-based Dimensionality Reduction and Analysis (GNDA)
}
\usage{
\method{predict}{nda}(object, newdata, ...)
}

\arguments{
  \item{object}{An object of class 'nda'.}
  \item{newdata}{A required data frame in which to look for variables with which to predict.}
  \item{...}{further arguments passed to or from other methods.}
}

\value{

Residual values (data frame)
}
\references{
Kosztyán, Z. T., Katona, A. I., Kurbucz, M. T., & Lantos, Z. (2024). Generalized network-based dimensionality analysis. Expert Systems with Applications, 238, 121779. <URL:
https://doi.org/10.1016/j.eswa.2023.121779>.

}
\author{
Zsolt T. Kosztyan*, Marcell T. Kurbucz, Attila I. Katona

e-mail*: kosztyan.zsolt@gtk.uni-pannon.hu
}


\seealso{\code{\link{plot}}, \code{\link{print}}, \code{\link{ndr}}.}


\examples{
# Example of prediction function of GNDA
set.seed(1) # Fix the random seed
data(swiss) # Use Swiss dataset
resdata<-swiss
sample <- sample(c(TRUE, FALSE), nrow(resdata), replace=TRUE, prob=c(0.9,0.1))
train <- resdata[sample, ] # Split the dataset to train and test
test <- resdata[!sample, ]
p<-ndr(train) # Use GNDA only on the train dataset
P<-ndr(swiss) # USE GNDA on the entire dataset
res<-predict(p,test) # Calculate the prediction to the test dataset
real<-P$scores[!sample, ]
cor(real,res) # The correlation between original and predicted values
}
\keyword{multivariate}
