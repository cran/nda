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

## ----association-comparison---------------------------------------------------
fit_full <- ndr(
  swiss, cor_method = "pearson", cor_type = "full",
  centrality = "pagerank", seed = 42
)
fit_partial <- ndr(
  swiss, cor_method = "pearson", cor_type = "partial",
  centrality = "pagerank", seed = 42
)
fit_semipartial <- ndr(
  swiss, cor_method = "pearson", cor_type = "semipartial",
  centrality = "authority", seed = 42
)

comparison <- data.frame(
  network = c("full", "partial", "semipartial"),
  factors = c(fit_full$factors, fit_partial$factors,
              fit_semipartial$factors),
  retained = c(sum(fit_full$membership > 0),
               sum(fit_partial$membership > 0),
               sum(fit_semipartial$membership > 0)),
  directed = c(fit_full$stats$directed,
               fit_partial$stats$directed,
               fit_semipartial$stats$directed)
)
comparison

## ----inspect-fit--------------------------------------------------------------
fit_full
summary(fit_full)
fit_full$membership
round(fit_full$loadings, 3)
round(fit_full$communality, 3)
fit_full$stats$community_sizes

## ----fixed-membership---------------------------------------------------------
visual_fit <- ndr(
  swiss,
  cor_method = "pearson",
  membership = c(1, 1, 2, 2, 2, 0),
  centrality = "eigenvector",
  seed = 42
)
data.frame(
  indicator = colnames(visual_fit$R),
  community = unname(visual_fit$membership)
)

## ----prediction---------------------------------------------------------------
new_scores <- predict(visual_fit, swiss[1:5, , drop = FALSE])
round(new_scores, 3)
identical(predict(visual_fit), visual_fit$scores)

## ----observation-clustering---------------------------------------------------
scaled_swiss <- scale(swiss)
distance_matrix <- as.matrix(dist(scaled_swiss))
similarity_matrix <- 1 - normalize(distance_matrix)
diag(similarity_matrix) <- 1

cluster_fit <- ndr(
  similarity_matrix,
  covar = TRUE,
  min_comm = 2,
  centrality = "eigenvector",
  seed = 42
)
cluster_fit$factors
table(cluster_fit$membership)
head(cluster_fit$membership, 10)
is.null(cluster_fit$scores)

## ----clustering-network, fig.cap="Observation clusters obtained from a normalized Euclidean similarity matrix."----
cluster_network <- plot(
  cluster_fit,
  cuts = 0.55,
  interactive = FALSE,
  show_weights = FALSE,
  shape = "automatic",
  vertex.label.size = 7,
  layout = "fr"
)
cluster_network

## ----ndr-static-network, fig.cap="NDR association network: colour denotes community, edge colour denotes sign, and width denotes absolute association."----
static_network <- plot(
  visual_fit,
  cuts = 0.3,
  interactive = FALSE,
  show_weights = TRUE,
  shape = "automatic"
)
static_network

## ----ndr-interactive-network--------------------------------------------------
interactive_network <- plot(
  visual_fit,
  cuts = 0.3,
  interactive = TRUE,
  show_weights = TRUE,
  shape = "automatic"
)
interactive_network$widget

## ----ndr-biplot, fig.cap="Two-factor NDR biplot for the fixed Swiss-data communities."----
score_biplot <- biplot(
  visual_fit,
  view_3D = FALSE,
  interactive = FALSE
)
score_biplot

## ----custom-network, fig.cap="Explicit common node shape, custom signed colours, and bounded edge widths."----
custom_network <- plot(
  visual_fit, interactive = FALSE,
  shape = rep("rectangle", ncol(visual_fit$R)),
  positive.color = "#007A53", negative.color = "#B71C1C",
  positive.lty = 1, negative.lty = 1,
  edge.width.range = c(1, 5), show_weights = TRUE
)
custom_network

## ----inference----------------------------------------------------------------
inference_fit <- ndr(
  swiss,
  cor_method = "pearson",
  test = TRUE,
  p_adjust = "BH",
  alpha = 0.10,
  bootstrap = TRUE,
  n_boot = 30,
  conf = 0.90,
  seed = 42
)
round(inference_fit$correlation_p, 3)
head(inference_fit$stats$bootstrap$lower)
head(inference_fit$stats$bootstrap$upper)

## ----sparse-fit---------------------------------------------------------------
sparse_fit <- ndr(
  swiss,
  min_R = 0.15,
  sparsecalc = TRUE,
  seed = 42
)
inherits(sparse_fit$R, "sparseMatrix")
sparse_fit$factors
sparse_fit$stats$community_sizes

