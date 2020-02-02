#####output binomial distribution#####
df_subset <- reactive({
  validate(
    need(input$file1 != "", "Unrecognized data set: Please load your file"))
  validate(
    need(input$start_gp != "", "Please, select genomic intervals"))
  mysample()
  a <- subset(mysample(),start == as.numeric(input$start_gp)& end == as.numeric(input$end_gp))
  cov_ex<- as.numeric(a$value)
  print(cov_ex)
})

output$bd<- renderPlot({
  library(stats)
  library(stats)
  p=seq(0,1,by=0.0001)
  
  ic<-qbinom(p = c(0.025, 0.975), size = df_subset(), prob =input$p)
  barplot(dbinom(x=1:df_subset(), size=df_subset(), p= input$p) ,main = paste(ic))
})

output$pbinom<- renderPlot({
  library(stats)
  #c=input$num_all
  p=seq(0,1,by=0.0001)
  Fx=pbinom(q=1:df_subset(), size=df_subset(), prob = input$p)
  npro=Fx[as.numeric(input$num_all)]
  leg= (1-npro)*100
  
  #leggend= (1-Fx[input$num_all]) *100 
  #print(leggend)
  if (is.na(npro)){
    txt= "under threshold"}
  else{
    txt= paste("the probability of detecting more of", input$num_all, "reads wiht variant alleles would be:", leg, "%")
  }
  plot(1:df_subset(), Fx, type='h',xlab= "number of trials",
       main= txt)
  abline(v=input$num_all, col= "red")
})

output$ci<- renderText({
  #return(df_subset())
  ci_print<-qbinom(p = c(0.025, 0.975), size = df_subset(), prob =input$p) 
  ci_in=c(ci_print[1]:ci_print[2])
  number= ci_print[1]
  number2=ci_print[2]
  thr= as.numeric(df_subset())
  # if (thr < input$coverage_co) { 
  if (number2 < input$num_all) {
    print(paste("<span style=\"color:red\">According to binomial probability model there is 95% probability that your variant is supported by: </span>", number, number2,
                "<span style=\"color:red\"> reads </span>"))
    
  }else{
    print(paste("<span style=\"color:blue\">According to binomial probability model there is 95% probability that your variant is supported by: </span>", number, number2,
                "<span style=\"color:blue\"> reads </span>"))
  }
})  


