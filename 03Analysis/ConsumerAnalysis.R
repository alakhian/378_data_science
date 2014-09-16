library("ggplot2")
library("lubridate")
options(java.parameters="-Xmx2g")
library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="C:/Program Files/Java/jdk1.8.0_05/ojdbc6.jar")

# In the following, use your username and password instead of "CS347_prof", "orcl_prof" once you have an Oracle account
possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521:orcl", "C##cs347_acc2634", "orcl_acc2634"),
  error=function(e) e
)
if(!inherits(possibleError, "error")){
  #complaints <- dbGetQuery(jdbcConnection, "select * from complaindata")
  #complaints <- dbGetQuery(jdbcConnection, "select \"carat\", \"price\", r.name, sales_date from diamonds d, diam_sale s, diam_retailer r where d.\"diamond_id\" = s.diamond_id and s.retailer_id = r.retailer_id")
#  complaints <- dbGetQuery(jdbcConnection, "select company_response as \"Response\" , 100*count(company_response)/(select count(company_response) from COMPLAINDATA where company='Bank of America')
#AS \"Count\" from complaindata where company='Bank of America' group by company_response")
  responses <- dbGetQuery(jdbcConnection, "select * from (select company as \"company\", company_response as \"response\", 
  (count(*) / (select count(*) from fin_complaint complt2, fin_company compny2 where compny2.company_id = complt2.company_id and
    compny1.company = compny2.company group by company)) as \"percentage\" 
                          from fin_complaint complt1, fin_company compny1 where complt1.company_id = compny1.company_id and
                          complt1.company_id in (select company_id from fin_complaint group by 
                          company_id having count(*) > 5000) group by rollup(company, company_response) 
                          order by company
  ) where \"response\" is not null;")
  
  products <- dbGetQuery(jdbcConnection, "select * from (select company as \"company\", product as \"product\", 
  (count(*) / (select count(*) from fin_complaint complt2, fin_company compny2 where compny2.company_id = complt2.company_id and
    compny1.company = compny2.company group by company)) as \"percentage\" 
    from fin_complaint complt1, fin_company compny1 where complt1.company_id = compny1.company_id and
   complt1.company_id in (select company_id from fin_complaint group by 
    company_id having count(*) > 5000) group by rollup(company, product) 
    order by company
) where \"product\" is not null;")
  
  respByProduct <- dbGetQuery(jdbcConnection, "select * from (select product as \"product\", company_response as \"response\", 
  (count(*) / (select count(*) from fin_complaint complt2, fin_company compny2 where compny2.company_id = complt2.company_id and
    complt1.product = complt2.product group by product)) as \"percentage\" 
    from fin_complaint complt1, fin_company compny1 where compny1.company_id=complt1.company_id
    group by rollup(product, company_response) 
    order by product
) where \"response\" is not null;")
  
  dbDisconnect(jdbcConnection)
}
head(complaints)

#library(sqldf)
#response_data <- sqldf('select * from (select company as \"company\", company_response as \"response\", 
#  (count(*) / (select count(*) from complaints c2 where c1.company = c2.company group by company)) as \"percentage\"
#from complaints c1
#where company in (select company from complaints group by company having count(*) > 5000) 
#group by rollup(company, company_response) order by company) where \"response\" is not null')

#below plot works for BofA
#ggplot(data=complaints,  aes(x=factor(""),
#                             y=Count, fill = Response) ) + geom_bar(stat="identity")

ggplot(data=products,  aes(x=company, y=percentage, fill = product) ) + geom_bar(stat="identity") + ggtitle("Product Types for Companies With More Than 5000 Complaints") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggplot(data=responses,  aes(x=company, y=percentage, fill = response) ) + geom_bar(stat="identity") + ggtitle("Responses for Companies With More Than 5000 Complaints") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggplot(data=respByProduct,  aes(x=product, y=percentage, fill = response) ) + geom_bar(stat="identity") + ggtitle("Responses by Product Type") + theme(axis.text.x = element_text(angle = 90, hjust = 1))


#ggplot(data = diamonds) + geom_histogram(aes(x = carat))
#ggplot(data = diamonds) + geom_density(aes(x = carat, fill = "gray50"))
#ggplot(diamonds, aes(x = carat, y = price)) + geom_point()
#ggplot(subset(diamonds, NAME == 'ZALE CORP' | NAME == 'TIFFANY CO'), aes(x = NAME, y = price)) + geom_point()
#ggplot(subset(diamonds, year(SALES_DATE) == "2009"), aes(x = paste(year(SALES_DATE), month(SALES_DATE),sep="-"), y = price)) + geom_point()
