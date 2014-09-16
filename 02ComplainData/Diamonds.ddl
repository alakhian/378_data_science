DROP TABLE Diamonds;

CREATE TABLE Diamonds (
   "diamond_id" NUMBER(7,2) NOT NULL,
   "carat" NUMBER(7,2),
   "cut" VARCHAR2(250),
   "color" VARCHAR2(250),
   "clarity" VARCHAR2(250),
   "depth" NUMBER(7,2),
   "tbl" NUMBER(7,2),
   "price" NUMBER(7,2),
   "x" NUMBER(7,2),
   "y" NUMBER(7,2),
   "z" NUMBER(7,2)
);
   ALTER TABLE Diamonds ADD CONSTRAINT Diamonds_PK PRIMARY KEY ( "diamond_id" ) ;
