#-----------------------------------------------------------------------------#
#                                                                             #
#  GENERALIZED NETWORK-BASED DIMENSIONALITY REDUCTION AND ANALYSIS (GNDA)     #
#                                                                             #
#  Written by: Zsolt T. Kosztyan*, Marcell T. Kurbucz, Attila I. Katona       #
#              *Department of Quantitative Methods                            #
#              University of Pannonia, Hungary                                #
#              kosztyan.zsolt@gtk.uni-pannon.hu                               #
#                                                                             #
# Last modified: February 2023                                                #
#-----------------------------------------------------------------------------#
#' @export
summary.nda <- function(object,  digits =  getOption("digits"), ...) {
  if (!requireNamespace("stats", quietly = TRUE)) {
    stop(
      "Package \"stats\" must be installed to use this function.",
      call. = FALSE
    )
  }
  if ("nda" %in% class(object)){
    communality <- object$communality
    loadings <- object$loadings
    uniqueness <- object$uniqueness
    factors <- object$factors
    scores <- object$scores
    n.obs <- object$n.obs
    factors <- object$factors
    cat("\nSummary of the NDA:\n")
    cat("\nNumber of latent variables: ",factors)
    cat("\nNumber of observations: ",n.obs)
    cat("\nCommunalities:\n")
    print(communality,digits = digits, ...)
    cat("\nFactor loadings:\n")
    print(loadings,digits = digits, ...)
    if (!is.null(scores)){
      cat("\n\nCorrelation matrix of factor scores:\n")
      print(stats::cor(scores),digits = digits, ...)
    }
  }else{
    summary(object,...)
  }
}
