show databases;
create database pract;
use pract;
create table students(sid int, sname char(20), age int, course char(20));
show tables;
insert into students values(1, 'kittu',23, 'datascience');
insert into students values(2, 'mittuh',45,'cienceSQL');
select * from students;
create table patients(pid int, pname varchar(20), dob date, toa datetime);
desc patients;
insert into patients values(1, 'kiu', '1917-07-21', '2024-07-07 23:17:59');
insert into patients values(2, 'iu', '1913-08-21', '2024-06-07 21:14:29');
select * from patients;
select dayname(dob) from patients;
select monthname(dob) from patients;

-- DDL 
-- alter
desc students;
alter table students add column marks int;
alter table students drop column age;
alter table students modify column sname varchar(30);
alter table students change column sid std_id int; 
alter table students rename to mystudents;
alter table mystudents add column class char(30) after std_id;
alter table students drop column class; 
desc mystudents;

-- drop
create table samp (sump int);
drop table samp;
-- rename
rename table mystudents to students;
alter table students drop column result;
desc students;

-- DML
insert into students values (4, 'lunduh',45);
insert into students (sid, sname,age,course) values(3, 'harr', 22,'sql'), (4,'mkico',21, 'analyst')
,(5, 'parr', 29,'bmql'),(6, 'suarr', 22,'english');
select * from students;
update students set sname = 'darr' where sid = 3;
select 1 is null;
select 1=null;
update students set age =13 where sname ='mittuh' and course = 'cienceSQL';
insert into students values (7,'bkl', 34,NULL);
insert into students values (8,'mkc', 26,NULL);
update students set sid = 7 where sname = 'bkl';
update students set course = 'SQL', age = 15 where sid = 5;
select * from students;
delete from students where sid = 5;

-- DQL
select * from myemp;
select * from myemp limit 100, 5;
select emp_id, first_name, last_name, salary from myemp;
select emp_id, first_name, last_name, salary, salary*0.2 as Bonus from myemp;
select emp_id, first_name, last_name, salary+ salary*0.2 as ToTal_sal from myemp;
select distinct dep_id, mgr_id from myemp;
select distinct dep_id from myemp order by DEP_ID desc;

-- OPERATORS
select * from myemp where first_name like "a%";
select * from myemp where first_name like 'a____';
select * from myemp where hire_date like "1987-08-09";
select * from myemp where salary between 5000 and 20000 order by salary;
select * from myemp where dep_id = 90 and salary > 10000;
select * from myemp where DEP_ID in(10,20,30);
select * from myemp;

select emp_id, first_name, last_name, job_id, case
when job_id = "ad_vp" then "viceprez"
when job_id like "%prog%" then "programmer"
else "Employ"
end as job_title from myemp;

-- COALSCE
select coalesce("hello", null, null,"world") as result;
select coalesce(null, null,1, null, 0) as result;

-- Aggregations and Groupby
select sum(salary) , avg(salary) from myemp;
select count(*) from myemp;
select count(*) from myemp where DEP_ID = 80;
select count(*) from myemp where salary >10000;
select dep_id , avg(salary) from myemp where DEP_ID in (10,20,30) group by DEP_ID;
select dep_id, round(avg(salary),2) as Avg_Sal from myemp group by dep_id order by dep_id;
select dep_id, count(*) from myemp group by dep_id order by count(*) desc;
select dep_id, count(*) from myemp where salary >10000 group by dep_id order by count(*) desc;

-- Constraints
create table student (sid int unique, sname varchar(30) not null, age int check (age>21),
course varchar(30) default "MYSQL", gender enum ("M", "F"));
desc student;
insert into student (sid,sname,age,gender) values(2, "syri",23,"M");
select * from student;

select * from authors;
select * from books;

select * from members;
select * from members inner join movies on members.movieid = movies.id;
select * from members join movies on id =movieid;
select * from members right join movies on id = movieid;
select * from meals;
select * from drinks;
select * from meals cross join drinks;
select mealname, meals.rate,drinks.rate from meals cross join drinks;
select mealname, drinkname,m.rate+d.rate as Total from meals as m cross join drinks as d;

select * from members left join movies on id = movieid union select * from members right join movies on id = movieid;
select first_name, last_name, title,category from members right join movies on id = movieid;
select ifnull(first_name,"-") as first_name,ifnull(last_name,"-") as last_name, title,category from members right join movies on id = movieid;
-- TCL
select * from students;
insert into students values(1,"mkc", 10, "SQL");
start transaction;
insert into students values(2,"abc", 20, "Land");
insert into students values(1,"mbac", 18, "SDA");
rollback;
start transaction;
insert into students values(2,"abc", 20, "Land");
insert into students values(1,"mbac", 18, "SDA");
commit;

-- View
create view author_id as select * from authors where authorid < 8;
select * from author_id;
drop view author_id;
create view author_id as select * from authors where authorid < 10 with check option;
insert into author_id values(30, 'samp');
create view dep50 as select * from myemp where dep_id = 50;
select * from dep50;
-- INDEX
select * from myemp where hire_date <'1996-12-01';
create index sample using btree on myemp(hire_date);
show indexes from myemp;
desc authors;
show indexes from authors;
create table working (sid int primary key, sname varchar(30) not null, working_hrs int);
create unique index hindx using btree on working (sname, working_hrs);
desc working;
insert into working values(1,"syre", 1345);

-- PROGRAMMING
-- Stored Procedure
call variable();
call proc_author(4);
call out_parameter(@avg_myemp);
select @avg_myemp;

select * from myemp;

-- triggers
select * from books;
select * from book_sales;
desc book_sales;
alter table books add column sales int default 0;
update books set sales = sales +3 where bookid = 5;
update books set sales = sales +6 where bookid = 5;
select * from book_sales;

create table emp (eid int, ename varchar(30),working_hrs int);
insert into emp values (1, "dyck", 32), (2, "puz",-45);
select * from emp;
insert into emp values (3,"ass", -67), (4, "azzs",-09);

-- Window function 
select emp_id, first_name, last_name, dep_id, avg(salary) over (partition by dep_id) as avg_salary from myemp;
select * from t;
select val, dense_rank() over (order by val desc) as rank1 from t;	

select * from trains;
select train_id, station, time , lead(time, 1) over (partition by train_id order by time) as next_station_time from trains;