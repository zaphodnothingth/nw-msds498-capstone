library(stargazer)
library(dplyr) # install.packages("dplyr")
my.stargazer_path <- './Stargazer/'; 

### Set wd, path and read file
completePath<- rstudioapi::getActiveDocumentContext()$path
nameOfMyFile <- sub(".*/", "", completePath)
workingDirectoryPath <- gsub(pattern = nameOfMyFile, replacement = "", x = completePath)
setwd(workingDirectoryPath)
my.datapath <- './Data/';
my.file <- paste(my.datapath,'credit_card_default_clean.RData',sep='');
credit_card_default_raw <- readRDS(my.file)
ccdc <- credit_card_default_raw

# (1) bin age
ccdc$age_bins <- cut(ccdc$AGE, breaks = seq(0, 80, 10), 
    labels=c("1-10", "11-20", "21-30", "31-40", "41-50", "51-60", "61-70", "71-80"))
file.name <- 'age_bins.html';
age_bins_df = as.data.frame(table(ccdc$age_bins))
stargazer(age_bins_df, type=c('html'),out=paste(my.stargazer_path,file.name,sep=''),
          title=c('Table 1: Resulting distribution of Age Binning'),
          align=TRUE, digits=2, digits.extra=2, initial.zero=TRUE, 
          summary=FALSE, rownames = FALSE)

# (2) Average Bill Amount
bills = subset(credit_card_default_raw, 
               select=BILL_AMT1:BILL_AMT6)
ccdc$bill_avg <- rowMeans(bills)

# (3) Average Payment Amount
payments = subset(credit_card_default_raw, 
               select=PAY_AMT1:PAY_AMT6)
ccdc$payment_avg <- rowMeans(payments)

# (4) Payment Ratio  - need to adjust for when bill is neg? 
###### get working as function?
# calc_ratio <- function(pay, bill) {
#   # neg or 0 bill means fully paid
#   if (bill <= 0) {
#       return(1)
#   }
#   return(pay / bill)
# }
# 
# library(dplyr)
# calc_ratio <- function(df, Col1, Col2, NewCol) {
#   # neg or 0 bill means fully paid - avoid dividing by 0 or neg
#   df %>%
#     mutate(NewCol = if_else(
#       Col2 <= 0, 1, # if
#       Col1 / Col2
#     ))
# }
# calc_ratio(ccdc, 'PAY_AMT1', 'BILL_AMT2', 'pay_ratio1')

library(tibble)
ccdc <- ccdc %>%
  add_column(pay_ratio1 = if_else(.$BILL_AMT2 <= 0, 1, .$PAY_AMT1 / .$BILL_AMT2),
   pay_ratio2 = if_else(.$BILL_AMT3 <= 0, 1, .$PAY_AMT2 / .$BILL_AMT3),
   pay_ratio3 = if_else(.$BILL_AMT4 <= 0, 1, .$PAY_AMT3 / .$BILL_AMT4),
   pay_ratio4 = if_else(.$BILL_AMT5 <= 0, 1, .$PAY_AMT4 / .$BILL_AMT5),
   pay_ratio5 = if_else(.$BILL_AMT6 <= 0, 1, .$PAY_AMT5 / .$BILL_AMT6))


# (5) Avg Payment Ratio 
ratios = subset(ccdc, 
                  select=pay_ratio1:pay_ratio5)
ccdc$ratio_avg <- rowMeans(ratios)

# (6) Utilization  
ccdc$util1 <- ccdc$BILL_AMT1/ccdc$LIMIT_BAL
ccdc$util2 <- ccdc$BILL_AMT2/ccdc$LIMIT_BAL
ccdc$util3 <- ccdc$BILL_AMT3/ccdc$LIMIT_BAL
ccdc$util4 <- ccdc$BILL_AMT4/ccdc$LIMIT_BAL
ccdc$util5 <- ccdc$BILL_AMT5/ccdc$LIMIT_BAL
ccdc$util6 <- ccdc$BILL_AMT5/ccdc$LIMIT_BAL

# (7) Avg Utilization 
utils <- subset(ccdc, 
                select=util1:util6)
ccdc$util_avg <- rowMeans(utils)

# (8) Balance Growth Over 6 Months
ccdc$balance_growth_6mo <- ccdc$BILL_AMT6 - ccdc$BILL_AMT1

# (9) Balance Growth Over 6 Months
ccdc$balance_growth_6mo <- ccdc$util6 - ccdc$util1

library(matrixStats)
# (10) max bill amt
ccdc$bill_max <- rowMaxs(as.matrix(bills))

# (11) max payment amt
ccdc$payment_max <- rowMaxs(as.matrix(payments))

# (12) max Delinquency
pays <- subset(credit_card_default_raw, 
               select=PAY_1:PAY_6)
# replace neg vals
pays <- sapply(pays, function(x) replace(x, x %in% c(-2,-1), 0)) 

ccdc$pay_max <- rowMaxs(as.matrix(pays))


####### Consider normalization and discretization with each model


# remove raw variables
ccdc_out <- select(ccdc, -c('ID':'AGE','PAY_1':'data.group'))
# replace nan with 0
ccdc_out <- sapply(ccdc_out, function(x) replace(x, is.nan(x), 0))


out.file <- paste(my.datapath,'credit_card_default_eng_features.RData',sep='');
saveRDS(ccdc_out, out.file)

# output features with target to csv
ccdc_out_wDefault <- select(ccdc, -c('ID':'AGE','PAY_1':'PAY_AMT6','u':'data.group'))
write.csv(ccdc_out_wDefault, "./Data/credit_card_default_eng.csv", row.names=TRUE)
saveRDS(ccdc_out_wDefault, "./Data/credit_card_default_eng.RData")

