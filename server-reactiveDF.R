###make reactive database given reference genome 

txdb= reactive({if (input$UCSC_Genome == "hg19"){
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene}
  else{
    txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene}
})

#################make reactive dataframe given input file

value=reactiveValues()
mydata <- reactive ({
  inFile<-input$file1
  i= input$Sample
  if (is.null(input$file1)) {return(NULL)}
  df<- read.table(inFile$datapath, header = input$header, stringsAsFactors = F)
  colnames(df)[1:3]=c("chromosome","start","end")
  colnames(df)[-1:-3]=paste0("sample_", head(seq_along(df),-3))
  value= df
})

###Output of loaded file 

output$text<- #DT::renderDataTable({
  renderDataTable({
  validate(need(input$file1 != "", "Please, upload your file"))
  mydata()})

###make reactive dataset given input choosed by users

mysample<-reactive({
  i= input$Sample
  mydata() %>%
    dplyr:: select(chromosome, start, end,i) %>%
    dplyr::rename(value=i)
})

filtered_low<- reactive ({
  validate(
    need(input$file1 != "", "Unrecognized data set: Please upload your file")
  )
  mysample() %>%
    dplyr:: filter(chromosome == input$Chromosome, 
                   value <= as.numeric(input$coverage_co))
})
filtered_high<- reactive ({
  mysample() %>%
    dplyr:: filter(chromosome == input$Chromosome, 
                   value > as.numeric(input$coverage_co))
  
})

#######output dateset filtered 

output$text_cv <- DT::renderDataTable({
  validate(
    need(input$Gene_name != "" & input$Sample !="", "Please select all required input: Gene, Chromosome, Coverage threshold and Sample")
  )
  filtered_low()})