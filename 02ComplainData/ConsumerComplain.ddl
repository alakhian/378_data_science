create table complaindata
( Complaint_ID varchar(100),
  Product varchar(100), 
  Sub_product varchar(100), 
  Issue varchar(200),
  Sub_Issue varchar(200),
  State varchar (50),
  Zip_Code varchar(25),
  Submittedvia varchar(50),
  Date_Recieved date,
  Date_Sent date,
  Company varchar(100),
  Company_Response varchar(200),
  Timely varchar(10),
  dispute varchar(10)
);

#Data populated through import in SQL Developer

create sequence def_seq
start with 1 
increment by 1 
nomaxvalue;

create table fin_company as select def_seq.nextval as company_id, company from 
  		    (select distinct company from complaindata

create table fin_complaint as select f.complaint_id, f.product, f.sub_product, f.issue, f.sub_issue, f.state, f.zip_code, f.submittedvia, 
                                     f.date_recieved, f.date_sent, f.timely, f.dispute, co.company_id 
                                     from complaindata f, fin_company co where co.company = f.company