---
title: "Data Science Methods"
subtitle: "Theory and Application"
author: Linli
format: 
  revealjs:
    keep-md: true
    slide-level: 3
    reference-location: document
    
    smaller: true
    scrollable: true
    incremental: true
    
    theme: default
    width: 1050
    margin: 0.1
    fig-width: 9
    fig-height: 5
    chalkboard: 
      theme: whiteboard
      boardmarker-width: 5
editor: visual
---


::: {.cell}

:::


# The Elements of Statistical Learning: Data Mining, Inference, and Prediction

::: column-margin

------------------------------------------------------------------------

Hastie, Trevor, et al. The elements of statistical learning: data
mining, inference, and prediction. Vol. 2. New York: springer, 2009.
:::

## The Elements of Statistical Learning {auto-animate="true"}

::: nonincremental
-   Supervised learning: predicts (classify or regress) an outcome based
    on some input measures
-   Unsupervised learning: cluster (auto-classify) or association
    (similarity) unlabeled input measures
:::

::: column-margin
The book covered: Linear methods, regularization & smoothing, additive
trees, random forests, neural networks, ensemble learning, and graphical
models
:::

## The Elements of Statistical Learning {auto-animate="true"}

::: nonincremental
::: {.fragment .highlight-blue}
-   Supervised learning: predicts (classify or regress) an outcome based
    on some input measures
:::

-   Unsupervised learning: cluster (auto-classify) or association
    (similarity) unlabeled input measures
:::

# Regression Modeling Strategies

::: column-margin

------------------------------------------------------------------------

Frank, E. H. (2015). Regression modeling strategies with applications to
linear models, logistic and ordinal regression, and survival analysis.
:::

## Why data models?

-   make predictive regression models and let it guide your data
    collection

### 1. Regression \> Hypothesis testing

::: nonincremental
-   Regression (i.e. "predictive modeling") is better than hypothesis
    testing
    -   more than test significance of a statistics, but also estimate
        magnitudes of effects
    -   models may be used to incorporate complex sampling/ measurements
        and conduct many different statistical tests ("Prediction -- a
        superset of hypothesis testing and estimation")
:::

::: {.fragment .highlight-blue}
-   Multivariable regression/modeling is even better: it contains
    important variables and controls them constant so we can estimate
    absolute effects of the variable of interest.
:::

### 2. Prediction \> Classification

-   Prediction model regards outcomes on a **continuum**, while
    classification model forces **dichotomous** outcomes which cause
    information loss [^1]
-   Prediction model may be a necessary first step for building
    classification rules (for a classification model)

[^1]: This also applies to data collection state. We may always use
    continuous variables over categorical ones (which reduces
    measurement errors)

## Choosing Data Models

### Model-guided Data Collection

-   Design data collection with prediction model in mind
    -   stratified sampling (with weights that are representative to the
        population)
    -   cover all important predictors - preferably with their baseline
        measurements
    -   define variables - with reliable and valid measurements verified
    -   specify in-dependency/interaction as well as distribution
        assumption
    -   plans for reducing missing data

### Basic principle for choosing data models

-   Choose model based on the **types of outcomes** (ordinal do NOT
    polytomous/multi-nomial model; continuous do NOT logistic model)

-   Develop a model **empirically** (validate different model accuracy
    [^2]) based on the differences between the predicted value (in the
    training set, often bagged [^3] or boosted [^4]) and the observed
    value (in the test set)

-   Understand pros and cons of different types of data models
    (Stochastic vs Algorithmic)

[^2]: i.e. measure generalization error or infinite test set error which
    indicate prediction accuracy

[^3]: bag (bootstrap aggregate) is to "random sample" the training set
    for k times, each time get a f(x) function. For a regression model,
    the bagged predictors are the average over the 1th to kth f(x). For
    a classification model, the bagged predictor is the class that has
    the plurity/most vote from the 1th to kth f(x).

[^4]: instead of random sampling the training set, altering weights on
    he training set to ensemble predictors in a classification model

### Types of models

-   **Parametric/frequentist** (assume probability distribution) vs
    **Non-parametric/ Bayesian** regression models [^5]
    -   Frequentist approach assumes a random/stochastic sample and aims
        to estimate null hypothesis (fixed unknown population parameter)
        based on maximizing the likelihood (p-value, probability to
        reject the bull hypothesis) built on a known population
        distribution.
    -   Bayesian approach is based on the Bayes' theorem: the posterior
        probability (the probability of this hypothesis about a
        population parameter is true after seeing the data) = prior
        probability (a first belief about how likely this hypothesis is
        true) \* the probability of getting the data under the condition
        that the hypothesis is true / probability of getting the data
        regardless of hypothesis is true or false [^6]
-   Accordingly, there are two types of hypothesis testing:
    -   Parametric/rank test assumes sample comes from a certain
        probability distribution and calculates p-value as the
        probability of the occurrence of a given test statistic
    -   Permutation test: randomly samples (without replacement)
        possible permutations and calculates p-value as the proportion
        of samples that have a test statistic more extreme than our
        initial/observed test statistic.
-   Stochastic vs Algorithmic - see the following slides [^7]

[^5]: a kernel is a weighting function used in non-parametric estimation
    techniques.

[^6]: p (hypothesis\|Data)=p(hypothesis)\*p(Data\|hypothesis)/ p(Data)

[^7]: Breiman, L. (2001). Statistical modeling: The two cultures.
    Statistical science, 16(3), 199-231.

### Classic/traditional Regression Model: Stochastic

-   Stochastic (randomized sample with a known x to y function) data
    models
    -   Linear, logistic, and Cox survival analysis [^8]
    -   Can construct simple, understandable x-y relationship, with each
        predictors' importance revealed (by coefficients)
    -   Problem: multiple models could equally well fit the data [^9],
        but they yield different (inaccurate) conclusions.
    -   solution: LASSO (least absolute shrinkage and selection
        operator) regression analysis method to reduce variable
        selection [^10]

[^8]: Poisson regression has count/rate outcome; Cox regression has time
    (between origin and event) outcome based on hazard/fail-risk factors

[^9]: based on goodness-of-fit test and residual plots that give
    arbitrary yes vs no model fit answers. A better way to gauge fit is
    to compare the agreement between predicted with observed y (as long
    as not over-fitting with too many predictors). Cross-validation can
    gauge fit AND avoid the over-fitting problem: 1) Calculate
    validation loss next to training loss. When your validation loss is
    decreasing, the model is still underfit. 2) When your validation
    loss is increasing, the model is overfit.

