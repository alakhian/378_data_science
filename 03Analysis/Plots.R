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
  dbDisconnect(jdbcConnection)
}
head(nocomplains)

ggplot(data = nocomplains, aes(x = COMP, y = COMPLAINS)) + geom_bar(stat="identity")
