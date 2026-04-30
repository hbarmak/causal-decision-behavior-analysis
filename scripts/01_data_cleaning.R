# ============================================
# AMPERE GitHub Portfolio Pipeline
# Screen → Recode → Score → Analyze
# ============================================

library(tidyverse)
library(readxl)
library(broom)

set.seed(123)

# --------------------------------------------
# 1. Load Raw Data
# --------------------------------------------

dat0 <- read_excel("Clean_AMPERE.xlsx", sheet = 1)

dat <- if (mean(sapply(dat0[1, ], is.character)) > 0.6) {
  dat0[-1, ]
} else {
  dat0
}

cat("Starting N =", nrow(dat), "\n")

# --------------------------------------------
# 2. Screen Participants
# --------------------------------------------

dat <- dat %>%
  filter(
    SQ1 == "Yes",
    SQ2 == "Yes",
    SQ3 == "Yes",
    SQ4 == "Yes"
  ) %>%
  mutate(
    Progress = suppressWarnings(as.numeric(Progress))
  ) %>%
  filter(Progress >= 65)

if ("AttentionCheckPassed" %in% names(dat)) {
  dat <- dat %>%
    mutate(.att = tolower(trimws(as.character(AttentionCheckPassed)))) %>%
    filter(is.na(.att) | .att %in% c("true", "t", "1", "yes", "y", "pass", "passed")) %>%
    select(-.att)
}

names(dat) <- make.unique(names(dat), sep = "_dup")

cat("Final screened N =", nrow(dat), "\n")

# --------------------------------------------
# 3. Helper: Recode Likert Responses
# --------------------------------------------

recode_likert <- function(x) {
  s <- trimws(as.character(x))
  n <- suppressWarnings(as.integer(sub("^([0-9]+).*$", "\\1", s)))
  n[!(n %in% 1:7)] <- NA_integer_
  n
}

# --------------------------------------------
# 4. Define Item Sets
# --------------------------------------------

# AMPERE final CB model items
adaptive_items <- c(
  "AMPERE_2", "AMPERE_9", "AMPERE_10",
  "AMPERE_13", "AMPERE_14", "AMPERE_17"
)

maladaptive_items <- c(
  "AMPERE_4", "AMPERE_6", "AMPERE_7", "AMPERE_8",
  "AMPERE_15", "AMPERE_16", "AMPERE_18", "AMPERE_20"
)

# Decision avoidance outcome
midc_items <- paste0("MIDC_", 1:5)

# APS-R Discrepancy
apsr_discrepancy_items <- c(
  "APSR_1", "APSR_2", "APSR_3", "APSR_4",
  "APSR_5", "APSR_6", "APSR_7", "APSR_8",
  "APSR_9", "APSR_10", "APSR_11", "APSR_12"
)

# MPS Socially Prescribed Perfectionism
spp_items <- c(
  "MPS_5", "MPS_9", "MPS_11", "MPS_13", "MPS_18",
  "MPS_21", "MPS_25", "MPS_30", "MPS_31", "MPS_33",
  "MPS_35", "MPS_37", "MPS_39", "MPS_41", "MPS_44"
)

# MPS reversed items
mps_rev <- c(
  "MPS_2", "MPS_3", "MPS_4", "MPS_8", "MPS_9", "MPS_10",
  "MPS_12", "MPS_19", "MPS_21", "MPS_24", "MPS_30",
  "MPS_34", "MPS_36", "MPS_37", "MPS_38", "MPS_43",
  "MPS_44", "MPS_45"
)

all_items <- c(
  adaptive_items,
  maladaptive_items,
  midc_items,
  apsr_discrepancy_items,
  spp_items
)

# --------------------------------------------
# 5. Recode Items
# --------------------------------------------

dat <- dat %>%
  mutate(
    across(
      any_of(all_items),
      recode_likert
    )
  )

# --------------------------------------------
# Ensure MPS items are numeric BEFORE reversing
# --------------------------------------------

dat <- dat %>%
  mutate(
    across(
      any_of(mps_rev),
      ~ suppressWarnings(as.numeric(.))
    )
  )

# --------------------------------------------
# Reverse-code MPS items
# --------------------------------------------

for (nm in intersect(mps_rev, names(dat))) {
  dat[[nm]] <- ifelse(
    is.na(dat[[nm]]),
    NA_real_,
    8 - dat[[nm]]
  )
}

# --------------------------------------------
# 6. Create Scale Scores
# --------------------------------------------

dat <- dat %>%
  mutate(
    adaptive_perfectionism = rowMeans(select(., any_of(adaptive_items)), na.rm = TRUE),
    maladaptive_perfectionism = rowMeans(select(., any_of(maladaptive_items)), na.rm = TRUE),
    decision_avoidance = rowMeans(select(., any_of(midc_items)), na.rm = TRUE),
    APSR_Discrepancy = rowMeans(select(., any_of(apsr_discrepancy_items)), na.rm = TRUE),
    MPS_SPP = rowMeans(select(., any_of(spp_items)), na.rm = TRUE)
  )

# --------------------------------------------
# 7. Create GitHub-Safe Sample
# --------------------------------------------

gh_data <- dat %>%
  select(
    adaptive_perfectionism,
    maladaptive_perfectionism,
    decision_avoidance,
    APSR_Discrepancy,
    MPS_SPP
  ) %>%
  drop_na() %>%
  sample_n(min(150, n()))

write_csv(gh_data, "data/processed/ampere_gh_sample.csv")

