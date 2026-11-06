## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7.2,
  fig.height = 4.8,
  dpi = 96,
  fig.retina = 1,
  out.width = "100%",
  warning = FALSE,
  message = FALSE
)
library(nda)
set.seed(42)

## ----data-generation----------------------------------------------------------
dense_data <- data_gen(
  n = 40, m = 8, nfactors = 2,
  lambda = 1, seed = 42
)
dim(dense_data)
round(head(dense_data, 3), 3)

## ----sparse-generation--------------------------------------------------------
sparse_data <- data_gen(
  n = 60, m = 30, nfactors = 3,
  lambda = 1, sparse = TRUE, density = 0.20,
  seed = 42
)
class(sparse_data)
dim(sparse_data)
Matrix::nnzero(sparse_data) / length(sparse_data)

## ----normalization------------------------------------------------------------
small_matrix <- as.matrix(dense_data[1:5, 1:4])
round(normalize(small_matrix), 3)
round(normalize(small_matrix, type = "row", range = c(-1, 1)), 3)
round(normalize(small_matrix, type = "col"), 3)

## ----distance-association-----------------------------------------------------
association_data <- mtcars[, c("mpg", "disp", "hp", "wt")]

dcov_matrix <- dCov(association_data)
dcor_matrix <- dCor(association_data)
pdcor_matrix <- pdCor(association_data)
spdcor_matrix <- spdCor(association_data)

round(dcor_matrix, 3)
round(pdcor_matrix, 3)
round(spdcor_matrix, 3)

## ----distance-correlation-figure, fig.cap="Full, partial, and semipartial distance associations on a common visual scale."----
association_bubbles <- function(z, main) {
  z <- as.matrix(z)
  nr <- nrow(z); nc <- ncol(z)
  plot(c(0.5, nc + 0.5), c(0.5, nr + 0.5), type = "n",
       axes = FALSE, xlab = "", ylab = "", main = main, asp = 1)
  grid <- expand.grid(x = seq_len(nc), y = seq_len(nr))
  values <- as.vector(t(z[nr:1, , drop = FALSE]))
  symbols(grid$x, grid$y,
          squares = 0.65 * sqrt(pmin(1, abs(values))), inches = FALSE,
          bg = ifelse(values < 0, "#C62828", "#009E73"),
          fg = "white", add = TRUE)
  axis(1, at = seq_len(nc), labels = colnames(z), las = 2)
  axis(2, at = seq_len(nr), labels = rev(rownames(z)), las = 1)
  text(grid$x, grid$y, labels = formatC(values, digits = 2, format = "f"),
       cex = 0.65, col = "black")
  box()
}

op <- par(mfrow = c(1, 3), mar = c(6, 5, 3, 1))
association_bubbles(dcor_matrix, "Full dCor")
association_bubbles(pdcor_matrix, "Partial dCor")
association_bubbles(spdcor_matrix, "Semipartial dCor")
par(op)

## ----distance-test------------------------------------------------------------
dcor_test <- dCor(
  association_data[, c("mpg", "wt", "hp")],
  test = TRUE, R = 49, adjust = "BH"
)
round(dcor_test$r, 3)
round(dcor_test$p, 3)

## ----kmo-selection------------------------------------------------------------
kmo_selected <- fs.KMO(swiss, min_MSA = 0.50)
colnames(kmo_selected)
attr(kmo_selected, "removed")

## ----loading-selection--------------------------------------------------------
pca <- prcomp(swiss, scale. = TRUE, rank. = 2)
pca_selected <- fs.dimred(pca, swiss)
colnames(pca_selected$retained_DF)
names(pca_selected$dropped_low)
names(pca_selected$dropped_com)

## ----ndr-overview-------------------------------------------------------------
nda_fit <- ndr(
  swiss,
  cor_method = "spearman",
  cor_type = "full",
  centrality = "pagerank",
  seed = 42
)
nda_fit
summary(nda_fit)
head(predict(nda_fit, swiss))

## ----ndrlm-overview-----------------------------------------------------------
X_car <- mtcars[, setdiff(names(mtcars), "mpg")]
Y_car <- mtcars["mpg"]
input_membership <- c(
  cyl = 1, disp = 2, hp = 1, drat = 2, wt = 2,
  qsec = 1, vs = 1, am = 2, gear = 2, carb = 1
)

ndrlm_fit <- ndrlm(
  Y_car, X_car,
  latents = "in",
  optimize = FALSE,
  membership.X = input_membership,
  regression = "lm",
  seed = 42
)
summary(ndrlm_fit)
round(ndrlm_fit$NDAin$loadings, 3)
head(predict(ndrlm_fit, X_car))

## ----model-methods, fig.cap="Observed Swiss indicators. Colour indicates community; there are no latent nodes in this view."----
nda_network <- plot(
  nda_fit, interactive = FALSE, show_weights = TRUE,
  shape = "automatic"
)
nda_network

## ----model-biplot, fig.cap="Swiss observations and indicator directions on the fitted NDR score axes."----
nda_biplot <- biplot(
  nda_fit, view_3D = FALSE, interactive = FALSE
)
nda_biplot

## ----model-paths, fig.cap="Ten observed car indicators, two latent input predictors, and the observed mpg response."----
ndrlm_network <- plot(
  ndrlm_fit, sig = 1, interactive = FALSE,
  show_edge_labels = TRUE, shape = "automatic"
)
ndrlm_network

