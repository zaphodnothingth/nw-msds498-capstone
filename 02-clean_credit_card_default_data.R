###########################################
# notes
# need to check where values should not be negative?
###########################################

### Set wd, path and read file
completePath<- rstudioapi::getActiveDocumentContext()$path
nameOfMyFile <- sub(".*/", "", completePath)
workingDirectoryPath <- gsub(pattern = nameOfMyFile, replacement = "", x = completePath)
setwd(workingDirectoryPath)
my.datapath <- './Data/';
my.file <- paste(my.datapath,'credit_card_default.RData',sep='');
credit_card_default_raw <- readRDS(my.file)

###### data cleaning based on provided field rules + logical assumptions

###############################################
### LIMIT_BAL - positive numeric
summary(credit_card_default_raw$LIMIT_BAL)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 10000   50000  140000  167484  240000 1000000 

###############################################
### SEX - (1,2)
summary(credit_card_default_raw$SEX)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   1.000   2.000   1.604   2.000   2.000 
table(credit_card_default_raw$SEX)
# 1     2 
# 11888 18112 
##### no action necessary, appears clean

###############################################
### EDUCATION - (1:4)
summary(credit_card_default_raw$EDUCATION)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.000   1.000   2.000   1.853   2.000   6.000 
table(credit_card_default_raw$EDUCATION)
# 0     1     2     3     4     5     6 
# 14 10585 14030  4917   123   280    51 
##### action necessary: invalid values - (0,5,6) 


###############################################
### MARRIAGE (1:3)
summary(credit_card_default_raw$MARRIAGE)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.000   1.000   2.000   1.552   2.000   3.000 
table(credit_card_default_raw$MARRIAGE)
# 0     1     2     3 
# 54 13659 15964   323 
##### action necessary: invalid values - (0) 


###############################################
### AGE positive numeric, assume (18:120)
summary(credit_card_default_raw$AGE)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 21.00   28.00   34.00   35.49   41.00   79.00 
table(credit_card_default_raw$AGE)
# 21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39 
# 67  560  931 1127 1186 1256 1477 1409 1605 1395 1217 1158 1146 1162 1113 1108 1041  944  954 
# 40   41   42   43   44   45   46   47   48   49   50   51   52   53   54   55   56   57   58 
# 870  824  794  670  700  617  570  501  466  452  411  340  304  325  247  209  178  122  122 
# 59   60   61   62   63   64   65   66   67   68   69   70   71   72   73   74   75   79 
# 83   67   56   44   31   31   24   25   16    5   15   10    3    3    4    1    3    1 
credit_card_default_raw %>%  # ref: https://www.marsja.se/r-count-the-number-of-occurrences-in-a-column-using-dplyr/
  group_by(group = cut(AGE, breaks = seq(0, 80, 10))) %>%
  summarise(n = n())
# group       n
# <fct>   <int>
#   1 (20,30] 11013
# 2 (30,40] 10713
# 3 (40,50]  6005
# 4 (50,60]  1997
# 5 (60,70]   257
# 6 (70,80]    15
##### no action necessary, appears clean


###############################################
### past payment (-1,1:9)
# PAY_0->PAY_1 
names(credit_card_default_raw)[names(credit_card_default_raw) == "PAY_0"] <- "PAY_1"
summarise_all(subset(credit_card_default_raw, 
                 select=PAY_1:PAY_6),min)
# combine & summarise all 6 columns
table(c(credit_card_default_raw$PAY_1,credit_card_default_raw$PAY_2,
       credit_card_default_raw$PAY_3,credit_card_default_raw$PAY_4,
       credit_card_default_raw$PAY_5,credit_card_default_raw$PAY_6))
# -2    -1     0     1     2     3     4     5     6     7     8 
# 24415 34640 95919  3722 18964  1430   453   137    74   218    28 
##### action necessary: invalid values - (-2,0) 


###############################################
### bill amount - numeric, negative seems plausible in case of credit
bill_amts <- c(credit_card_default_raw$BILL_AMT1,credit_card_default_raw$BILL_AMT2,
        credit_card_default_raw$BILL_AMT3,credit_card_default_raw$BILL_AMT4,
        credit_card_default_raw$BILL_AMT5,credit_card_default_raw$BILL_AMT6)

# check for non numerics
any(is.na(as.numeric(bill_amts)))
# [1] FALSE

# bin & tally
table(cut(as.numeric(bill_amts), c(-Inf,0, 10, 100,1000,10000,100000,Inf)))
# (-Inf,0]    (0,10]   (10,100]  (100,1e+03] (1e+03,1e+04] (1e+04,1e+05] (1e+05, Inf] 
# 22037        35        396       13267         33818         85325        25122
##### no action necessary, appears clean


###############################################
### previous payment - Positive numeric
pay_amts <- c(credit_card_default_raw$PAY_AMT1,credit_card_default_raw$PAY_AMT2,
               credit_card_default_raw$PAY_AMT3,credit_card_default_raw$PAY_AMT4,
               credit_card_default_raw$PAY_AMT5,credit_card_default_raw$PAY_AMT6)

# check for non numerics
any(is.na(as.numeric(pay_amts)))
# [1] FALSE

# bin & tally
table(cut(as.numeric(pay_amts), c(-Inf,0, 10, 100,1000,10000,100000,Inf)))
# (-Inf,0]  (0,10]  (10,100] (100,1e+03] (1e+03,1e+04] (1e+04,1e+05]  (1e+05, Inf] 
# 36897       726      1253     26591         97455         16030         1048 
##### no action necessary, appears clean


out.file <- paste(my.datapath,'credit_card_default_clean.RData',sep='');
saveRDS(credit_card_default_raw, out.file)
