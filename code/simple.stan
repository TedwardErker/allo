// generated with brms 2.3.1
functions {
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  int<lower=1> K_sigma;  // number of population-level effects
  matrix[N, K_sigma] X_sigma;  // population-level design matrix
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
}
parameters {
  real temp_Intercept;  // temporary intercept
  vector[K_sigma] b_sigma;  // population-level effects
}
transformed parameters {
}
model {
  vector[N] mu = rep_vector(0, N) + temp_Intercept;
  vector[N] sigma = X_sigma * b_sigma;
  for (n in 1:N) {
    sigma[n] = exp(sigma[n]);
  }
  // priors including all constants
  target += student_t_lpdf(temp_Intercept | 3, 0, 10);
  // likelihood including all constants
  if (!prior_only) {
    target += normal_lpdf(Y | mu, log(sigma));
  }
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = temp_Intercept;
}