[^10]: penalize absolute values of weight

### Newer Regression Model: Algorithmic/machine-learning

-   Algorithmic (unknown f(x)) data models (i.e. machine learning)
    -   Decision Tree, Neural Network，Support vector machine [^11]
    -   Application: nonlinear/complex recognition/prediction where
        traditional equation/model can't fit to the data
    -   Can produce more accurate (with more dimensions/multiplicity)
        prediction of y [^12]: by aggregating/en-sembling multiple
        predictors and/or functions/models together. Meanwhile, not
        overfitting (since even though there is no variable deletion, it
        can extract variable importance information from the data) which
        can reduce unstable/different conclusions (i.e. non-accurate
        preduction). [^13]
    -   But usually a black box (i.e. x-y relationship); Although
        Decision Trees have a good interpret-ability based on their
        "nodes" that divide paths to different outcomes, they are not as
        accurate (in term of prediction with a lower low test set error
        in cross-validation) as the less interpret-able Random Forest.

[^11]: support vectors are the data points that have the smallest
    Euclidean metric/distance (in a M-dimension space, the real distance
    of two points or the length of a vector from the original point)
    from the optimal hyperplane (that separating classes in y outcomes).
    "Optimal" here is defined as meaning that the distance of the
    hyperplane to any prediction vector is maximal

[^12]: "Aggregating overa large set of competing models can reduce the
    non-uniqueness while improving accuracy

[^13]: if only measure model fit with test error or
    residual-sum-of-squares, we can easily get different models (and
    after different sets of co-variates get removed, get different
    conclusions)

### Different Ways to Reducing Dimensionality

-   Traditionally way to select/remove variables in a data model: the
    standardized coefficient that a predictor has (i.e. equals to value
    of coefficient/ standard error) decide whether to remove the
    predictor (i.e. importance/ strength of the predictor)
-   Another way to select model: randomly combine different predictors
    to construct model could find multiple subsets that have a lower
    deviance. This can be solved/improved by random forest which
    randomly select variables and calculate the importance of a
    predictor by measuring the noise raise if removing the predictor.

### Big Data (Algorithmic model) Problem

-   Convenient data collection: web survey or extract data from web
    posts

-   Problem: big data representation

    -   Solution: multilevel regression and "borrow predictive strength
        from demographically similar cells that have richer data" [^14]

-   Problem: black box cannot understand the clusters and associations

    -   Solution: cross-validation: build (algorithmic) model with big
        data and verify with a small sample; select a small sample to
        read (human-based) to help understand algorithmic models (and
        maybe also build rules to help iterate algorithmic models)

[^14]: Yu-Sung Su, Reboot the Debate on Social Science Research
    Paradigm, 2022 Peking Education Economics Research Institute \###
    Example \[\^15\] of human-in-the-loop algorithmic models - a group
    of human to rate the data sources (i.e. how to use the source for
    different research/analysis/measurement goals), identify possible
    important predictors, - human suggestions to build model

# Statistical rethinking: a Bayesian course with examples in R and Stan

::: column-margin

------------------------------------------------------------------------

