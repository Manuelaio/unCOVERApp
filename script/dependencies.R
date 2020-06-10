setRepositories(ind = 1:5)
install.packages(c('shiny', 'shinydashboard'), repos='http://cran.rstudio.com/')
install.packages('BiocManager')
BiocManager::install('BiocInstaller')



list_of_packages_bio <-c('Gviz', 'Homo.sapiens','org.Hs.eg.db', 'TxDb.Hsapiens.UCSC.hg38.knownGene', 
  'TxDb.Hsapiens.UCSC.hg19.knownGene','EnsDb.Hsapiens.v75', 'EnsDb.Hsapiens.v86', 'OrganismDbi',
  'BSgenome.Hsapiens.UCSC.hg19', 'Rsamtools', 'GenomicRanges')

list_of_packages_cran <- c('markdown', 'shiny', 'shinyjs', 'shinyBS', 'shinyWidgets', 'shinycssloaders', 'DT', 
                      'openxlsx', 'condformat', 'stringr', 'bedr',  'rlist', 
                      'processx', 'dplyr')

lst_to_install <- list_of_packages_cran[!(list_of_packages_cran %in% installed.packages()[, "Package"])]
lst_to_install_bioc<- list_of_packages_bio[!(list_of_packages_bio %in% installed.packages()[, "Package"])]

n_cores <- parallel::detectCores()
install.packages(lst_to_install, Ncpus = n_cores - 1, clean = TRUE)
BiocManager::install(lst_to_install_bioc, Ncpus = n_cores - 1, clean = TRUE)

list_of_packages<- c('markdown', 'shiny', 'shinyjs', 'shinyBS', 'shinyWidgets', 'shinycssloaders', 'DT', 
                     'openxlsx', 'condformat', 'stringr', 'bedr',  'rlist', 
                     'processx', 'dplyr', 'Gviz', 'Homo.sapiens','org.Hs.eg.db', 'TxDb.Hsapiens.UCSC.hg38.knownGene', 
                     'TxDb.Hsapiens.UCSC.hg19.knownGene','EnsDb.Hsapiens.v75', 'EnsDb.Hsapiens.v86', 'OrganismDbi',
                     'BSgenome.Hsapiens.UCSC.hg19', 'Rsamtools', 'GenomicRanges')

not_installed <- list_of_packages[!(list_of_packages %in% installed.packages()[, "Package"])]

if(length(not_installed) == 0) {
    print("Good to go!")
} else {
    print("You need to install these packages!")
    not_installed
}

