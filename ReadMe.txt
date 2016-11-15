DIGRE_pipline.R
---------------------------
This R script is the pipline of DIGRE algorithm to analyze the drug pair synergistic score, using drug treated gene expression data and dose response curve data.


Dependency
----------
*** R ***
Following packages need to be installed:
1. argparse
	If you find problem in library this package, please try to install "proto" and "getopt" also.
2. preprocessCore
3. org.Hs.eg.db
	If you find problem in library this package, please try to update your bioconductor using biocLite("BiocUpgrade").
	You may also need try to install "RSQLite".
4. KEGGgraph

*** python 2 ***
Following modules need to be installed:
1. argparse 
	This is build-in module in python 2.7. If you don't have python in your computer, I recommand to install anaconda, which include many useful modules.



Run the pipeline
----------------
1. Change the working directory of the "DIGRE_pipline.R", which is to change the path of the setwd("...") to your own path that contains this file.
2. Have the drug dose response data (csv file) in the data folder.
3. Have the drug treated gene expression data (csv file) in the data folder.
4. Have the pathway information "pathInfo.Rdata" and "gLassoGeneNet.Rdata" in the data folder.
5. The result of the pipline would be generated in the report folder.

Detail function see in code folder.
Detail input data requirement see in the data folder.



*** How to run the DIGRE pipline
First change the setwd("") command in DIGRE_pipline.R script to the folder contains this file. 
Then change the linux current directory to the folder contains this file.

You need to specify four argument to run the R script [gene expression file name] followed by [dose response file name], [-p 1(or 2)] and [-f 0.6(or other cut off between 0 and 1)]
-p: The pathway information to use: 1 for KEGG pathway information, 2 for constructed gene network information. Default is 1.
-f: The gene expression fold change cut off to use, should be decimal between zero and one. Default is 0.6.

To run the demofile, just type:
$Rscript DIGRE_pipline.R demoGeneExpr.csv demoDoseRes.csv  -p 1 -f 0.6

For more information, just type:
$Rscript DIGRE_pipline.R --help
