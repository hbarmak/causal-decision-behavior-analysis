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

---

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
