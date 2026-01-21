#############################
### Latent Variable Model ###
#############################
# Read data
chap13Data <- read.table("Chap13_Exp1.txt", quote = "\"", comment.char = "")
sd <- as.matrix(chap13Data[1,])
cor <- as.matrix(chap13Data[-1,])
cov <- cor * matrix(outer(sd, sd), nrow = 9, byrow = TRUE)   
colnames(cov) <- rownames(cov) <- c("coach1", "coach2", "coach3", 
                                    "severe1", "severe2", "severe3", 
                                    "intent1", "intent2", "intent3")

# Load package
install.packages("lavaan")
library(lavaan)

# Model syntax
chap13Model <- '
coach =~ coach1 + coach2 + coach3
severe =~ severe1 + severe2 + severe3
intent =~ intent1 + intent2 + intent3
intent ~ severe + coach
severe ~ coach
'

chap13Fit <- sem(model = chap13Model, 
                 sample.cov = cov, 
                 sample.nobs = 547, 
                 estimator = "ML")
summary(chap13Fit, 
        ci = TRUE,
        standardized = TRUE)
fitted(chap13Fit)
lavInspect(chap13Fit, 
           what = "est")