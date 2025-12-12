Show tables;

-- Making sure the tables are loaded properly

Select *
from appointments1;
Select *
from customers1;
Select *
from employees1;
Select *
from expenses1;
Select *
from services1;

-- Starting to annalize the appointments table
Create table appointments2
Select *
from appointments1;
 select *,
 row_number() over (partition by appointment_id,customer_id,employee_id,service_id,appointment_date,payment_method,quantity) as row1
 from appointments2;
 
 -- searching for duplicates
 CREATE TABLE `appointments3` (
  `appointment_id` double DEFAULT NULL,
  `customer_id` double DEFAULT NULL,
  `employee_id` text,
  `service_id` double DEFAULT NULL,
  `appointment_date` text,
  `payment_method` text,
  `quantity` double DEFAULT NULL,
  `row2` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 Insert into appointments3
 select *,
 row_number() over (partition by appointment_id,customer_id,employee_id,service_id,appointment_date,payment_method,quantity) as row1
 from appointments2;

  
select *
from appointments3;

 
 
 -- No duplicate rows  returned
 
  seLECT *
  FROM appointments3;
  
select appointment_id
from appointments3
where appointment_id=' ';

-- There is no missing value in the Id column thus means it will be our primary key
alter table appointments3
add primary key(appointment_id);
Update appointments3
set appointment_id=trim(appointment_id);
Alter table appointments3
modify appointment_id int;


Update appointments3
set customer_id=trim(customer_id);

select customer_id
from appointments3
where customer_id=' ';

Update appointments3
set employee_id=trim(employee_id);

Update appointments3
set service_id=trim(service_id);

-- Separating the appointment_date column into  two
-- first step is to add the two columns
Alter table appointments3
ADD  apointment_date varchar(20),
add appointment_time varchar(20);
Select *,
substring(appointment_date, 1, INSTR(appointment_date,' ') -1) as appointment_day,
substring(appointment_date, INSTR(appointment_date,' ') +1) as appointment_time
from appointments3;

Update appointments3
set apointment_date=substring(appointment_date, 1, INSTR(appointment_date,' ') -1),
appointment_time=substring(appointment_date, INSTR(appointment_date,' ') +1);

alter table appointments3
drop column appointment_date;

alter table appointments3
drop column row2;

select count(distinct(payment_method)) -- shows we have 6 different paying methods
from appointments3;

select distinct(payment_method),payment_method
from appointments3
group by payment_method;

Update appointments3
set payment_method=trim(payment_method);

-- Making sure the first letter is in capital
Select payment_method,
CONCAT(
Upper(substring(payment_method,1,1)),
Lower(substring(payment_method,2))
) As payment_method2
from appointments3;

Update appointments3
set payment_method=CONCAT(
Upper(substring(payment_method,1,1)),
Lower(substring(payment_method,2)));

Update appointments3
set quantity=trim(quantity);

Alter table appointments3
modify quantity int;

select apointment_date
from appointments3;

select apointment_date,
str_to_date(apointment_date,'%Y-%m-%d') as arranged_date
from appointments3;

Update appointments3
set apointment_date=str_to_date(apointment_date,'%Y-%m-%d');

Update appointments3
set apointment_date=trim(apointment_date);

Update appointments3
set appointment_time=trim(appointment_time);

 seLECT *
  FROM appointments3;
  
  -- Moving on to the customers table
  select *
  from customers1;
  
  create table customers2
  select *
  from customers1;
  
  select *
  from customers2;
  
  select *,
  row_number() over(partition by customer_id,`name`,phone_number,gender,join_date) as row_num
from customers2;

select *
from customers2
order by customer_id;

With duplicate_cte as (
 select *,
  row_number() over(partition by customer_id,`name`,phone_number,gender,join_date) as row_num
from customers2
)
select *
from duplicate_cte
where row_num>1;
  
  -- no duplicates detected
  
  Update customers2
  set customer_id=trim(customer_id);
 -- Customer Id cant be our primary key due to the presence of blanks
 
 Update customers2
 set name=trim(name);
 select *
 from customers2;
 select *,
 replace(name, 'Mr.', '')As new_name
 from customers2;
 Update customers2
 set name=replace(name, 'Mr.', '');
  Update customers2
 set name=replace(name, 'MD.', '');
  Update customers2
 set phone_number=trim(phone_number);
  Update customers2
 set gender=trim(gender); 
 Select distinct(gender)
 from customers2;
   Update customers2
 set join_date=trim(join_date); 
 select join_date,
 str_to_date(join_date,'%Y-%m-%d')
 from customers2;
 Update customers2
 set join_date= str_to_date(join_date,'%Y-%m-%d');
 
 
 -- Moving on to the third employees table
 select *
 from employees1;
 
Create table employees2
 select *
 from employees1;
 
 select *,
 row_number() over(partition by employee_id,employee_name,role,hire_date) as row_num
 from employees2;
  with duplicate_cte as (
 select *,
 row_number() over(partition by employee_id,employee_name,role,hire_date) as row_num
 from employees2
 )
 select * 
 from duplicate_cte
 where row_num>1;
 
 -- no duplicates in the table
 Update employees2
 set employee_id =trim(employee_id);
 -- Again the employee Id cant be used as the primary column because it has blank values
 
 Update employees2
 set employee_name=trim(employee_name);
 select *
 from employees2;
  
  Select distinct(employee_name)
  from employees2;
 Select distinct(role)
  from employees2;
Update employees2
 set role =trim(role);
Update employees2
 set hire_date =trim(hire_date);
 
 Select *,
 str_to_date(hire_date,'%Y-%m-%d')
 from employees2;
Update employees2
 set hire_date = str_to_date(hire_date,'%Y-%m-%d');

-- moving on to the expenses table

select *
from expenses1;
 Create table expenses2
 select *
from expenses1;

Select *,
row_number() over(Partition by expense_id,expense_type,amount,expense_date) as row_num
from expenses2;

with duplicate_cte as (
Select *,
row_number() over(Partition by expense_id,expense_type,amount,expense_date) as row_num
from expenses2
)
select *
from duplicate_cte
where row_num>1;

-- zero duplicates found
Update expenses2
 set expense_id =trim(expense_id);
 Update expenses2
 set expense_type =trim(expense_type);
 Select distinct(expense_type)
  from expenses2;
alter table expenses2
add primary key(expense_id);
select *
from expenses2;
 Update expenses2
 set amount =trim(amount);
Update expenses2
 set expense_date = str_to_date(expense_date,'%Y-%m-%d');
 Update expenses2
 set expense_date =trim(expense_date);
 
 -- Moving to the final services table
 select *
from services1;
Create table services2
 select *
from services1;
 select *
from services2;
Select *,
row_number() over(Partition by service_id,service_name,category,price) as row_num
from services2;

with duplicate_cte as (
Select *,
row_number() over(Partition by service_id,service_name,category,price) as row_num
from services2
)
select *
from duplicate_cte
where row_num>1;
 -- zero duplicates
  Update services2
 set service_id =trim(service_id);
 alter table services2
add primary key(service_id);
 alter table services2
modify service_id int;
Update services2
 set service_name =trim(service_name);
 Select distinct(service_name)
  from services2;
 Update services2
 set category =trim(category);
  Select distinct(category)
  from services2;
  Update services2
 set price =trim(price);
 
 -- Starting the EDA process
 select *
 from appointments3;
 
 -- first thing is to know what service each customer got using an inner join
 SELECT A.customer_id,B.appointment_id,A.name,B.service_id,c.service_name
 from appointments3 AS B
 Inner join customers2 as A on B.customer_id=A.customer_id
 Inner join services2 as C on B.service_id=C.service_id;
 -- Customers whose Id is in the appointments table but not in the customers table
 select distinct(customer_id)
 from appointments3
 where customer_id not in(select customer_id
 from customers2)
 ;
-- We have 5 customers whose ids have not been registered in the customers table
  select *
 from customers2;
  Alter table customers2
  modify phone_number varchar(25);
   Alter table customers2
  modify customer_id varchar(25);
  select floor(customer_id) as integer_value
  from customers2
  where customer_id not in('');
  Update customers2
 set customer_id =floor(customer_id)
 where customer_id not in(''); -- removing the decimal places in our customer_id table
  
 Insert into customers2(customer_id,name,phone_number,gender,join_date) -- inserting the customer_ids found in the appointments table but not in the customers table
 values(7,'unknowncustomer','null','null','null'),
 (17,'unknowncustomer','null','null','null'),
 (25,'unknowncustomer','null','null','null'),
 (38,'unknowncustomer','null','null','null'),
 (59,'unknowncustomer','null','null','null');
 
select *
from appointments3
where customer_id not in(select customer_id-- all customers have been recorded in the customers table from the appointments table
from customers2);

-- looking at who perfoms what services from the employees table and the appointments table

select *
from employees2;
select *
from appointments3;
select *
from services2;
alter table appointments3
modify service_id int;
alter table services2
modify service_id int;

select distinct(employee_id)
from appointments3
where employee_id not in(select employee_id-- 
from employees2);
  
-- we have four employee ids that have been seen on the appointments table but not on the employees table. We have to include these employees in the employees table
 Insert into employees2(employee_id,employee_name,role,hire_date) 
 values(2.0,'unknownemployee','null','unknown'),
 (6.0,'unknownemployee','null','unknown'),
 (7.0,'unknownemployee','null','unknown'),
 (10.0,'unknownemployee','null','unknown');
 
 -- we have to see what each employee does done by using the inner join on the the three tables
 
 SELECT A.appointment_id,C.service_id,C.service_name,B.employee_id,B.employee_name -- SHOWS THE SERVICES OFFERED IN THE APPOINTMENTS
 FROM appointments3 AS A
 JOIN services2 AS C ON A.service_id=C.service_id
 JOIN employees2 AS B on A.employee_id=B.employee_id;
 -- Showing the work done but with unknown employees
  SELECT A.appointment_id,C.service_id,C.service_name,B.employee_id,B.employee_name -- SHOWS THE SERVICES OFFERED IN THE APPOINTMENTS
 FROM appointments3 AS A
 JOIN services2 AS C ON A.service_id=C.service_id
 JOIN employees2 AS B on A.employee_id=B.employee_id
 where employee_name='unknownemployee';
 -- Finding out the work done to each customer by which employee
 select A.customer_id,A.name,C.service_id,C.service_name,B.payment_method,D.employee_name
 From appointments3 as B
 JOIN employees2 AS D ON B.employee_id=D.employee_id
 JOIN customers2 AS A ON B.customer_id=A.customer_id
 JOIN services2 AS C ON B.service_id=C.service_id;
 
 select *
from employees2;
select *
from appointments3;
select *
from services2;
 