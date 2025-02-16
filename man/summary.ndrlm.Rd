\name{summary.ndrlm}
\alias{summary.ndrlm}

\title{
Summary function of Generalized Network-based Dimensionality Reduction and Linear Regression Model (NDRLM)
}
\description{
Print summary of Generalized Network-based Dimensionality Reduction and Linear Regression Model (NDRLM)
}
\usage{
\method{summary}{ndrlm}(object, digits = getOption("digits"), ...)
}

\arguments{
  \item{object}{an object of class 'ndrlm'.}
  \item{digits}{the number of significant digits to use when \code{add.stats = TRUE}.}
  \item{...}{additional arguments affecting the summary produced.}
}

\value{

\item{Call}{Callback function}
\item{fval}{Objective function for fitting}
\item{pareto}{in the case of multiple objectives TRUE (default value) provides pareto-optimal solution, while FALSE provides weighted mean of objective functions (see out_weights)}
\item{X}{A numeric data frame of input variables}
\item{Y}{A numeric data frame of output variables}
\item{NDA}{GNDA object, which is the result of model reduction and features selection}
\item{fits}{List of linear regrassion models}
\item{NDA_weight}{Weights of input variables (used in \code{\link{ndr}})}
\item{NDA_min_evalue}{Optimized minimal eigenvector centrality value (used in \code{\link{ndr}})}
\item{NDA_min_communality}{Optimized minimal communality value of indicators (used in \code{\link{ndr}})}
\item{NDA_com_communalities}{Optimized
minimal common communalities (used in \code{\link{ndr}})}
\item{NDA_min_R}{Optimized
minimal square correlation between indicators (used in \code{\link{ndr}})}
\item{NSGA}{Outpot structure of NSGA-II optimization (list), if the optimization value is true (see in \code{\link[mco:nsga2]{mco::nsga2}})}
\item{fn}{Function (regression) name: NDLM}
}
\references{
Kosztyán, Z. T., Katona, A. I., Kurbucz, M. T., & Lantos, Z. (2024). Generalized network-based dimensionality analysis. Expert Systems with Applications, 238, 121779. <URL:
https://doi.org/10.1016/j.eswa.2023.121779>.

}
\author{
Zsolt T. Kosztyan*, Marcell T. Kurbucz, Attila I. Katona

e-mail*: kosztyan.zsolt@gtk.uni-pannon.hu
}


\seealso{\code{\link{biplot}}, \code{\link{plot}}, \code{\link{print}}, \code{\link{ndrlm}}.}


\examples{
# Example of summary function of NDRLM without optimization of fittings

X<-freeny.x
Y<-freeny.y
NDRLM<-ndrlm(Y,X,optimize=FALSE)
summary(NDRLM)

}
\keyword{multivariate}
