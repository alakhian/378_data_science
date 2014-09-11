library("ggplot2", lib.loc="/Library/Frameworks/R.framework/Versions/3.0/Resources/library")
library("lubridate", lib.loc="/Library/Frameworks/R.framework/Versions/3.0/Resources/library")
options(java.parameters="-Xmx2g")
library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home/ojdbc6.jar")

# In the following, use your username and password instead of "CS347_prof", "orcl_prof" once you have an Oracle account
possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_prof", "orcl_prof"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){
  diamonds <- dbGetQuery(jdbcConnection, "select \"carat\", \"price\", r.name, sales_date from diamonds d, diam_sale s, diam_retailer r where d.\"diamond_id\" = s.diamond_id and s.retailer_id = r.retailer_id")
  dbDisconnect(jdbcConnection)
}
head(diamonds)
ggplot(data = diamonds) + geom_histogram(aes(x = carat))
ggplot(data = diamonds) + geom_density(aes(x = carat, fill = "gray50"))
ggplot(diamonds, aes(x = carat, y = price)) + geom_point()
ggplot(subset(diamonds, NAME == 'ZALE CORP' | NAME == 'TIFFANY CO'), aes(x = NAME, y = price)) + geom_point()
ggplot(subset(diamonds, year(SALES_DATE) == "2009"), aes(x = paste(year(SALES_DATE), month(SALES_DATE),sep="-"), y = price)) + geom_point()
