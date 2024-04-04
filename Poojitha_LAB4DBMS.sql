Create database Ecommerce;
Use Ecommerce;
Create table if not exists supplier (
SUPP_NAME varchar(50) NOT NULL,
SUPP_CITY varchar(50) NOT NULL,
SUPP_PHONE varchar(50) NOT NULL);

ALTER TABLE supplier ADD column
SUPP_ID int PRIMARY KEY;

ALTER TABLE supplier
MODIFY COLUMN SUPP_ID BIGINT AUTO_INCREMENT;

Create table if not exists customer (
CUS_ID int PRIMARY KEY,
CUS_NAME varchar(20) NOT NULL,
CUS_PHONE varchar(10) NOT NULL,
CUS_CITY varchar(30) NOT NULL,
CUS_GENDER char);

Create table if not exists category (
CAT_ID int PRIMARY KEY,
CAT_NAME varchar(20) NOT NULL);

Create table if not exists product (
PRO_ID int PRIMARY KEY,
PRO_NAME varchar(20) NOT NULL DEFAULT "Dummy",
PRO_DESC varchar(60),
CAT_ID int,
FOREIGN KEY (CAT_ID) REFERENCES category(CAT_ID));

Create table if not exists supplier_pricing (
PRICING_ID int PRIMARY KEY,
PRO_ID int,
SUPP_ID int,
SUPP_PRICE int DEFAULT 0,
FOREIGN KEY (PRO_ID) REFERENCES product(PRO_ID),
FOREIGN KEY (SUPP_ID) REFERENCES supplier(SUPP_ID));

ALTER TABLE supplier_pricing
MODIFY COLUMN SUPP_ID BIGINT;

Create table if not exists `order` (
ORD_ID int PRIMARY KEY,
ORD_AMOUNT int NOT NULL,
ORD_DATE DATE NOT NULL,
CUS_ID int,
PRICING_ID int,
FOREIGN KEY (CUS_ID) REFERENCES customer(CUS_ID),
FOREIGN KEY (PRICING_ID) REFERENCES supplier_pricing(PRICING_ID));

create table if not exists rating (
RAT_ID int PRIMARY KEY,
ORD_ID int,
RAT_RATSTARS int NOT NULL,
FOREIGN KEY (ORD_ID) REFERENCES `order`(ORD_ID));

INSERT INTO supplier values( 1, 'Rajesh Retails', 'Delhi', '1234567890');
INSERT INTO supplier values(2, 'Appario Ltd', 'Mumbai', '2589631470');
INSERT INTO supplier values(3, 'Knome products', 'Banglore', '9785462315');
INSERT INTO supplier values(4, 'Bansal Retails', 'Kochi', '8975463285');
INSERT INTO supplier values(5, 'Mittal Ltd.', 'Lucknow', '7898456532');

insert into customer values(1,"AAKASH",'9999999999',"DELHI",'M');
insert into customer values(2,"AMAN",'9785463215',"NOIDA",'M');
insert into category values( 1,"BOOKS");
insert into category values( 2,"GAMES");
insert into category values( 4,"ELECTRONICS");
insert into product values(1,"GTA V","Windows 7 and above with i5 processor and 8GB RAM",1);
insert into product values(2,"TSHIRT","SIZE-L with Black, Blue and White variations",1);
insert into product values(3,"ROG LAPTOP","Windows 10 with 15 inch screen, i7 processor, 1TB SSD",4);
insert into product values(7,"Boat Earphones","1.5Meter long Dolby Atmos",4);
insert into supplier_pricing values(1,1,1,1500);
insert into supplier_pricing values(2,2,1,30000);
insert into supplier_pricing values(5,7,1,1000);
insert into `order` values (101,1500,"2021-10-06",1,1);
insert into `order` values (103,30000,"2021-09-16",1,2);
insert into rating values(1,101,4);

select cus_gender,count(cus_gender) from customer,`order`
where  customer.cus_id=`order`.cus_id and `order`.ord_amount>=3000 group by cus_gender;


select * from customer;
select * from supplier where SUPP_ID in (select SUPP_ID 
from supplier_pricing GROUP BY SUPP_ID having count(SUPP_ID)>1);

select product.pro_id,product.pro_name from `order`
inner join supplier_pricing on supplier_pricing.pricing_id=`order`.pricing_id 
inner join product on product.pro_id=supplier_pricing.pro_id where `order`.ord_date>"2021-10-05";

select customer.cus_name,customer.cus_gender from customer where customer.cus_name like 'A%' or customer.cus_name like '%A';

DELIMITER //
CREATE PROCEDURE ratings()
begin
select supplier.supp_id, supplier.supp_name, avg(rating.rat_ratstars),
CASE
when avg(rating.rat_ratstars) >=5
then "excellent"
when avg(rating.rat_ratstars) <5 and avg(rating.rat_ratstars)>=4
then "good Service"
when avg(rating.rat_ratstars)<4 and avg(rating.rat_ratstars)>2
then "Average service"
else "poor service"
end as Type_of_Service from rating
inner join `order`
on `order`.ord_id=rating.ord_id
inner join supplier_pricing
on supplier_pricing.pricing_id= `order`.pricing_id
inner join supplier
on supplier.supp_id= supplier_pricing.supp_id
GROUP BY supplier.SUPP_ID
ORDER BY SUPP_ID;
end //

call ratings();


SELECT `order`.ord_id, product.pro_name
FROM `order`
JOIN supplier_pricing ON `order`.pricing_id= supplier_pricing.pricing_id 
JOIN product ON supplier_pricing.pro_id=product.pro_id
WHERE `order`.cus_id = 1;

select * from `order`;
