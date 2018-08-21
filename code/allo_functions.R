## [[file:~/git/allo/code/allo.org::*Libraries%20and%20functions][Libraries and functions:2]]
generate_formula <- function(model_table, gen, sp, cit, clim, het) {
      f <- filter(model_table, genus == gen, species == sp, cities == cit, climate == clim, hetero == het)

      f[] <- gsub("\\vert", "|", f, fixed = T)


      if(f$sigma == "") {
          bf(formula(f$data), formula(f$b0), formula(f$b1), formula(f$b2), nl = T)
      } else {
          bf(f$data, f$b0, f$b1, f$b2, f$sigma, nl = T)
      }
  }

  generate_prior <- function(gen, sp, cit, clim) {

      nlprior <- c(prior(gamma(7, 7), nlpar = "b0",lb = 0),       #mean = 4/3 = 1.3; variance = 4/9 = .4
                   prior(gamma(8, 8), nlpar = "b1", lb = 0),      #mean = 5/1 = 5; variance = 5/1 = 5
                   prior(gamma(8, 8), nlpar = "b2",lb = 0))

      if("many" %in% c(gen, sp, cit)) {

          nlprior <- c(nlprior,
                       prior(cauchy(0,.1), class = "sd", nlpar = "b0"),
                       prior(cauchy(0,.1), class = "sd", nlpar = "b1"),
                       prior(cauchy(0,.1), class = "sd", nlpar = "b2"))

      }

      if(clim == "b0") {
          nlprior <- c(nlprior,
                       prior(normal(.3,.25), class = "sds", nlpar = "b0"))
      }

      if(hetero == "linear") {
        nlprior <- c(nlprior,
                     prior(normal(1,.3), class = "b", dpar = "sigma"))
      }

      if(hetero == "smooth") {
               nlprior <- c(nlprior,
                            prior(normal(1,.3), class = "b", dpar = "sigma"),
                            prior(normal(1,.3), class = "sds", dpar = "sigma"),
                            prior(normal(0,1), class = "Intercept", dpar = "sigma"))
}


      nlprior
  }
## Libraries and functions:2 ends here