McElreath, R. (2020). Statistical rethinking: A Bayesian course with
examples in R and Stan. Chapman and Hall/CRC.
:::

## Rethinking Statistics as Engineering

-   Engineering [^15]: designing, building, and refining statistical
    procedures
-   along with defining research **objectives** and interpret
    statistical results (which requires understandings the relationship
    between statistical model and **hypothesis**/ assumptions/
    limitations and natural mechanisms of interest)

[^15]: "Statistics is neither mathematics nor a science, but rather a
    branch of engineering" McElreath (2020)

## What is a proper statistical objective?

-   Karl Popper (1959) [^16] argued that certainty can be obtained only
    when theories are falsified (i.e. we are certain the falsified is
    false, while we cannot be certain if a proved-evidence is true).

-   In other words, falsification focuses on deductive reasoning (that
    TEST hypothesis based on observations and make **appropriate**
    interpretation) [^17] that reverts the classic inductive reasoning
    (that try to summarize a general "truth" based on some observations)
    [^18].

-   Falsification formed a "critique" culture of science called
    "critical rationalism". The culture helps us progressively approach
    the truth (but we can never be certain that we have the final
    explanation). Science may progresses, as we falsify an old theory, a
    new theory may come up (to be tested and falsified continuously).

[^16]: Popper, K. R. (1959). The logic of scientific discovery.
    University Press.

[^17]: deductive reasoning: use theory to form hypothesis and then
    confirm with observations

[^18]: inductive reasoning: derive theory from observation, which can be
    problematic as we cannot make general by observing particulars

## Rethinking Falsification

-   Rethinking NHST (Null hypothesis significance test): Usually NHST
    falsifies a null hypothesis (that only indicate one specific way of
    thinking), not the actual research hypothesis (that needs both
    accurate models that implies the answers to the research objective)
    -   Hypothesis does not equals to models/theories [^19]: Hypotheses
        do not imply unique models/theories, and models/theories do not
        imply unique hypotheses [^20]
-   Falsification maybe impossible due to measurement errors in the
    following ways: falsification is consensual/subjective;
    falsification is hard for degree of existence (i.e. 80% of swan are
    white); observations difficulty/uncertainty

[^19]: most-frequently used model are (parametric) distribution theories
    in the exponential family including normal, bi-normal, Poisson
    distribution

[^20]: Examples of "Hypothesis does not equals to models/theories": 1.
    if hypothesis H1 can be proven/falsified by observing O, other
    hypothesis could also lead to observation O; so finding observation
    O tells nothing about the original hypothesis/theory. 2. Also the
    model fitting/relating hypothesis and observation could be multiple
    as well. 3. observation O2 might be the key instead of observation O

## Topics Overview: Baysian

-   Bayesian data analysis
    -   Frequentists focuses on the distribution of a statistics
        calculated from repeated re-samples from the population.
        Probability is identified with **frequency** of a statistics
        appeared in a "random/stochastic" sampling distribution. But
        this won't work if we don't have enough to re-sample (so each
        sample is the same)
    -   Bayesian focuses on the theoretical posterior probability
        distribution/ model parameters, a conditional probability,
        logically inferred (i.e. using the likelihood function [^21] or
        the Bayes's theorem/ inverse probability) based on 1) observed
        data and 2) prior prior probability distribution/ model
        parameters. Probability is degree of belief based on counts of
        different plausible appearance of events (which are standardized
        into probabilities [^22]), or updating model parameters. But
        application of Baysian methods remain computationally expensive
        (i.e. cost of info gathering and processing), so
        alternatives/approximations (i.e. heuristic adaptive shortcuts)
        to Baysian inference are valuable.

[^21]: likelihood function: represents the probability of random
    variable realizations conditional on particular values of the
    statistical parameters.

[^22]: possibility: the plausibility of all events that make all
    plausibility sum to one

## Topics Overview: Multilevel

-   Multilevel models, also called "hierarchical, random effects,
    varying effects, or mixed effects" models
-   Model comparison using information criteria

## Baysian key concepts

-   A conjectured proportion p is a parameter value indexing possible
    explanations of the data.
-   Likelihood: number of ways that a parameter can produce the data.
    The likelihood of a conjecture is calculated by: multiplying 1) the
    number of ways we could get the first marble in the first conjecture
    (i.e. the first-time take out a marble) with 2) the number of ways
    we could get the second marble in the first conjecture with 3)...
    third marble, etc.
-   Prior probability: prior plausibility of any specific p is usually
    called the
-   Posterior probability: plausibility of any specific p updated by new
    observations.

# other notes

## Big Names in the field

-   Fisher regression model/specification
-   Classic (Pearson/Neyman) vs Baysian methods
-   Student's

## Hidden slides {visibility="hidden"}


::: {.cell}

:::

::: {.cell}

:::

::: {.cell}

:::
