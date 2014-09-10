DROP TABLE Diam_Customer CASCADE CONSTRAINTS ;

DROP TABLE Diam_Purchase CASCADE CONSTRAINTS ;

DROP TABLE Diam_Retailer CASCADE CONSTRAINTS ;

DROP TABLE Diam_Sale CASCADE CONSTRAINTS ;

CREATE TABLE Diam_Customer
  (
    customer_id INTEGER NOT NULL ,
    name        VARCHAR2 (250) ,
    gender      VARCHAR2 (10)
  ) ;
ALTER TABLE Diam_Customer ADD CONSTRAINT Diam_Customer_PK PRIMARY KEY ( customer_id ) ;

CREATE TABLE Diam_Purchase
  (
    purchase_id INTEGER NOT NULL ,
    diamond_id  INTEGER ,
    customer_id INTEGER ,
    sales_date  DATE
  ) ;
ALTER TABLE Diam_Purchase ADD CONSTRAINT Diam_Purchase_PK PRIMARY KEY ( purchase_id ) ;

CREATE TABLE Diam_Retailer
  (
    retailer_id INTEGER NOT NULL ,
    name        VARCHAR2 (250)
  ) ;
ALTER TABLE Diam_Retailer ADD CONSTRAINT Diam_Retailer_PK PRIMARY KEY ( retailer_id ) ;

CREATE TABLE Diam_Sale
  (
    sale_id     INTEGER NOT NULL ,
    retailer_id INTEGER ,
    diamond_id  INTEGER ,
    sales_date  DATE
  ) ;
ALTER TABLE Diam_Sale ADD CONSTRAINT Diam_Sale_PK PRIMARY KEY ( sale_id ) ;

ALTER TABLE Diam_Purchase ADD CONSTRAINT Diam_Purchase_Diam_Customer_FK FOREIGN KEY ( customer_id ) REFERENCES Diam_Customer ( customer_id ) ;

ALTER TABLE Diam_Purchase ADD CONSTRAINT Diam_Purchase_Diam_Diamonds_FK FOREIGN KEY ( diamond_id ) REFERENCES Diamonds ( "diamond_id" ) ;

ALTER TABLE Diam_Sale ADD CONSTRAINT Diam_Sale_Diam_Diamonds_FK FOREIGN KEY ( diamond_id ) REFERENCES Diamonds ( "diamond_id" ) ;

ALTER TABLE Diam_Sale ADD CONSTRAINT Diam_Sale_Diam_Retailer_FK FOREIGN KEY ( retailer_id ) REFERENCES Diam_Retailer ( retailer_id ) ;
