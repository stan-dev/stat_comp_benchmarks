# Statistical Computation Benchmarks
Benchmark Models for Evaluating Algorithm Accuracy

This repository includes a very preliminary suite of models, specified as Stan programs, for evaluating the accuracy of Bayesian statistical computation algorithms.  

Recall that the only role of a proper Bayesian computational algorithm is to estimate expectations with respect to a given posterior distribution.  The means of each parameter, transformed paramamter, and generated quantity in each benchmark model has been computed to high accuracy for evaluating new algorithms.  A given estimate, `mu_est`, passes only if `(mu_est - mu_true) / sigma_true < 0.25`, in other words if the algorithm can reasonably locate the mean to the center of the posterior.  No validation of posterior variances is considered outside of those explicitly defined in the generated quantities block of some models.

Each Stan program in the benchmark, and any necessary data, are located in the `benchmarks` folder.  Each Stan program is accompanied with a `<model_name>.info` file describing the model.

To test a new algorithm create the folder `empirical_results/<algorithm_name>` and add to it a text file called `<model_name>.fit` for each model you would like to evaluate.  Each `<model_name>.fit` itself should consist of two columns separated with a space -- the first for the parameter name and the second for the estimated expectation value.  Change line 5 of the shell script `evaluate` to `algo=<algorithm_name>` and run from the command line,

```
> ./ evaluate
```

The shell script will compare each parameter for each model included, listing the results as it goes as well as summary information at the end.
