#Max calculation 

data <- reactive({
  myPrev = 1/input$prev
  if(input$inh=="monoallelic"){
    myMaxAF = (1/2) * myPrev * input$hetA * input$hetG * (1/input$pen)
  }
  if(input$inh=="biallelic"){
    myMaxAF = sqrt(myPrev) * input$hetA * sqrt(input$hetG) * (1/sqrt(input$pen))
  }
  myMaxAC = qpois(p=as.numeric(input$CI),
                  lambda=(input$popSize)*(myMaxAF))
  return(list(myMaxAF,myMaxAC))
}) 

output$maxAF <- renderText({signif(data()[[1]],3)})

uncover_maxaf <- reactive ({
  
  condformat(intBED()) %>%
    rule_fill_discrete(ClinVar, expression= ClinVar !=".", colours= c("TRUE"="red", "FALSE"="green")) %>%
    rule_fill_discrete(MutationAssessor, expression= grepl("H|M", MutationAssessor), colours= c("TRUE"="red", "FALSE"="green")) %>%
    rule_fill_discrete(c(M_CAP, AF_gnomAD), 
                       expression= M_CAP > 0.025 & AF_gnomAD <0.05,
                       colours= c("TRUE"= "red", "FALSE"= "salmon")) %>%
    rule_fill_discrete(c(start, end),
                       expression = grepl("H|M", MutationAssessor) & ClinVar !="." & M_CAP != "T" & AF_gnomAD < (signif(data()[[1]],3)) ,
                       colours= c("TRUE"= "yellow", "FALSE"= ""))%>%
    rule_css(c(start, end),
             expression = ifelse(grepl("H|M", MutationAssessor) & ClinVar !="." & M_CAP != "T" &  AF_gnomAD < (signif(data()[[1]],3)), "red", "green"), #& CADD_PHED > 20
             css_field = "color")
  
})

output$uncoverPosition <- renderCondformat ({
  validate(
    need(input$file1 != "", "Unrecognized data set: Please load your file"),
    need(input$Gene_name != "" & input$Sample != "", "Please select all required input: Gene, Chromosome, Coverage threshold and Sample")
  )
  validate(
    need(try(!is.null(uncover_maxaf())),'Unrecognized coordinates: Please change exon number input and be sure that input box "Region coordinates" is filled')
  )
  uncover_maxaf()
  progress <- shiny::Progress$new()
  on.exit(progress$close())
  progress$set(message = "table construction in progress", value = 0)
  Sys.sleep(0.1)
  uncover_maxaf() %>%
    dplyr::select(seqnames, start, end, value, REF, ALT, dbsnp, GENENAME, PROTEIN_ensembl, MutationAssessor,SIFT,Polyphen2,M_CAP,CADD_PHED,AF_gnomAD,
                  ClinVar,clinvar_MedGen_id,clinvar_OMIM_id,HGVSc_VEP,HGVSp_VEP)
})

###download excel with maxAF###

output$download_maxAF <- downloadHandler(
  filename = function() {
    paste('download_uncover_maxAF',Sys.Date(), '.xlsx', sep='')
  },
  content = function(file){
    condformat2excel(condform_table(), file, sheet_name = "Sheet1",
                     overwrite_wb = FALSE, overwrite_sheet = TRUE) 
  }
)  