###                    process_pipline.R                   ###
### ====================================================== ###
# This R script is a pipline to analyze drug pair synergy


#######################################
### Set working directory
#######################################
# User needs to change setwd() to their own directory that contains this script 
setwd("/home/minzhe/Project/DIGREsyn-Rscript")

suppressMessages(library(argparse))


#######################################
### 0. Parse comandline argument
#######################################

### get arguments
parser <- ArgumentParser(description = "This pipline is to analyze drug pair syngergy using DIGRE model.")
parser$add_argument("geneExp", type = "character", help = "Passing in the gene expression data file name.")
parser$add_argument("doseRes", type = "character", help = "Passing in the dose response data file name.")
parser$add_argument("-p", "--pathway", type = "integer", default = 1, help =  "Specify the pathway information to use: 1 for consctructed KEGG pathway information, 2 de novo construction of gene network with own dataset. Default is 1.")
parser$add_argument("-f", "--fold", type = "double", default = 0.6, help = "The gene expression fold change cut off to use, should be decimal between zero and one. Default is 0.6.")

pip_args <- parser$parse_args()
geneExp <- pip_args$geneExp
doseRes <- pip_args$doseRes
pathway <- pip_args$pathway
fold <- pip_args$fold


### concatenate input and output file path
cur.path <- getwd()
doseRes.path <- paste(cur.path, "/data/", doseRes, sep = "")
geneExp.path <- paste(cur.path, "/data/", geneExp, sep = "")
res.path <- paste(cur.path, "/report/", unlist(strsplit(geneExp, ".", fixed = TRUE))[1], ".scoreRank.csv", sep = "")





#######################################
### 1. Load library and functions
#######################################
cat("Loading packages and functions......\n")
cat("------------\n")
suppressMessages(library(preprocessCore))
suppressMessages(library(org.Hs.eg.db))
suppressMessages(library(KEGGgraph))

source("code/doseRes.R")
source("code/profileGeneExp.R")
source("code/scoring.R")
source("code/constGeneNet.R")
load("data/CGP.mat.RData")
load("data/KEGGnet.mat.RData")



#######################################
### 2. Read data
#######################################

# read dose response data
doseRes <- readDoseRes.csv(doseRes.path)

# prepare drug treated gene expression data
geneExpDiff <- profileGeneExp(geneExp.path)

# parse gene interaction data if uploaded
if (pathway == 2) {
      geneNet.mat <- constGeneNet(geneNet.path)
}


########################################
### 3. Scoring by DIGRE model
########################################
cat("Fold change cut off used: ", fold, "(default = 0.6)\n", sep = "")
if (pathway == 1) {
      cat("Pathway information used: KEGG pathway information\n")
      res <- scoring(geneExpDiff = geneExpDiff, doseRes = doseRes, CGP.mat = CGP.mat, GP.mat = KEGGnet.mat, fold = fold)
}
if (pathway == 2) {
      cat("Pathway information used: User specified gene network\n")
      res <- scoring(geneExpDiff = geneExpDiff, doseRes = doseRes, CGP.mat = CGP.mat, GP.mat = geneNet.mat, fold = fold)
}

res.score <- res$scoreRank
write.csv(res.score, res.path, row.names = FALSE)
cat("\nScoring done, result file generated in report folder.\n")



