### Prepration input file 
In this section users can prepare bed file required for clinical 
assessment of low depth of coverage genomic regions. 
The resulting unCOVERApp input file is a BED file (tab-separated) containing a 
minimum of five columns, chromosome, start and end position, depth of coverage 
(DoC) and and nucleotide counts for each genomic position of target genes for as
many samples as many BAM files are listed in the ".list" file.


The processing time depends on the dimension size of bam files and the number of
genes to invstigate. If many genes need to be analyzed we recommend:

-to download Rscritp attached below or use other tools to obtain bed or bed.gz file


-to load the input file in Coverage Analysis page 

### Documentation 

To prepare input file and investigate coverage annotation the following **input parameters** must be specified in the sidebar of the **preprocessing** section:


- `Genome`: choose reference genome (hg19 or hg38) 

- ` notation ` : chromosome notation BAM,  `number` refers to 1, 2, ..., X,.M 
                notation BAM, `chr` refers to chr1, chr2, ... chrX, chrM notation BAM

-  ` Load a gene(s) file ` : loading txt file containing HGNC gene name(s)
                             (one per row)

- ` Load bam file(s) list ` : loading path to file with ".list" extension containing 
                              absolute paths to BAM files (one per row)