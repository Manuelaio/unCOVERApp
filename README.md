This repository is home of unCOVERApp, a web application for clinical assessment and annotation of coverage gaps in target genes. 
[![Build Status](https://travis-ci.org/Manuelaio/unCOVERApp.svg?branch=master)](https://travis-ci.org/Manuelaio/unCOVERApp)

Users can clone or download this repository.  `sorted.bed.gz` and  `sorted.bed.gz.tbi` can be downloaded from [zenodo](https://zenodo.org/record/3747448#.XpBmnVMzbOR). 



We recommend to check for the following files in the working directory: 


* `sorted.bed.gz`: a genomically-sorted, TABIX-indexed, BGZipped BED file containing selected columns from dbNSFP version  v4.0. Only following columns from chromosome-specific dbNSFP files should be selected (in that specific order): $1,$9,$9,$3,$4,$7,$13,$16,$2,$2,$39,$48,$78,$104,$229,$365,$370,$371 and merged into a single file. The resulting file (i.e. db_all.bed) should be then sorted, BGZipped as below. The output of these commands MUST be redirected to file "sorted.bed.gz" and TABIX-indexed. 


* `sorted.bed.gz.tbi`: TABIX-indexed file


* `uncoverApp.R script `

in www/ directory: 

* `preprocessing.R ` 

* `dependence.R `

* `script.js `

* `uncoverapp.config `

* `make_bed.sh `: bash script to create the input file for unCOVERApp. 

Compile a `configuration file ` specifying absolute path of: unCOVERApp folder, txt file containing HGNC gene name(s)(one per row), and path to file with ".list" extension containing absolute paths to BAM files (one per row) and folder output location. Compile genome reference (hg19 or hg38) and chromosome notation BAM (number refers to 1, 2, ???X,.M notation BAM, chr refers to chr1, chr2,??? chrX, chrM notation BAM). The resulting unCOVERApp input file is a BED file (tab-separated) containing depth of coverage (DoC) for each genomic position (one per row) of target genes for as many samples as many BAM files are listed in the ".list" file. Finally you run following bash command:

```sh
bash www/make_bed.sh www/uncoverapp.config

```

[![Build Status](https://travis-ci.com/Manuelaio/test_app.svg?token=25AMAYuQwZENC1xVJVSe&branch=master)](https://travis-ci.com/Manuelaio/test_app)

The log file is a trouble shooter, so please revise when any problem happens. 
Bash script creates a new directory named with current date in users-defined location, in which input file is stored called *multisample.bed.gz file*.

Or, you can install the shiny package in `R`, set up the R-environment running [Rscript](https://github.com/Manuelaio/test_dependence/blob/master/dependencies.R) and use the function `runGithub()`


``` {r}
if (!require('shiny')) install.packages("shiny")


shiny::runGitHub("unCOVERApp", "Manuelaio", subdir = "uncoverApp.R")

``` 

In this case, you are able to use all unCOVERApp functions, except annotation with dbNSFP. 

