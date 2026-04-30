# Modeling Decision Behavior Using Causal Inference

## Overview

High-performing individuals often experience decision paralysis when expectations are high. This project investigates whether **maladaptive perfectionism** is associated with increased **decision avoidance** using behavioral survey data.

This work builds on research in engineering education and psychology, applying **causal reasoning and statistical modeling** to better understand how perfectionism influences decision-making behavior.

---

## Causal Question

**What is the estimated effect of maladaptive perfectionism on decision avoidance, after accounting for relevant covariates?**

---

## Why This Matters

Decision avoidance impacts:

- academic performance  
- career progression  
- product engagement  
- user decision-making in high-stakes environments  

Understanding this relationship can inform:

- behavioral interventions  
- student support systems  
- UX and product design  
- decision-support tools  

## 📊 Results

### Overview

A series of regression models were estimated to examine the relationship between maladaptive perfectionism and decision avoidance, progressively adjusting for related perfectionism constructs.

---

### Model 1 — Baseline Association

**Model specification:**

\[
DecisionAvoidance = \beta_0 + \beta_1(Maladaptive) + \epsilon
\]

**Results:**

- Estimate: β = 0.29  
- p < 0.01  

This suggests that higher levels of maladaptive perfectionism are associated with greater decision avoidance.

---

### Model 2 — Adjusting for Adaptive Perfectionism

**Model specification:**

\[
DecisionAvoidance = \beta_0 + \beta_1(Maladaptive) + \beta_2(Adaptive) + \epsilon
\]

**Results:**

- Maladaptive perfectionism: β = 0.29, p < 0.01  
- Adaptive perfectionism: β = -0.13, p = 0.36 (not significant)

Maladaptive perfectionism remained a significant predictor, while adaptive perfectionism was not associated with decision avoidance.

---

### Model 3 — Causal-Informed Adjustment

**Model specification:**

\[
DecisionAvoidance = \beta_0 + \beta_1(Maladaptive) + \beta_2(Adaptive) + \beta_3(APSR\_Discrepancy) + \beta_4(MPS\_SPP) + \epsilon
\]

**Results:**

- Maladaptive perfectionism: β = 0.10, p = 0.56 (not significant)  
- Adaptive perfectionism: β = -0.15, p = 0.31 (not significant)  
- APS-R Discrepancy: β = 0.02, p = 0.81 (not significant)  
- MPS Socially Prescribed Perfectionism: β = 0.28, p = 0.012 (significant)  

Model fit improved (R² increased from ~0.07 to ~0.12).

---

###  Interpretation

Initial models suggested that maladaptive perfectionism is associated with increased decision avoidance. However, after adjusting for broader perfectionism constructs, this relationship was no longer significant.

Instead, socially prescribed perfectionism emerged as the only significant predictor, suggesting that **external evaluative pressure** may play a more central role in decision avoidance than internal maladaptive tendencies alone.

---

### Causal Interpretation

This analysis is based on observational data and should be interpreted using causal reasoning rather than definitive causal claims.

The inclusion of theoretically relevant covariates helps reduce potential confounding, but unobserved factors may still influence the results.

---

###  Key Takeaway

> Decision avoidance appears to be more strongly associated with externally driven perfectionism (social pressure) than with internal maladaptive perfectionism alone. 

## Dataset

This project uses behavioral survey data derived from the development of the **AMPERE (Adaptive and Maladaptive Perfectionism in Engineering) scale**.

**Variables include:**

- maladaptive perfectionism scores  
- adaptive perfectionism scores  
- decision avoidance measures  
- demographic and academic variables  

> ⚠️ The public version of this repository uses a de-identified or synthetic dataset to protect participant privacy.

---

## Analytical Approach

### 1. Data Cleaning & Preparation
- handling missing values  
- recoding variables  
- preparing analysis-ready dataset  

### 2. Descriptive Analysis
- distribution of perfectionism scores  
- summary statistics  
- correlation patterns  

### 3. Causal Reasoning (DAG-Based)
- defining assumed relationships between variables  
- identifying confounders  
- guiding model specification  

### 4. Regression Modeling
- estimating association between maladaptive perfectionism and decision avoidance  
- adjusting for relevant covariates  
- interpreting effect sizes  

### 5. Behavioral Segmentation

Participants are grouped into:

- Low Adaptive / Low Maladaptive  
- High Adaptive / Low Maladaptive  
- Low Adaptive / High Maladaptive  
- High Adaptive / High Maladaptive  

These groups are compared on decision avoidance outcomes.

---

## Key Findings

- Higher maladaptive perfectionism is associated with increased decision avoidance  
- The relationship remains meaningful after adjusting for selected covariates  
- Behavioral profiles show different decision patterns  

> Interpretation is based on a causal framework under stated assumptions, not definitive causal claims.

---

## DAG-Based Thinking

A Directed Acyclic Graph (DAG) is used to:

- clarify assumptions about relationships between variables  
- identify appropriate adjustment variables  
- avoid controlling for colliders or mediators  

---

## Tools & Methods

- R  
- tidyverse  
- ggplot2  
- regression modeling  
- causal inference concepts  
- behavioral segmentation  

---

## Repository Structure
scripts/ → data cleaning, modeling, analysis
data/ → raw and processed datasets
outputs/ → figures and tables
docs/ → methodological notes


---

## Portfolio Relevance

This project demonstrates:

- causal reasoning with observational data  
- behavioral data analysis  
- statistical modeling and interpretation  
- ability to connect research with real-world applications  
- clear communication of analytical insights  

---

## About Me

I am a Ph.D. candidate in Engineering and Science Education at Clemson University. My research focuses on **perfectionism, decision-making, and behavioral outcomes**, combining psychometrics, statistical modeling, and human-centered analysis.
