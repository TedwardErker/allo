// generated with brms 2.3.1
functions {
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  int<lower=1> K_b0;  // number of population-level effects
  matrix[N, K_b0] X_b0;  // population-level design matrix
  int<lower=1> K_b1;  // number of population-level effects
  matrix[N, K_b1] X_b1;  // population-level design matrix
  int<lower=1> K_b2;  // number of population-level effects
  matrix[N, K_b2] X_b2;  // population-level design matrix
  // covariate vectors
  vector[N] C_1;
  int<lower=1> K_sigma;  // number of population-level effects
  matrix[N, K_sigma] X_sigma;  // population-level design matrix
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
}
parameters {
  vector<lower=0>[K_b0] b_b0;  // population-level effects
  vector<lower=0>[K_b1] b_b1;  // population-level effects
  vector<lower=0>[K_b2] b_b2;  // population-level effects
  vector[K_sigma] b_sigma;  // population-level effects
}
transformed parameters {
}
model {
  vector[N] mu_b0 = X_b0 * b_b0;
  vector[N] mu_b1 = X_b1 * b_b1;
  vector[N] mu_b2 = X_b2 * b_b2;
  vector[N] mu;
  vector[N] sigma = X_sigma * b_sigma;
  for (n in 1:N) {
    sigma[n] = exp(sigma[n]);
    // compute non-linear predictor
    mu[n] = 100 * mu_b0[n] * (1 - exp( - (mu_b1[n] / 100) * C_1[n] ^ mu_b2[n]));
  }
  // priors including all constants
  target += gamma_lpdf(b_b0 | 1, 2)
    - 1 * gamma_lccdf(0 | 1, 2);
  target += gamma_lpdf(b_b1 | 1, 2)
    - 1 * gamma_lccdf(0 | 1, 2);
  target += gamma_lpdf(b_b2 | 1, 2)
    - 1 * gamma_lccdf(0 | 1, 2);
  // likelihood including all constants
  if (!prior_only) {
    target += normal_lpdf(Y | mu, log(sigma));
  }
}
generated quantities {
}
