\name{plot.ndrlm}
\alias{plot.ndrlm}
\title{
Plot function for Generalized Network-based Dimensionality Reduction and Regression (GNDR)
}
\description{
Plot the structural equation model, based on the GNDR
}
\usage{
\method{plot}{ndrlm}(x, sig=0.05, interactive=FALSE,...)
}
\arguments{
  \item{x}{An object of class 'NDRLM'.}
  \item{sig}{Significance level of relationships}
  \item{interactive}{Plot interactive visNetwork graph or non-interactive igraph plot (default FALSE).}
  \item{...}{other graphical parameters.}
}
\references{
Kosztyán, Z. T., Katona, A. I., Kurbucz, M. T., & Lantos, Z. (2024). Generalized network-based dimensionality analysis. Expert Systems with Applications, 238, 121779. <URL:
https://doi.org/10.1016/j.eswa.2023.121779>.

}
\author{
Zsolt T. Kosztyan*, Marcell T. Kurbucz, Attila I. Katona

e-mail*: kosztyan.zsolt@gtk.uni-pannon.hu
}

\seealso{\code{\link{summary}}, \code{\link{ndr}},\code{\link{ndrlm}}.}

\examples{
# Plot function for non-optimized SEM

X<-freeny.x
Y<-freeny.y
NDRLM<-ndrlm(Y,X,optimize=FALSE)
plot(NDRLM)
}
\keyword{multivariate}
\concept{plots}
