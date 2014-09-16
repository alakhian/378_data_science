library("ggplot2")
options(java.parameters="-Xmx2g")
library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="C:/Program Files/Java/jdk1.7.0_51/ojdbc6.jar")

# In the following, use your username and password instead of "CS347_prof", "orcl_prof" once you have an Oracle account
possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_acc2634", "orcl_acc2634"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){
  nocomplains <- dbGetQuery(jdbcConnection, "select * from
(select company as Comp, count(complaint_id) as Complains from fin_complaint f, fin_company c where c.company_id = f.company_id
group by c.company
order by count(complaint_id) desc)
where rownum <= 10")
}
head(nocomplains)


ggplot(data = nocomplains, aes(x = COMP, y = COMPLAINS, fill = COMP)) + geom_bar(stat="identity")+
scale_fill_manual(values= c("red1", "blue1", "darkorange", "green", "yellow", "cyan", "black", "purple", "orange", "darkred")) +
ggtitle("Number of Complaints for the top ten companies")

if(!inherits(possibleError, "error")){
  datespec <- dbGetQuery(jdbcConnection, "Select * from (Select EXTRACT(month from date_recieved)as \"Month\", 
count(complaint_id) as Complaints,
Extract(year from date_recieved) as \"Year\"
from fin_complaint  where Extract(year from date_recieved) = 2012 OR 
Extract(year from date_recieved) = 2013
group by rollup(Extract(year from date_recieved), Extract(month from date_recieved))) where \"Month\" is not NULL")
  
}
head(datespec)

ggplot(data = datespec, aes(x = Month, y = COMPLAINTS, colour = factor(Year), group = Year )) + 
geom_line() +
ggtitle("Number of Complaints in 2012 and 2013") + scale_x_continuous(breaks=seq(1,12,1)) +
scale_y_continuous(limits = c(3000,10000), breaks=seq(3000,10000,1000))

dbDisconnect(jdbcConnection)