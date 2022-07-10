### Set wd, path and read file
completePath<- rstudioapi::getActiveDocumentContext()$path
nameOfMyFile <- sub(".*/", "", completePath)
workingDirectoryPath <- gsub(pattern = nameOfMyFile, replacement = "", x = completePath)
setwd(workingDirectoryPath)
my.datapath <- './Data/';
my.file <- paste(my.datapath,'credit_card_default_clean.RData',sep='');
ccdc <- readRDS(my.file)

# (1) bin age
ccdc$age_bins <- cut(ccdc$AGE, breaks = seq(0, 80, 10), 
    labels=c("1-10", "11-20", "21-30", "31-40", "41-50", "51-60", "61-70", "71-80"))

# (2) Average Bill Amount
bills = subset(credit_card_default_raw, 
               select=BILL_AMT1:BILL_AMT6)
ccdc$bill_avg <- rowMeans(bills)

# (3) Average Payment Amount
payments = subset(credit_card_default_raw, 
               select=PAY_1:PAY_6)
ccdc$pay_avg <- rowMeans(payments)

# (4) Payment Ratio  - need to adjust for when bill is neg? 
ccdc$pay_ratio1 <- ccdc$PAY_AMT1/ccdc$BILL_AMT2
ccdc$pay_ratio2 <- ccdc$PAY_AMT2/ccdc$BILL_AMT3
ccdc$pay_ratio3 <- ccdc$PAY_AMT3/ccdc$BILL_AMT4
ccdc$pay_ratio4 <- ccdc$PAY_AMT4/ccdc$BILL_AMT5
ccdc$pay_ratio5 <- ccdc$PAY_AMT5/ccdc$BILL_AMT6

# (5) Avg Payment Ratio 
ratios = subset(credit_card_default_raw, 
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
utils = subset(credit_card_default_raw, 
                select=util1:util6)
ccdc$util_avg <- rowMeans(utils)

# (8) Balance Growth Over 6 Months



