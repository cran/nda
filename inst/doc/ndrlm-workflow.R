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

## ----latent-input-fit---------------------------------------------------------
X_car <- mtcars[, setdiff(names(mtcars), "mpg")]
Y_car <- mtcars["mpg"]
input_membership <- c(
  cyl = 1, disp = 2, hp = 1, drat = 2, wt = 2,
  qsec = 1, vs = 1, am = 2, gear = 2, carb = 1
)

fit_latent <- ndrlm(
  Y_car, X_car,
  latents = "in",
  optimize = FALSE,
  membership.X = input_membership,
  regression = "lm",
  seed = 42
)
fit_latent
summary(fit_latent)

## ----latent-input-results-----------------------------------------------------
data.frame(
  indicator = colnames(fit_latent$NDAin$R),
  community = unname(fit_latent$NDAin$membership)
)
round(fit_latent$NDAin$loadings, 3)
coef(fit_latent$fits[[1]])
fit_latent$fit_stats

## ----latent-prediction--------------------------------------------------------
prediction <- predict(fit_latent, X_car)
diagnostic <- data.frame(
  observed = Y_car$mpg,
  fitted = fitted(fit_latent)$mpg,
  residual = residuals(fit_latent)$mpg
)
head(prediction)
head(diagnostic)

## ----diagnostic-figure, fig.cap="Observed versus fitted fuel efficiency and residual diagnostic for the latent-input model."----
op <- par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
plot(diagnostic$observed, diagnostic$fitted,
     pch = 19, col = "#0072B2",
     xlab = "Observed mpg", ylab = "Fitted mpg",
     main = "Observed versus fitted")
abline(0, 1, col = "grey45", lty = 2)
plot(diagnostic$fitted, diagnostic$residual,
     pch = 19, col = "#009E73",
     xlab = "Fitted mpg", ylab = "Residual",
     main = "Residual pattern")
abline(h = 0, col = "grey45", lty = 2)
par(op)

## ----both-sides-fit-----------------------------------------------------------
X_both <- mtcars[, c("cyl", "disp", "hp", "wt", "qsec", "vs", "am", "gear")]
Y_both <- mtcars[, c("mpg", "drat")]

fit_both <- ndrlm(
  Y_both, X_both,
  latents = "both",
  optimize = FALSE,
  membership.X = c(1, 2, 1, 2, 1, 1, 2, 2),
  membership.Y = c(1, 1),
  regression = "lm",
  seed = 42
)
fit_both$NDAin$membership
fit_both$NDAout$membership
fit_both$indep_names
fit_both$dep_names
head(fitted(fit_both))

## ----engine-comparison--------------------------------------------------------
fit_ols <- fit_latent

if (requireNamespace("glmnet", quietly = TRUE)) {
  fit_ridge <- ndrlm(
    Y_car, X_car,
    latents = "in", optimize = FALSE,
    membership.X = input_membership,
    regression = "ridge", lambda = 0.05,
    seed = 42
  )
  fit_elastic <- ndrlm(
    Y_car, X_car,
    latents = "in", optimize = FALSE,
    membership.X = input_membership,
    regression = "elastic_net", alpha = 0.5, lambda = 0.05,
    seed = 42
  )
  engine_results <- rbind(
    OLS = fit_ols$fit_stats,
    Ridge = fit_ridge$fit_stats,
    Elastic_net = fit_elastic$fit_stats
  )
  engine_results
  round(cbind(
    ridge = fit_ridge$fits[[1]]$standardized_coefficients,
    elastic_net = fit_elastic$fits[[1]]$standardized_coefficients
  ), 3)
} else {
  cat("Install the suggested package 'glmnet' to run ridge and elastic net.\n")
}

## ----loess-fit----------------------------------------------------------------
fit_loess <- ndrlm(
  Y_car,
  X_car["wt"],
  latents = "none",
  regression = "loess",
  loess_span = 0.80
)
head(predict(fit_loess, X_car["wt"]))
fit_loess$fit_stats

## ----optimization-------------------------------------------------------------
fit_optimized <- ndrlm(
  Y_car, X_car,
  latents = "in",
  membership.X = input_membership,
  optimize = TRUE,
  target = "adj.r.square",
  rel_weight = TRUE,
  lower.bounds.x = rep(0.5, ncol(X_car)),
  upper.bounds.x = rep(1.5, ncol(X_car)),
  lower.bounds.latentx = c(0, 0, 0, 0),
  upper.bounds.latentx = c(0.01, 0.01, 0.01, 0.01),
  popsize = 4,
  generations = 3,
  restarts = 1,
  regression = "lm",
  seed = 42
)
fit_optimized$optimized
fit_optimized$fval
round(fit_optimized$NDAin_weight, 3)
tail(fit_optimized$NSGA_trace)

## ----convergence-figure, fig.cap="Best adjusted R-squared encountered during the compact NSGA-II run."----
trace <- fit_optimized$NSGA_trace
plot(
  trace$evaluation,
  trace$best_target,
  type = "s", lwd = 2, col = "#0072B2",
  xlab = "Objective evaluation",
  ylab = "Best adjusted R-squared",
  main = "NSGA-II search history"
)
points(trace$evaluation, trace$target_value,
       pch = 16, cex = 0.65, col = grDevices::adjustcolor("grey35", 0.45))
lines(trace$evaluation, trace$best_target, lwd = 2, col = "#0072B2")

## ----ndrlm-static-network, fig.cap="Both-sides NDRLM graph. Rectangles are observed indicators, circles are latent variables, and path colour carries sign."----
path_network <- plot(
  fit_both,
  sig = 1,
  interactive = FALSE,
  show_edge_labels = TRUE,
  shape = "automatic"
)
path_network

## ----ndrlm-interactive-network------------------------------------------------
interactive_path_network <- plot(
  fit_both,
  sig = 1,
  interactive = TRUE,
  show_edge_labels = TRUE,
  shape = "automatic"
)
interactive_path_network$widget