# --------------------------------------------
# 8. Descriptive Statistics
# --------------------------------------------

descriptives <- gh_data %>%
  summarise(
    n = n(),
    adaptive_mean = mean(adaptive_perfectionism),
    adaptive_sd = sd(adaptive_perfectionism),
    maladaptive_mean = mean(maladaptive_perfectionism),
    maladaptive_sd = sd(maladaptive_perfectionism),
    decision_avoidance_mean = mean(decision_avoidance),
    decision_avoidance_sd = sd(decision_avoidance),
    APSR_Discrepancy_mean = mean(APSR_Discrepancy),
    APSR_Discrepancy_sd = sd(APSR_Discrepancy),
    MPS_SPP_mean = mean(MPS_SPP),
    MPS_SPP_sd = sd(MPS_SPP)
  )

write_csv(descriptives, "outputs/descriptive_statistics.csv")

# --------------------------------------------
# 9. Regression Models
# --------------------------------------------

# Model 1: Simple association
model1 <- lm(
  decision_avoidance ~ maladaptive_perfectionism,
  data = gh_data
)

# Model 2: Adjusted for adaptive perfectionism
model2 <- lm(
  decision_avoidance ~ maladaptive_perfectionism + adaptive_perfectionism,
  data = gh_data
)

# Model 3: Causal-informed adjustment model
model3 <- lm(
  decision_avoidance ~ maladaptive_perfectionism +
    adaptive_perfectionism +
    APSR_Discrepancy +
    MPS_SPP,
  data = gh_data
)

write_csv(tidy(model1), "outputs/model1_basic_regression.csv")
write_csv(tidy(model2), "outputs/model2_ampere_adjusted_regression.csv")
write_csv(tidy(model3), "outputs/model3_causal_informed_regression.csv")

capture.output(summary(model3), file = "outputs/regression_summary.txt")

# --------------------------------------------
# 10. Visualizations for Model 1, Model 2, Model 3
# --------------------------------------------

# Model 1 predicted values
gh_data <- gh_data %>%
  mutate(
    predicted_m1 = predict(model1),
    predicted_m2 = predict(model2),
    predicted_m3 = predict(model3)
  )

# Model 1: Unadjusted association
p1 <- ggplot(gh_data, aes(x = maladaptive_perfectionism, y = decision_avoidance)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Model 1: Unadjusted Association",
    subtitle = "Decision avoidance predicted by maladaptive perfectionism only",
    x = "Maladaptive Perfectionism",
    y = "Decision Avoidance"
  ) +
  theme_minimal()

ggsave(
  filename = "outputs/model1_unadjusted_plot.png",
  plot = p1,
  width = 7,
  height = 5
)

p1

# Model 2: Predicted decision avoidance after adjusting for adaptive perfectionism
p2 <- ggplot(gh_data, aes(x = maladaptive_perfectionism, y = predicted_m2)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Model 2: AMPERE-Adjusted Relationship",
    subtitle = "Predicted decision avoidance adjusted for adaptive perfectionism",
    x = "Maladaptive Perfectionism",
    y = "Predicted Decision Avoidance"
  ) +
  theme_minimal()

ggsave(
  filename = "outputs/model2_ampere_adjusted_plot.png",
  plot = p2,
  width = 7,
  height = 5
)

p2

# Model 3: Predicted decision avoidance after causal-informed adjustment
p3 <- ggplot(gh_data, aes(x = maladaptive_perfectionism, y = predicted_m3)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Model 3: Causal-Informed Adjustment",
    subtitle = "Predicted decision avoidance adjusted for adaptive perfectionism, APS-R discrepancy, and MPS-SPP",
    x = "Maladaptive Perfectionism",
    y = "Predicted Decision Avoidance"
  ) +
  theme_minimal()

ggsave(
  filename = "outputs/model3_causal_informed_plot.png",
  plot = p3,
  width = 7,
  height = 5
)

p3
# --------------------------------------------
# 11. DAG-Informed Assumption Diagram
# --------------------------------------------

dag_data <- tibble(
  x = c(1.6, 2, 3, 2, 2),
  y = c(3, 3, 3, 2, 1),
  label = c(
    "Related\nPerfectionism\nConstructs",
    "Maladaptive\nPerfectionism",
    "Decision\nAvoidance",
    "Adaptive\nPerfectionism",
    "Observed\nCovariates"
  )
)

dag_plot <- ggplot(dag_data, aes(x, y, label = label)) +
  geom_text(size = 4.5) +
  annotate("segment", x = 1.9, y = 3, xend = 1.75, yend = 3, arrow = arrow()) +
  annotate("segment", x = 2.25, y = 3, xend = 2.75, yend = 3, arrow = arrow()) +
  annotate("segment", x = 2, y = 2.25, xend = 2, yend = 2.75, arrow = arrow()) +
  annotate("segment", x = 2, y = 1.25, xend = 2, yend = 1.75, arrow = arrow()) +
  labs(
    title = "DAG-Informed Causal Reasoning Framework",
    subtitle = "Regression models adjust for theoretically relevant perfectionism constructs"
  ) +
  theme_void()

ggsave(
  filename = "outputs/dag_causal_reasoning_framework.png",
  plot = dag_plot,
  width = 7,
  height = 7
)
dag_plot
# --------------------------------------------
# 12. Print Main Model Summary
# --------------------------------------------

summary(model1)
summary(model2)
summary(model3)
