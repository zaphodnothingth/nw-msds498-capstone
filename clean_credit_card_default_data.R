### Set wd, path and read file
completePath<- rstudioapi::getActiveDocumentContext()$path
nameOfMyFile <- sub(".*/", "", completePath)
workingDirectoryPath <- gsub(pattern = nameOfMyFile, replacement = "", x = completePath)
setwd(workingDirectoryPath)
my.datapath <- './Data/';
my.file <- paste(my.datapath,'credit_card_default.RData',sep='');
credit_card_default_raw <- readRDS(my.file)

###### data cleaning based on provided field rules + logical assumptions
# LIMIT_BAL - integer

# SEX       
# EDUCATION 
# MARRIAGE  
# AGE       
# 
# PAY_1 
# PAY_2
# PAY_3
# PAY_4
# PAY_5
# PAY_6
# 
# BILL_AMT1 
# BILL_AMT2 
# BILL_AMT3 
# BILL_AMT4 
# BILL_AMT5 
# BILL_AMT6 
# 
# PAY_AMT1  
# PAY_AMT2  
# PAY_AMT3  
# PAY_AMT4  
# PAY_AMT5  
# PAY_AMT6  