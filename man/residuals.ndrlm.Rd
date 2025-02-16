\name{residuals.ndrlm}
\alias{residuals.ndrlm}

\title{
Calculation of residual values of Generalized Network-based Dimensionality Reduction and Linear Regression Model (NDRLM)
}
\description{
Calculation of residual values of Generalized Network-based Dimensionality Reduction and Linear Regression Model (NDRLM)
}
\usage{
\method{residuals}{ndrlm}(object, ...)
}

\arguments{
  \item{object}{an object of class 'ndrlm'.}
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


\seealso{\code{\link{plot}}, \code{\link{print}}, \code{\link{ndrlm}}.}


\examples{
# Example of residual function of NDRLM without optimization of fittings

X<-freeny.x
Y<-freeny.y
NDRLM<-ndrlm(Y,X,optimize=FALSE)

# Normality test for residuals
shapiro.test(residuals(NDRLM))
}
\keyword{multivariate}
