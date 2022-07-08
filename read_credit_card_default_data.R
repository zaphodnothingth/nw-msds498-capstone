# Chad R Bhatti
# 03.19.2017
# read_credit_card_default_data.R

##################################################################################
# This example code will show you how to load and check the data set;
##################################################################################


# Define path and file; set cur to working
### windows only?
### this.dir <- dirname(parent.frame(2)$ofile)
### setwd(this.dir)
# macos - install.packages("rstudioapi")
completePath<- rstudioapi::getActiveDocumentContext()$path
nameOfMyFile <- sub(".*/", "", completePath)
workingDirectoryPath <- gsub(pattern = nameOfMyFile, replacement = "", x = completePath)
setwd(workingDirectoryPath)

my.datapath <- './Data/';
my.file <- paste(my.datapath,'credit_card_default.RData',sep='');

# Read the RData object using readRDS();
credit_card_default <- readRDS(my.file)

# Show dataframe structure;
str(credit_card_default)

##################################################################################
# 'data.frame':   30000 obs. of  30 variables:
#  $ ID        : int  1 2 3 4 5 6 7 8 9 10 ...
#  $ LIMIT_BAL : int  20000 120000 90000 50000 50000 50000 500000 100000 140000 20000 ...
#  $ SEX       : int  2 2 2 2 1 1 1 2 2 1 ...
#  $ EDUCATION : int  2 2 2 2 2 1 1 2 3 3 ...
#  $ MARRIAGE  : int  1 2 2 1 1 2 2 2 1 2 ...
#  $ AGE       : int  24 26 34 37 57 37 29 23 28 35 ...
#  $ PAY_0     : int  2 -1 0 0 -1 0 0 0 0 -2 ...
#  $ PAY_2     : int  2 2 0 0 0 0 0 -1 0 -2 ...
#  $ PAY_3     : int  -1 0 0 0 -1 0 0 -1 2 -2 ...
#  $ PAY_4     : int  -1 0 0 0 0 0 0 0 0 -2 ...
#  $ PAY_5     : int  -2 0 0 0 0 0 0 0 0 -1 ...
#  $ PAY_6     : int  -2 2 0 0 0 0 0 -1 0 -1 ...
#  $ BILL_AMT1 : int  3913 2682 29239 46990 8617 64400 367965 11876 11285 0 ...
#  $ BILL_AMT2 : int  3102 1725 14027 48233 5670 57069 412023 380 14096 0 ...
#  $ BILL_AMT3 : int  689 2682 13559 49291 35835 57608 445007 601 12108 0 ...
#  $ BILL_AMT4 : int  0 3272 14331 28314 20940 19394 542653 221 12211 0 ...
#  $ BILL_AMT5 : int  0 3455 14948 28959 19146 19619 483003 -159 11793 13007 ...
#  $ BILL_AMT6 : int  0 3261 15549 29547 19131 20024 473944 567 3719 13912 ...
#  $ PAY_AMT1  : int  0 0 1518 2000 2000 2500 55000 380 3329 0 ...
#  $ PAY_AMT2  : int  689 1000 1500 2019 36681 1815 40000 601 0 0 ...
#  $ PAY_AMT3  : int  0 1000 1000 1200 10000 657 38000 0 432 0 ...
#  $ PAY_AMT4  : int  0 1000 1000 1100 9000 1000 20239 581 1000 13007 ...
#  $ PAY_AMT5  : int  0 0 1000 1069 689 1000 13750 1687 1000 1122 ...
#  $ PAY_AMT6  : int  0 2000 5000 1000 679 800 13770 1542 1000 0 ...
#  $ DEFAULT   : int  1 1 0 0 0 0 0 0 0 0 ...
#  $ u         : num  0.288 0.788 0.409 0.883 0.94 ...
#  $ train     : num  1 0 1 0 0 1 0 0 0 1 ...
#  $ test      : num  0 0 0 0 0 0 1 0 1 0 ...
#  $ validate  : num  0 1 0 1 1 0 0 1 0 0 ...
#  $ data.group: num  1 3 1 3 3 1 2 3 2 1 ...
##################################################################################
# Note: data.group values are constructed to partition the data set in a single dimension;
# data.group <- 1*my.data$train + 2*my.data$test + 3*my.data$validate;
# Use the train, test, and validate flags to define the train, test, and validate data sets;
##################################################################################


