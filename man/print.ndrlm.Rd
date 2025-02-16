\name{print.ndrlm}
\alias{print.ndrlm}

\title{
Print summary of Generalized Network-based Dimensionality Reduction and Linear Regression Model (NDRLM)
}
\description{
Print summary of Generalized Network-based Dimensionality Reduction and Linear Regression Model (NDRLM)
}
\usage{
\method{print}{ndrlm}(x, digits = getOption("digits"), ...)
}

\arguments{
  \item{x}{an object of class 'ndrlm'.}
  \item{digits}{the number of significant digits to use when \code{add.stats = TRUE}.}
  \item{...}{additional arguments affecting the summary produced.}
}
\references{
Kosztyán, Z. T., Katona, A. I., Kurbucz, M. T., & Lantos, Z. (2024). Generalized network-based dimensionality analysis. Expert Systems with Applications, 238, 121779. <URL:
https://doi.org/10.1016/j.eswa.2023.121779>.

}
\author{
Zsolt T. Kosztyan*, Marcell T. Kurbucz, Attila I. Katona

e-mail*: kzst@gtk.uni-pannon.hu
}


\seealso{\code{\link{biplot}}, \code{\link{plot}}, \code{\link{summary}}, \code{\link{ndrlm}}.}


\examples{
# Example of print function of NDRLM without optimization of fittings

X<-freeny.x
Y<-freeny.y
NDRLM<-ndrlm(Y,X,optimize=FALSE)
print(NDRLM)

}
\keyword{multivariate}
