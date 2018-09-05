## [[file:~/git/allo/code/allo.org::*functions][functions:1]]
## generate_formula <- function(model_table, gen, sp, cit, clim, het) {
##     f <- filter(model_table, genus == gen, species == sp, cities == cit, climate == clim, hetero == het)

##     f[] <- gsub("\\vert", "|", f, fixed = T)


##     if(f$sigma == "") {
##         bf(formula(f$data), formula(f$b1), formula(f$b2), formula(f$b3), nl = T)
##     } else {
##         bf(f$data, f$b1, f$b2, f$b3, f$sigma, nl = T)
##     }
## }

generate_formula <- function(gen, sp, cit, clim, het, family) {
    if(family == "gaussian") {
        data_form <- formula(DBH ~ b0 + 100*b1 * (1 - exp(-(b2/100) * AGE ^ b3)))
        if(het == "linear") {
            v_form <- formula(sigma ~ AGE - 1)
        }
        if(het == "sqrt") {
            v_form <- formula(sigma ~ sqrt(AGE))
        }
        if (het == "smooth") {
            v_form <- formula(sigma ~  s(AGE))
        }
        if (het == "no") {
            v_form <- formula(sigma ~ 1)
        }
    }
    if (family == "Gamma") {
        data_form <- formula(DBH ~ b0 + 100*b1 * (1 - exp(-(b2/100) * AGE ^ (b3))))
        if (het == "no") {
            v_form <- formula(shape ~ 1)
        }
    }
    if(sp == "single") {
        if(cit == "single") {
            b0_form <- formula(b0 ~ 1)
            b1_form <- formula(b1 ~ 1)
            b2_form <- formula(b2 ~ 1)
            b3_form <- formula(b3 ~ 1)
        }
        if (cit == "many") {
            b0_form <- formula(b0 ~ (1 | City))
            b1_form <- formula(b1 ~ (1 | City))
            b2_form <- formula(b2 ~ (1 | City))
            b3_form <- formula(b3 ~ (1 | City))
        }
    }
    if (sp == "many") {
        if (gen == "none") {
            if(cit == "single") {
                b0_form <- formula(b0 ~ (1 | Species))
                b1_form <- formula(b1 ~ (1 | ID | Species))
                b2_form <- formula(b2 ~ (1 | Species))
                b3_form <- formula(b3 ~ (1 | ID | Species))
            }
            if (cit == "many") {
                b0_form <- formula(b0 ~ (1 | City) + (1 | Species))
                b1_form <- formula(b1 ~ (1 | City) + (1 | Species))
                b2_form <- formula(b2 ~ (1 | City) + (1 | Species))
                b3_form <- formula(b3 ~ (1 | City) + (1 | Species))
            }
        }
        if (gen == "many") {
            if(cit == "single") {
                b0_form <- formula(b0 ~ (1 | Genus/Species))
                b1_form <- formula(b1 ~ (1 | Genus/Species))
                b2_form <- formula(b2 ~ (1 | Genus/Species))
                b3_form <- formula(b3 ~ (1 | Genus/Species))
            }
            if (cit == "many") {
                b0_form <- formula(b0 ~ (1 | City) + (1 | Genus/Species))
                b1_form <- formula(b1 ~ (1 | City) + (1 | Genus/Species))
                b2_form <- formula(b2 ~ (1 | City) + (1 | Genus/Species))
                b3_form <- formula(b3 ~ (1 | City) + (1 | Genus/Species))
                if (clim == "b1linint") {
                    b1_form <- formula(b1 ~ Precip * GDD +  (1 | City) + (1 | Genus / Species))
                }
            }
        }
    }

    if (het == "no") {
        f <- bf(data_form, b0_form, b1_form, b2_form, b3_form, nl = T)
    } else {
        f <- bf(data_form, b0_form, b1_form, b2_form, b3_form, v_form, nl = T)
    }
    return(f)


}

generate_prior <- function (gen, sp, cit, clim, fam) {
    if(fam == "gaussian") {
        nlprior <- c(prior(gamma(7.5, 3), nlpar = "b0",lb = 0),
                     prior(gamma(8, 8), nlpar = "b1",lb = 0),       #mean = 4/3 = 1.3; variance = 4/9 = .4
                     prior(gamma(8, 8), nlpar = "b2", lb = 0),      #mean = 5/1 = 5; variance = 5/1 = 5
                     prior(gamma(8, 8), nlpar = "b3",lb = 0))

        if("many" %in% c(gen, sp, cit)) {

            nlprior <- c(nlprior,
                         prior(cauchy(0,1), class = "sd", nlpar = "b0"),
                         prior(cauchy(0,1), class = "sd", nlpar = "b1"),
                         prior(cauchy(0,1), class = "sd", nlpar = "b2"),
                         prior(cauchy(0,1), class = "sd", nlpar = "b3"))

        }

        if(clim == "b1") {
            nlprior <- c(nlprior,
                         prior(normal(0,.25), class = "sds", nlpar = "b1"))
        }

        if(hetero == "linear") {
            nlprior <- c(nlprior,
                         prior(gamma(1,10), class = "b", dpar = "sigma"))
        }

        if(hetero == "smooth") {
            nlprior <- c(nlprior,
                         prior(normal(1,.3), class = "b", dpar = "sigma"),
                         prior(normal(1,.3), class = "sds", dpar = "sigma"),
                         prior(normal(0,1), class = "Intercept", dpar = "sigma"))
        }
    }

    if(fam == "Gamma") {
        nlprior <- c(prior(gamma(7.5, 3), nlpar = "b0",lb = 0),
                     prior(gamma(8, 8), nlpar = "b1",lb = 0),       #mean = 4/3 = 1.3; variance = 4/9 = .4
                     prior(gamma(8, 8), nlpar = "b2", lb = 0),      #mean = 5/1 = 5; variance = 5/1 = 5
                     prior(gamma(8, 8), nlpar = "b3",lb = 0),
                     prior(gamma(5, .3), class = "shape"))

        if("many" %in% c(gen, sp, cit)) {

            nlprior <- c(nlprior,
                         prior(cauchy(0,1), class = "sd", nlpar = "b0"),
                         prior(cauchy(0,1), class = "sd", nlpar = "b1"),
                         prior(cauchy(0,1), class = "sd", nlpar = "b2"),
                         prior(cauchy(0,1), class = "sd", nlpar = "b3"))

        }

        if(clim == "b1") {
            nlprior <- c(nlprior,
                         prior(normal(0,.25), class = "sds", nlpar = "b1"))
        }

        if(hetero == "linear") {
            nlprior <- c(nlprior,
                         prior(gamma(1,10), class = "b", dpar = "sigma"))
        }

        if(hetero == "smooth") {
            nlprior <- c(nlprior,
                         prior(normal(1,.3), class = "b", dpar = "sigma"),
                         prior(normal(1,.3), class = "sds", dpar = "sigma"),
                         prior(normal(0,1), class = "Intercept", dpar = "sigma"))
        }
    }

    nlprior
}
## functions:1 ends here
