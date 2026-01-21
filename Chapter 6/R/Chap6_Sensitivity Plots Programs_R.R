### Programs to make the sensitivity plots (Figures 6.2 and 6.3) in Chapter 6 

# Load data set (memory-08.txt)
data = read.table("Chap6_Memory.txt", na.strings=".")
colnames(data) = c("X", "R", "Y", "M", "XM")

# Specify the mediation model
install.packages("lavaan")
install.packages("boot")
library(lavaan)
library(boot)
model = ' # direct effect
             Y ~ c*X
          # mediator equation
             M ~ a*X
          # oucome equation
             Y ~ b*M
          # indirect effect (a*b)
             ab := a*b
          # total effect
             total := c + (a*b)
         '
fit = sem(model, data = data, 
          se = "bootstrap",
          bootstrap = 1000)

summary(fit)

### Figure 6.2 
# Sensitivity plot for confounding of the mediated effect in the memory study 
# as a function of the correlation between the confounder and M and the 
# confounder and Y. 

# Left out variables error (L.O.V.E) method applied to the memory study

# X = Independent variable
# M = Mediator
# Y = Outcome variable
# U = Potential confounder

# Input observed correlations:
# RYX is the observed correlation between Y and X
RYX = 0.33718
# RMX is the observed correlation between M and X
RMX = 0.62300
# RYM is the observed correlation between Y and M
RYM = 0.49759

# Define sequences for the unobserved correlations RUM, RUY, and RUX
# RUM is the unobserved correlation between U and M; 
RUM = seq(0,1,.001)
# RUY is the unobserved correlation between U and Y; 
RUY = seq(0,1,.001)
# RUX is the unobserved correlation between U and X; 
RUX = 0

# Create a data frame with all combinations of RUM and RUY
results = expand.grid(RUM = RUM, RUY = RUY)

# Add the RUX column with the same value repeated in all rows
results$RUX = RUX 
results$RYX = RYX
results$RMX = RMX 
results$RYM = RYM

# Calculate true values of a, b, cpr that account for the influence of a 
# potential confounder U
results$CPR = (results$RYX * (1 - results$RUM^2) + 
                 results$RYM * (results$RUX * results$RUM - results$RMX) + 
                 results$RUY * (results$RUX * results$RUM - results$RUX)) / 
  (1 + 2 * (results$RMX * results$RUM * results$RUX) - 
     results$RUX^2 - results$RUM^2 - results$RMX^2)
results$B = (results$RYM * (1 - results$RUX^2) + 
               results$RYX * (results$RUM * results$RUX - results$RMX) + 
               results$RUY * (results$RMX * results$RUX - results$RUM)) / 
  (1 + 2 * (results$RMX * results$RUX * results$RUM) - 
     results$RUM^2 - results$RUX^2 - results$RMX^2)
results$A = (results$RMX - results$RUM * results$RUX) / (1 - results$RUX^2)

# Calculate observed values of a, b, cpr that omits the influence of a 
# potential confounder U
results$CPRBIASED = (results$RYX - results$RYM * results$RMX) / 
  (1 - results$RMX^2)
results$BBIASED = (results$RYM - results$RYX * results$RMX) / 
  (1 - results$RMX^2)
results$ABIASED = results$RMX

# Calculate bias of each coefficient, a is unbiased because RUX=0
results$BIASCPR = results$CPRBIASED - results$CPR
results$BIASB  = results$BBIASED - results$B
results$BIASA  = results$ABIASED - results$A

# Calculate standardized true mediated effect (TRUEAB), standardized biased 
# mediated effect (BIASEDAB), and the bias of the mediated effect (BIASAB)
results$TRUEAB = results$A * results$B 
results$BIASEDAB  = results$ABIASED  * results$BBIASED 
results$BIASAB  = results$BIASEDAB  - results$TRUEAB 
results$RTRUEAB  = round(results$TRUEAB, 2)

# Filter the data where RTRUEAB equals zero
forzero = subset(results, RTRUEAB == 0)

# L.O.V.E. plot, X-axis = RUY, Y-axis = RUM, for the subset where RTRUEAB 
# equals zero using ggplot2
install.packages("ggplot2")
library(ggplot2)

## Registering fonts with R
ggplot(forzero, aes(x = RUY, y = RUM)) +
  geom_point(size = 2) +
  scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  labs(x = "RUY", y = "RUM")+
  theme_classic()

### Figure 6.3 
# Sensitivity plot in terms of rho (p), the correlation between the residuals 
# in M and the residuals and Y from Imai, Keele, & Tingley (2010).

# Specify the mediator (med.m) and outcome models (med.y)
med.m = lm(M ~ X, data = data)
med.y = lm(Y ~ X + M, data = data)

# Specify X as a categorical variable
attach(data)
X=as.character(X)

# Load mediation R package
install.packages("mediation")
library(mediation)

# Set a seed that will allow to replicate the results.
set.seed(02052024)

# Conduct mediation analysis, specifying the mediator and the outcome models
med.out = mediate(med.m, med.y, 
                  sims = 2000, 
                  treat = "X", 
                  mediator = "M", 
                  boot = TRUE,
                  boot.ci.type="perc", 
                  conf.level=.95)
## Running nonparametric bootstrap
# Estimates mediation model (ACME, ADE, Total Effect, and Proportion Mediated), 
# and 95% percentile bootstrap CI
summary(med.out)

# Conduct correlated residuals method
sens.out = medsens(med.out, rho.by = 0.01, effect.type = "indirect")

# Results correlated residuals method
summary(sens.out)

# Find rho values that change the significance of the ACME (d0) based on when 
# the confidence band starts to contain 0 (ind.d0).
output2 = data.frame(
  d0 = sens.out[["d0"]],
  rho = sens.out[["rho"]],
  ind.d0 = sens.out[["ind.d0"]])

# Ask for the correlated residuals plot
plot(sens.out, sens.par = "rho")
abline(v = 0.39, col = "black", lty = 2, lwd = 1)
abline(h = 0, col = "red", lty = 1, lwd = 1)

# Modify plot
text(x = 1, y = 2.19, labels = "ACME = 2.19", col = "black", cex = 0.7, adj = c(1, -0.3))
text(x = .39, y = -33, labels = expression(rho == .39), col = "black", cex = 0.7 , pos=2)

# Allow drawing outside plot region
par(xpd = TRUE)

# Add text just outside the left margin of the plot
text(x = par("usr")[1] - 0.12, y = 0, labels = "0", srt = 90, col = "red")