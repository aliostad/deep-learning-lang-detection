/******************************************************************************
 *
 * TODO: Project Title
 *
 * Copyright (C) 2013 Lars Simon Zehnder. All Rights Reserved.
 * Web: -
 *
 * Author: Lars Simon Zehnder <simon.zehnder@gmail.com>
 *
 * This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
 * WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 ******************************************************************************/

// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>
#include "algorithms.h"

// [[Rcpp::export]]

arma::imat simulateEKOP_cc (const unsigned int nobs, const double alpha, 
        const double epsilon, const double delta, const double mu,
        const double T)
{
    arma::imat sample(nobs, 5);
    Rcpp::RNGScope scope;
    for (unsigned int i = 0; i < nobs; ++i) {
        if (R::runif(0, 1) < alpha) {
            if (R::runif(0, 1) > delta) {
                sample.at(i, 2) = R::rpois((epsilon + mu) * T);
                sample.at(i, 3) = R::rpois(epsilon * T);
                sample.at(i, 4) = sample.at(i, 2) + sample.at(i, 3);
            } else {
                sample.at(i, 2) = R::rpois(epsilon * T);
                sample.at(i, 3) = R::rpois((epsilon + mu) * T);
                sample.at(i, 4) = sample.at(i, 2) + sample.at(i, 3);
            }
        } else {
            sample.at(i, 2) = R::rpois(epsilon * T);
            sample.at(i, 3) = R::rpois(epsilon * T);
            sample.at(i, 4) = sample.at(i, 2) + sample.at(i, 3);
        }
    }    
    return sample;
}

// [[Rcpp::export]]

arma::imat simulateEKOPMis_cc(const unsigned int nobs, const double alpha,
        const double epsilon, const double delta, const double mu,
        const double mis, const double T)
{
    arma::imat sample(nobs, 5);
    Rcpp::RNGScope scope;
    arma::ivec x(2);
    x.at(0) = 0;
    x.at(1) = 1;
    arma::vec prob(2);
    prob.at(0) = 1.0 - mis;
    prob.at(1) = mis;
    for (unsigned int i = 0; i < nobs; ++i) {
        if (R::runif(0, 1) < alpha) {
            if (R::runif(0, 1) > delta) {
                sample.at(i, 2) = R::rpois((epsilon + mu) * T);
                sample.at(i, 3) = R::rpois(epsilon * T);
                sample.at(i, 4) = sample.at(i, 2) + sample.at(i, 3);        
            } else {
                sample.at(i, 2) = R::rpois(epsilon * T);
                sample.at(i, 3) = R::rpois((epsilon + mu) * T);
                sample.at(i, 4) = sample.at(i, 2) + sample.at(i, 3);
            }
        } else {
            sample.at(i, 2) = R::rpois(epsilon * T);
            sample.at(i, 3) = R::rpois(epsilon * T);
            sample.at(i, 4) = sample.at(i, 2) + sample.at(i, 3);
        }
        arma::ivec mis_b(sample.at(i, 2));
        arma::ivec mis_s(sample.at(i, 3));
        mis_b = sample_arma<arma::ivec, Rcpp::IntegerVector>(x, 
                sample.at(i, 2), true, prob);
        mis_s = sample_arma<arma::ivec, Rcpp::IntegerVector>(x, 
                sample.at(i, 3), true, prob);
        sample.at(i, 2) = sample.at(i, 2) - arma::sum(mis_b)
            + arma::sum(mis_s);
        sample.at(i, 3) = sample.at(i, 3) - arma::sum(mis_s)
            + arma::sum(mis_b);
        sample.at(i, 0) = arma::sum(mis_b);
        sample.at(i, 1) = arma::sum(mis_s);
    }
    return sample;
}