# Here is the observation count in each data set;
table(credit_card_default$data.group)

#     1     2     3 
# 15180  7323  7497 

# Show top of data frame with some values;
head(credit_card_default)

# desc stats
library(dlookr) # install.packages("dlookr"), ref: https://cran.r-project.org/web/packages/dlookr/vignettes/EDA.html
desc <- describe(credit_card_default)
desc
# described_varia…     n    na     mean      sd se_mean    IQR  skewness kurtosis   p00    p01    p05    p10    p20
# <chr>            <int> <int>    <dbl>   <dbl>   <dbl>  <dbl>     <dbl>    <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
#   1 ID               30000     0  1.50e+4 8.66e+3 5.00e+1 1.50e4 -2.57e-17  -1.20       1   301.  1501.  3001.  6001.
# 2 LIMIT_BAL        30000     0  1.67e+5 1.30e+5 7.49e+2 1.9 e5  9.93e- 1   0.536  10000 10000  20000  30000  50000 
# 3 SEX              30000     0  1.60e+0 4.89e-1 2.82e-3 1   e0 -4.24e- 1  -1.82       1     1      1      1      1 
# 4 EDUCATION        30000     0  1.85e+0 7.90e-1 4.56e-3 1   e0  9.71e- 1   2.08       0     1      1      1      1 
# 5 MARRIAGE         30000     0  1.55e+0 5.22e-1 3.01e-3 1   e0 -1.87e- 2  -1.36       0     1      1      1      1 
# 6 AGE              30000     0  3.55e+1 9.22e+0 5.32e-2 1.3 e1  7.32e- 1   0.0443    21    22     23     25     27 
# 7 PAY_0            30000     0 -1.67e-2 1.12e+0 6.49e-3 1   e0  7.32e- 1   2.72      -2    -2     -2     -1     -1 
# 8 PAY_2            30000     0 -1.34e-1 1.20e+0 6.91e-3 1   e0  7.91e- 1   1.57      -2    -2     -2     -2     -1 
# 9 PAY_3            30000     0 -1.66e-1 1.20e+0 6.91e-3 1   e0  8.41e- 1   2.08      -2    -2     -2     -2     -1 
# 10 PAY_4            30000     0 -2.21e-1 1.17e+0 6.75e-3 1   e0  1.00e+ 0   3.50      -2    -2     -2     -2     -1 

any(desc$n <max(desc$n))
# [1] FALSE

library(dplyr) # install.packages("dplyr")
credit_card_default %>%
  group_by(SEX)  %>%
  describe(EDUCATION, MARRIAGE, AGE) 
# described_varia…   SEX     n    na  mean    sd se_mean   IQR skewness kurtosis   p00   p01   p05   p10   p20   p25
# <chr>            <int> <int> <int> <dbl> <dbl>   <dbl> <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
# 1 AGE                  1 11888     0 36.5  9.40  0.0863     14   0.688   -0.0262    21    22    24    26    28    29
# 2 AGE                  2 18112     0 34.8  9.03  0.0671     13   0.761    0.0857    21    22    23    24    27    28
# 3 EDUCATION            1 11888     0  1.84 0.794 0.00728     1   0.964    2.03       0     1     1     1     1     1
# 4 EDUCATION            2 18112     0  1.86 0.788 0.00585     1   0.976    2.11       0     1     1     1     1     1
# 5 MARRIAGE             1 11888     0  1.57 0.519 0.00476     1  -0.0791  -1.37       0     1     1     1     1     1
# 6 MARRIAGE             2 18112     0  1.54 0.524 0.00389     1   0.0211  -1.35       0     1     1     1     1     1

credit_card_default %>%
  eda_paged_report(target = "DEFAULT", subtitle = "cc_default", 
                   output_dir = "./", output_file = "EDA.pdf", theme = "blue")
