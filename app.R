require(shiny)  
require(shinyWidgets)
require(shinyBS)
library(shinyjs)
require(markdown)
require(DT)
#options(repos = BiocInstaller::biocinstallRepos())
#getOption("repos")
require(data.table)
require(dplyr)
require(Gviz)
require(Homo.sapiens)
require(OrganismDbi)
require(stringr)
require(condformat)
require(shinyjs)
require(ggbio)
require(bedr)
require(Rsamtools)
require(TxDb.Hsapiens.UCSC.hg19.knownGene)
require(TxDb.Hsapiens.UCSC.hg38.knownGene)
require(BSgenome.Hsapiens.UCSC.hg19)
require(BSgenome.Hsapiens.UCSC.hg38)
require(EnsDb.Hsapiens.v75)
require(EnsDb.Hsapiens.v86)
require(org.Hs.eg.db)


mdStyle <- "margin-left: 30px; margin-right: 30px"

intro <- function() {
  tabPanel("home",
           includeMarkdown(file.path(".","intro.md")),
           style=mdStyle,
           downloadLink(outputId = "instructionsScript", label="Download script for making input files", style = "color:white ; background-color: #0067cd"),
           downloadLink(outputId = "dependence", label="Download required dependecies for the script", style = "color:white ; background-color: #0067cd"),
           downloadLink(outputId = "configuration_file", label= "Download script for configration bash scritp", style = "color:white ; background-color: #0067cd"),
           br(),
           br(),
           br()
           
  )
}
myHome <- function() {
  tabPanel("Coverage Analysis",
           h1(strong("Interactive web-application to visualize and annotate low-coverage positions in clinical sequencing")),
           #titlePanel("Coverage sequencing Explorer"),
           helpText(em("Note:Select input options",
                       span("Upload your input bed.gz file with columns: chromosome, start, end, coverage by sample", style = "color:blue"))),
           shinyjs::useShinyjs(),
           includeScript('script/script.js'),
           sidebarPanel(    
             selectInput("UCSC_Genome", 
                         label = "Reference Genome",
                         choices = c("hg19", 
                                     "hg38"),
                         selected = "UCSC genome"),
             hr(),
             
             textInput(inputId = "Gene_name",
                       label= "Gene name"),
             #actionButton("button1",label= "Apply"),
             bsButton("button1",label= "Apply",  icon = icon("power-off"), style = "success", size = "extra-small"),
             shinyjs::hidden(p(id = "text1", "Running.....")),
             #actionButton("remove",label= "Refresh"),
             bsButton("remove",label= "Refresh",  icon = icon("power-off"), style = "success", size = "extra-small"),             helpText(em("write gene name corrisponding coordinate positions and action button apply")), 
             hr(),
             
             pickerInput("Chromosome", 
                         label = "Chromosome",
                         choices = c("chr1", "chr2","chr3", "chr4","chr5","chr6","chr7","chr8","chr9",
                                     "chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17",
                                     "chr18","chr19", "chr20", "chr21", "chr22", "chrX", "chrY","chrM",
                                     names("file1")),
                         options = list(`actions-box` = T),
                         multiple =FALSE),
             hr(),
             pickerInput("coverage_co", 
                         label = "Coverage threshold", 
                         choices = c(1:1000, "all",names("file1")), options = list(`actions-box` = T), multiple =FALSE),
             helpText(em("Select minimum value as coverage threshold")),       
             hr(),
             textInput(inputId = "Sample",
                       label= "Sample"),
             
             helpText(em("Select sample for coverage analysis. Example:sample_1")), 
             
             hr(),
             splitLayout(cellWidths = c("30%", "70%"), 
                         textInput(inputId = "transcript_id",
                                   label= "Transcript number"), 
                         textInput(inputId = "id_t",
                                   label= "Transcript ID")), #, width = "60px", height = "30px"),
             
             helpText(em("Retrieve your favourite transcript number from UCSC exons")),
             
             
             hr(),
             pickerInput("exon_number",
                         label= "exon number",
                         choices = c(1:150),options = list(`actions-box` = T), multiple =FALSE),
             #actionButton("button5",label= "Make exon"),
             bsButton("button5",label= "Make exon",  icon = icon("power-off"), style = "success", size = "extra-small"),
             shinyjs::hidden(p(id = "text1", "Running.....")),
             #actionButton("remove5",label= "Refresh"),
             bsButton("remove5",label= "Refresh",  icon = icon("power-off"), style = "default", size = "extra-small"),
             helpText(em("zooming one exon")), 
             hr(),
             hr(),
             
             textInput(inputId = "Start_genomicPosition",
                       label = "START genomic position"),
             
             textInput(inputId = "end_genomicPosition",
                       label = "END genomic position"),   
             helpText(em("change genomic intervall for zooming")),
             
             
             hr(),
             hr(),
             textInput(inputId = "query_Database",
                       label= "Region coordinates"),
             
             
             helpText(em("write to expland dbNSFP-annotated genomic positions. For example 2:166845670-166930180")), 
             hr(),
             
             hr(),
             downloadButton("downloadData", "Download", class = "btn-primary",style='padding:4px; font-size:120%')
           ),
           mainPanel(
             fileInput(inputId = "file1",
                       label = "Select input file",
                       accept = c("text/csv",
                                  ".bedGraph",
                                  ".bedGraph.gz",
                                  ".zip",
                                  ".gz",
                                  ".bed",
                                  "text/comma-separated-values,text/plain",
                                  ".csv")),
             checkboxInput("header", "Header", TRUE), 
             hr(),
             
             tabsetPanel(
               tabPanel("bed file", dataTableOutput("text")),
               tabPanel("UCSC gene", dataTableOutput("ccg")),
               tabPanel("UCSC exons", helpText(em("Extract protein coding positions from UCSC")), dataTableOutput("exon_pos")),
               tabPanel("Low-coverage positions", dataTableOutput("text_cv")),
               tabPanel("Gene coverage", plotOutput("all_gene"), dataTableOutput('df.l')),
               tabPanel("Exon coverage", helpText(em("This is a Gviz function and it plots exon with ideogram, genome coordinates, coverage information, Ensembl and UCSC gene annotation.
                                                     The annotation for the databases are directly fetched from Ensemb and all tracks will be plotted in a 3' -> 5' direction. ")), 
                        plotOutput("ens", dblclick = "plot1_dblclick",  brush = brushOpts( id = "plot1_brush", resetOnNew = TRUE)), dataTableOutput("tabExon")),
               tabPanel("Zoom to sequence", helpText(em("choose a few genomic intervals")),plotOutput("sequence")),
               tabPanel("Annotations on low-coverage positions",helpText(em("dbSNP-annotation collects all consequences found in VEP-defined canonical transcripts")),condformatOutput("uncover_position")) 
             ),
             hr(), 
             
             fluidRow(
               column(12,DT::dataTableOutput("x4"))
             )
           )
  )
}
myTab1 <- function() {
  tabPanel("Calculate AF by allele frequency app",
           
           # Application title
           titlePanel("Maximum credible population allele frequency"),
           
           ##### Bootstrap method for page costruction 
           fluidPage(
             fluidRow(
               ##### Sidebar
               column(8,wellPanel(radioButtons("inh",
                                               "Inheritance:",
                                               choices = list("monoallelic","biallelic"),
                                               selected = "monoallelic"),
                                  
                                  numericInput("prev","Prevalence = 1 in ... (people)",
                                               min = 1,max = 1e8,value = 500),
                                  options = NULL),
                      br(),
                      sliderInput("hetA","Allelic heterogeneity:", min = 0, max = 1,value = 0.1),
                      sliderInput("hetG",
                                  "Genetic heterogeneity:", min = 0, max = 1,value = 1),
                      br(),
                      sliderInput("pen", "Penetrance:", min = 0, max = 1, value = 0.5))),
             br(),
             column(8,
                    h3("Maximum credible population AF:"),
                    h2(textOutput("maxAF"),align="center",style = "color:blue")),
             column(8,
                    h3("Uncorver position",helpText(em("Low-coverage positions excluding sites annotated as variants with AF> maxAF (default maxAF value: 5%)"), 
                                                    align="center", style="color:blue"), style = "font-size: 100%; width: 100%",condformatOutput("uncoverPosition"))
                    
                    
             ),
             br(),
             br(),
             downloadButton("download_maxAF", "Download_maxAF", class = "btn-primary",style='padding:4px; font-size:80%', 
                            helpText("download low coverage position dbSNFP-annotation filtered by maximum allele frequency",
                                     class = "btn-primary",style='padding:4px; font-size:60%'))
             #)
           ))}


myTab2 <- function() {            
  tabPanel("Binomial distribution",
           titlePanel("Binomial distribution "),
           fluidRow(
             column(4,(numericInput("p",
                                    "Allele Fraction",
                                    min = 0,
                                    max = 1,
                                    value = 0.00001)),
                    hr(),
                    numericInput("num_all",
                                 "Variant reads",
                                 min=0,
                                 max=100000,
                                 value=10),
                    hr(), 
                    
                    textInput(inputId = "start_gp",
                              label = "START genomic position"),
                    
                    textInput(inputId = "end_gp",
                              label = "END genomic position"),   
                    helpText(em("Specify start and end coordinates for your genomic region of interest"))),
             
             
             column(4,
                    h2("consideration:"),
                    h3(htmlOutput("ci"))),
             column(4,
                    h2("Binomial Distribution", plotOutput("bd"))),
             column(10, h2("Cumulative distribution function"),
                    h3(plotOutput("pbinom"))))
           
  )}


myabout <- function() {
  tabPanel("contacts",
           includeMarkdown(file.path(".","CONTACTS.md")),
           style=mdStyle
  )
}



ui <- shinyUI(navbarPage("uncoverApp",
                         intro(),
                         myHome(),                   
                         myTab1(),
                         myTab2(),
                         myabout()
                         # preprocess()
))

now <- Sys.time()

server <- function (input, output, session){
  options(shiny.maxRequestSize=30*1024^2) 
  
  #attach static scripts  
  
  output$instructionsScript= downloadHandler(filename="make_bed.sh",
                                             content=function(file){
                                               file.copy("./script/make_bed_with_configuration_file.sh",file) # download static file 
                                             })
  output$dependence = downloadHandler(filename="preprocessing.R",
                                      content=function(file){
                                        file.copy("./script/preprocessing.R",file)
                                      })
  output$configuration_file= downloadHandler(filename = "uncoverapp.config",
                                             content = function(file){
                                               file.copy("./script/uncoverpp.config", file)
                                             })
  source('server-reactiveDF.R', local= TRUE)  
  source('server-tables.R', local= TRUE)
  source('server-plots.R', local=TRUE)
  source('server-annotation.R', local=TRUE)    
  source('server-maxAF.R', local=TRUE)
  source('server-binomial.R', local=TRUE)  
  observe({
    invalidateLater(1000)
    print(paste("Actual Time: ", Sys.time(), " - Endtime: ", now + 10))
    if (Sys.time() > now + 10) {
      print("Stop the App")
      stopApp()
    }
  })
}
shinyApp(server = server, ui = ui)
