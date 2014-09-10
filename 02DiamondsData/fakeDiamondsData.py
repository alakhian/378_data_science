females=["Sophia","Emma","Isabella","Olivia","Ava","Emily","Abigail","Mia","Madison","Elizabeth","Chloe","Ella","Avery","Addison","Aubrey","Lily","Natalie","Sofia","Charlotte","Zoey","Grace","Hannah","Amelia","Harper","Lillian","Samantha","Evelyn","Victoria","Brooklyn","Zoe","Layla","Hailey","Leah","Kaylee","Anna","Aaliyah","Gabriella","Allison","Nevaeh","Alexis","Audrey","Savannah","Sarah","Alyssa","Claire","Taylor","Riley","Camila","Arianna","Ashley","Brianna","Sophie","Peyton","Bella","Khloe","Genesis","Alexa","Serenity","Kylie","Aubree","Scarlett","Stella","Maya","Katherine","Julia","Lucy","Madelyn","Autumn","Makayla","Kayla","Mackenzie","Lauren","Gianna","Ariana","Faith","Alexandra","Melanie","Sydney","Bailey","Caroline","Naomi","Morgan","Kennedy","Ellie","Jasmine","Eva","Skylar","Kimberly","Violet","Molly","Aria","Jocelyn","Trinity","London","Lydia","Madeline","Reagan","Piper","Andrea","Annabelle"]

males=["Jacob","Mason","Ethan","Noah","William","Liam","Jayden","Michael","Alexander","Aiden","Daniel","Matthew","Elijah","James","Anthony","Benjamin","Joshua","Andrew","David","Joseph","Logan","Jackson","Christopher","Gabriel","Samuel","Ryan","Lucas","John","Nathan","Isaac","Dylan","Caleb","Christian","Landon","Jonathan","Carter","Luke","Owen","Brayden","Gavin","Wyatt","Isaiah","Henry","Eli","Hunter","Jack","Evan","Jordan","Nicholas","Tyler","Aaron","Jeremiah","Julian","Cameron","Levi","Brandon","Angel","Austin","Connor","Adrian","Robert","Charles","Thomas","Sebastian","Colton","Jaxon","Kevin","Zachary","Ayden","Dominic","Blake","Jose","Oliver","Justin","Bentley","Jason","Chase","Ian","Josiah","Parker","Xavier","Adam","Cooper","Nathaniel","Grayson","Jace","Carson","Nolan","Tristan","Luis","Brody","Juan","Hudson","Bryson","Carlos","Easton","Damian","Alex","Kayden","Ryder"]

retailers = ['ZALE CORP','STERLING JEWELERS INC','FRED MEYER JEWELERS','HELZBERG DIAMONDS','ULTRA STORES INC','SAMUELS JEWELERS','TIFFANY CO','ROGERS ENTERPRISES','BEN BRIDGE JEWELER','DON ROBERTO','CHARM JEWELRY LTD','NA HOKU','REEDS JEWELERS','JAMES AVERY CRAFTSMAN','SHERWOOD MANAGEMENT CO','BEN MOSS JEWELLERS','BIRKS and MAYORS INC','HANNOUSH JEWELERS','MAUI DIVERS OF HAWAII','RIDDLES GROUP, INC','TOURNEAU','CARTIER','MOVADO GROUP INC','HARRY RITCHIES JEWELERS','KINGS OF NEW CASTLE','HARRIS ORIGINALS','SHANE CO','MORGAN MANAGEMENT','BULGARI CORPORATION OF AMERICA','FINKS JEWELERS','GOLDENWEST DIAMOND CORP','SASLOWS','VAN CLEEF ARPELS','JENSEN JEWELERS','DEVONS JEWELERS','ROSS-SIMONS JEWELERS','CR JEWELERS','POLLACK CORP','ROBBINS BROTHERS JEWELRY','THE JEWELERS INC','DE BEERS DIAMOND JEWELLERS','MICHAELS','REEDS JEWELERS','BRODKEY BROTHERS','HARRY WINSTON INC','MICHAEL HILL JEWELLER','ROGERS JEWELRY CO','GREENBERGS JEWELERS','LEE MICHAELS FINE JEWELERS','LUX BOND and GREEN']
from datetime import timedelta
import datetime
from random import randint
import random

for j in range(1, 101) :
   print 'insert into diam_customer(customer_id, name, gender) values(' + str(j) + ", '" + males[j - 1] + "', '" + "m" + "');"
for j in range(101, 201) :
   print 'insert into diam_customer(customer_id, name, gender) values(' + str(j) + ", '" + females[j - 101] + "', '" + "f" + "');"
for j in range(0, len(retailers)) :
   print 'insert into diam_retailer(retailer_id, name) values(' + str(j) + ", '" + retailers[j] + "');"
   
d3 = datetime.datetime.strptime('01012009', '%d%m%Y').date()
d4 = datetime.datetime.strptime('31122013', '%d%m%Y').date()
def random_date(start, end) :
    return start + timedelta(seconds=randint(0, int((end - start).total_seconds())))
def toDate(date) :
    return "TO_DATE('" + str(date) + "', 'YYYY-MM-DD')"

sid = 0
pid = 0
for i in range(1,53940 + 1) :
    date = random_date(d3, d4)
    n = 1
    if randint(1,10) > 8 : n = 2
    r = randint(0,len(retailers)-1)
    if i % 2 == 0 : 
        m = randint(1,100)
        pid+=1
        print "insert into diam_purchase(purchase_id, diamond_id, customer_id, sales_date) values(" + str(pid) + ", " + str(i) + ", " + str(m) + ", " + toDate(date)+");"
        sid+=1
        print "insert into diam_sale(sale_id, diamond_id, retailer_id, sales_date) values(" + str(sid) + ", " + str(i) + ", " + str(r) + ", " + toDate(date)+");"
        if n == 2 : 
            f = randint(101,200)
            pid+=1
            print "insert into diam_purchase(purchase_id, diamond_id, customer_id, sales_date) values(" + str(pid) + ", " + str(i) + ", " + str(f) + ", " + toDate(date)+");"
            sid+=1
            print "insert into diam_sale(sale_id, diamond_id, retailer_id, sales_date) values(" + str(sid) + ", " + str(i) + ", " + str(r) + ", " + toDate(date)+");"
    else : 
        f = randint(101,200)
        pid+=1
        print "insert into diam_purchase(purchase_id, diamond_id, customer_id, sales_date) values(" + str(pid) + ", " + str(i) + ", " + str(f) + ", " + toDate(date)+");"
        sid+=1
        print "insert into diam_sale(sale_id, diamond_id, retailer_id, sales_date) values(" + str(sid) + ", " + str(i) + ", " + str(r) + ", " + toDate(date)+");"
        if n == 2 : 
            m = randint(1,100)
            pid+=1
            print "insert into diam_purchase(purchase_id, diamond_id, customer_id, sales_date) values(" + str(pid) + ", " + str(i) + ", " + str(m) + ", " + toDate(date)+");"
            sid+=1
            print "insert into diam_sale(sale_id, diamond_id, retailer_id, sales_date) values(" + str(sid) + ", " + str(i) + ", " + str(r) + ", " + toDate(date)+");"
            
    if i % 100 == 0 : print "commit;"
print "commit"