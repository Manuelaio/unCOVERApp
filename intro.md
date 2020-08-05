### An interactive graphical web application for clinical assessment of sequence coverage at base-pair level

This is a web application for graphical inspection of sequence coverage within 
gene regions. 
unCOVERApp allows:

- interactive plots displaying sequence gene coverage down to base-pair 
resolution and functional and clinical downloadable annotation of base-pair 
positions within user-defined coverage gaps (` Coverage Analysis` page).


- calculation and definition of maximum credible allele frequency (http://cardiodb.org/allelefrequencyapp/) to be used as allele frequency 
filtering threshold (` Calculate AF by allele frequency app ` page).

- calculation of binomial probability, for somatic variants, that position 
coverage is adequate to detect variant allele provided the expected allelic 
fraction and the required number of variant reads  (` Binomial distribution`
page). 

### Documentation 

All unCOVERApp functionalities need of bed file, a text file tab separated
with chromosome, start position, end position, coverage value and nucleotide 
reads for each position. 
In the first page **Preprocessing**, users are able to prepare the bed file 
given a list of genes and a list of bam files.


Users need to make two input files to analyse own data to app: 


- a text file, with .txt extension, containing HGNC official gene name(s) one per 
row and loading in ` Load a gene(s) file ` box. An example file is included in
extdata of uncoverappLib packages, users can also download the file `mygene.txt`
[here](https://github.com/Manuelaio/unCOVERApp/blob/master/script/mygene.txt). 
Below is an example of genes list. 


```{r}
DNAJC8
GNB1
PEX10
RPL22
```

- a text file, with .list extension, containing *absolute paths* to BAM files
(one per row) and loading in ` Load bam file(s) list ` box. BAM file(s) should 
be indexed. Below is an example of bam.list in a Unix-like OS including macOS. 

```{r}
/home/user/bam/sample1.bam
/home/user/bam/sample2.bam
/home/user/bam/smaple3.bam
```


Once all inputs are loading, a progress bar appears during processing phase. 
The output will be broke if in list there are incorrect HGNC official gene names. 
An unrecognized gene name(s) table  will be displayed. 

Below is a snippet of bed file output of **Preprocessing** 
unCOVERApp. Users could find the example file [here](https://github.com/Manuelaio/unCOVERApp/blob/master/script/POLG.example.bed)

```{r}

chr15   89859516        89859516        68      A:68
chr15   89859517        89859517        70      T:70
chr15   89859518        89859518        73      A:2;G:71
chr15   89859519        89859519        73      A:73
chr15   89859520        89859520        74      C:74
chr15   89859521        89859521        75      C:1;T:74

```


The input BAM file(s) should be also processed on a local machine with the 
Rscript available on unCOVERAPP **Preprocessing** page
[here](https://github.com/Manuelaio/unCOVERApp/blob/master/script/Rpreprocessing.R) 
or with other tools. In this cae, users can load your file directly at 
**Coverage Analysis**  page in `Select input file` box. 

Once bed file was made, users can move in **Coverage Analysis** page for own 
analysis and push `load preprared input file` button.

To assess sequence coverage the following **input parameters** must be 
specified in the sidebar of the **Coverage Analysis** section:


- ` Reference Genome` : reference genome (hg19 or hg38) 

- ` Gene name ` and push ` Apply ` button:  HGNC official gene name 

- ` coverage threshold ` : required coverage threshold  

- ` Sample  ` : sample(s) to analyze according to help text indications on the 
App page

- ` Transcript number ` : transcript number as in first column 
of ` Exon genomic coordinate positions from UCSC ` output App table.

- ` exon number ` and push ` Make exon ` : to zoom in a specific exon


Other input sections, as ` Chromosome `, ` Transcritp ID `, ` START genomic position `, 
` END genomic position ` and ` Region coordinate `, are dynamically filled. 


unCOVERApp generates the following **outputs** : 


- unfiltered BED file in` bed file ` and the corresponding filtered dataset 
in ` Low coverage positions ` 

- UCSC gene coordinates in ` UCSC gene ` table

- exon coordinates and transcript number in ` UCSC exon ` table

- sequence gene coverage plot in ` Gene coverage `. The plot displays 
chromosome ideogram, genomic location and gene annotations from *Ensembl*  
and transcripts annotation from *UCSC*.
Related table shows the number of 
uncovered position in each exons given a user-defined transcript  number 

- plot of a specific exon, selected by sidebar  ` exon number ` , 
in ` Exon coverage `. Related table shows the number of Low coverage positions
present in ClinVar and with a high impact annotation. 

- dbNSFP annotation of low coverage positions can be found in  
`Annotation on low-coverage positions ` . Users may click on download button 
and save the table as spreadsheet format with certain cells colored  following 
thresholds for clinically-relevant variant parameters (gnomAD allele frequency,
CADD, MAP_CAP, SIFT, Polyphen2, Clinvar, OMIM ID, HGVSp and HGVSc, functional
impact of a variant score).



In **Calculate maximum credible allele frequency** page, users can set 
allele frequency cut-offs based on assumptions about the genetic architecture 
of the disease, if not calculated, variant allele frequency 5% will be used 
instead for filtering


The last page **Binomial distribution** returns the 95% binomial probability 
distribution of the variant read number on the input genomic position 
(` START genomic position` and ` END genomic position `). 

Users must specify as input the `allele fraction` (the expected fraction of
variant reads, probability of success) and `Variant reads ` (the minimum 
number of variant reads required by the user to support variant calling,
number of successes). 



