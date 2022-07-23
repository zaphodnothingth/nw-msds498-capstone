### Set wd, path and read file
completePath<- rstudioapi::getActiveDocumentContext()$path
nameOfMyFile <- sub(".*/", "", completePath)
workingDirectoryPath <- gsub(pattern = nameOfMyFile, replacement = "", x = completePath)
setwd(workingDirectoryPath)
my.datapath <- './Data/';
my.file <- paste(my.datapath,'credit_card_default.RData',sep='');
credit_card_default <- readRDS(my.file)

# subset the data
ccd_train <- subset(credit_card_default, train == 1,
                    select=ID:DEFAULT) # drop groups
ccd_test <- subset(credit_card_default, test == 1,
                   select=ID:DEFAULT) 
ccd_validate <- subset(credit_card_default, validate == 1,
                       select=ID:DEFAULT) 
