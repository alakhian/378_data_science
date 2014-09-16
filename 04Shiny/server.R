# server.R

library(shiny)

library("ggplot2")
#library("lubridate")
options(java.parameters="-Xmx2g")
library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="C:/Program Files/Java/jdk1.7.0_45/ojdbc6.jar")

# In the following, use your username and password instead of "CS347_prof", "orcl_prof" once you have an Oracle account
possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_acc2634", "orcl_acc2634"),
  error=function(e) e
)

if(!inherits(possibleError, "error")){
  dateSR <- dbGetQuery(jdbcConnection, "Select Extract(day from date_recieved) as \"dayR\", 
               Extract(day from date_sent) as \"dayS\",
               Extract(month from date_recieved) as \"Month\",
               Extract(Year from date_recieved) as \"Year\" from fin_complaint
               where Extract(month from date_recieved) = Extract(month from date_sent)")
  dbDisconnect(jdbcConnection)
}

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    ggplot(subset(dateSR, Month == input$obs), aes(x = dayR, y = dayS)) +
    geom_point(aes(colour = factor(Year))) + ggtitle("Date when Complaint Recieved vs Response was sent")  +
    ylab("Day Response was sent") + xlab("Day Complaint was recieved")  
    
  })
})
