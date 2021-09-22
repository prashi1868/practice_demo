create database SCDtypes
use SCDtypes



create table country_src
(country_id numeric(4) primary key,
country_nm varchar(20)
)
go


insert into country_src values(1,'India')
insert into country_src values(2,'Us')
insert into country_src values(3,'Uk')

create table state_src
(state_id numeric(4) primary key,
state_nm varchar(20),
country_id numeric(4) references Country_src(country_id)
)
go

insert into state_src values(101,'Karnataka',1)
insert into state_src values(102,'Mumbai',1)
insert into state_src values(103,'California',2)

create table city_src
(city_id numeric(4) primary key,
City_nm varchar(20),
state_id numeric(4) references state_src(state_id)
)
go

insert into city_src values(10,'Bangalore',101)
insert into city_src values(20,'Mysore',101)
insert into city_src values(30,'Hassan',101)

create table cust_src
(c_id numeric(4) primary key,
cname varchar(20),
addr varchar(20),
ph numeric(20),
dob date,
email varchar(20),
gender varchar(10),
m_status varchar(5),
city_id numeric(4) references city_src(city_id)
)
go

insert into cust_src values(1101,'Ajay','JPNagar',9856327548,'22-jan-11','ajay@gmail.com','M','UM',10);
insert into cust_src values(1102,'Amar','RRNagar',8896327548,'12-feb-11','amar@gmail.com','M','UM',10);
insert into cust_src values(1103,'Abhay','JayaNagar',9587327548,'09-mar-11','ab@gmail.com','F','MAR',10);
insert into cust_src values(1104,'Arun','RNagar',9587099548,'19-apr-11','aru@gmail.com','F','MAR',20);
insert into cust_src values(1105,'Anu','TNagar',9587376508,'09-sep-11','anu@gmail.com','M','UM',20);



create table cust_dim_scd2
(c_surr_dim_key int identity(100,1),
c_bkey numeric(4) references cust_src(c_id),
cname varchar(20),
addr varchar(20),
ph numeric(20),
dob date,
email varchar(20),
gender varchar(10),
m_status varchar(5),
city_nm varchar(20),
state_nm varchar(20),
country_nm varchar(20),
from_dt date,
end_dt date,
curr_flag char(1),
check(curr_flag in('Y','N')),
version int
)
go


--Write a stored procedure to populate the customer dimension,where new records should be populated
--in target and any change in these critical columns like addr,ph,m_status,city of source should be
--another record in Target. Also populate insert_dt,effective_dt,curr_flag and version.
alter procedure cust_dimension
as
begin
insert into cust_dim_scd2(c_bkey,cname,addr,ph,dob,email,gender,m_status,city_nm,state_nm,country_nm,from_dt,end_dt,curr_flag,version)
select cu.c_id,cu.cname,cu.addr,cu.ph,cu.dob,cu.email,cu.gender,cu.m_status,ci.city_nm,s.state_nm,co.country_nm,getdate() as from_dt,null,
'Y' as curr_flag,
1 as version

from country_src co inner join state_src s on co.country_id=s.country_id
inner join city_src ci on s.state_id=ci.state_id
inner join cust_src cu on ci.city_id=cu.city_id
where c_id not in(select c_bkey from cust_dim_scd2)

update cust_dim_scd2
set curr_flag='N',
end_dt=getdate()
from city_src ci,cust_src cu,cust_dim_scd2 cd
where cu.c_id=cd.c_bkey
and ci.city_id=cu.city_id
and cu.cname=cd.cname
and cd.curr_flag='Y'
and(cu.addr<>cd.addr
or cu.ph<>cd.ph
or cu.m_status<>cd.m_status
or ci.City_nm<>cd.city_nm)


insert into cust_dim_scd2(c_bkey,
 cname,addr,ph,dob,email,gender,m_status,city_nm,state_nm,country_nm,from_dt,end_dt,
 curr_flag, version)
select cu.c_id,cu.cname,cu.addr,cu.ph,cu.dob,cu.email, cu.gender,cu.m_status,ci.city_nm,s.state_nm,co.country_nm,
  getdate() as from_dt,
  null,
  'y' as curr_flag,
max(version)+1

from country_src co inner join state_src s on co.country_id=s.country_id
inner join city_src ci on s.state_id=ci.state_id
inner join cust_src cu on ci.city_id=cu.city_id inner join cust_dim_scd2 cd on cd.c_bkey=cu.c_id
where cu.cname=cd.cname
and(cd.addr<>cu.addr
or cd.ph<>cu.ph
or cd.m_status<>cu.m_status
or cd.city_nm<> ci.city_nm)
and  cd.%%physloc%% =(select max(%%physloc%%)
from cust_dim_scd2 )
group by cu.c_id,cu.cname,cu.addr,cu.ph,cu.dob,cu.email, cu.gender,cu.m_status,ci.city_nm,s.state_nm,co.country_nm
end

exec cust_dimension

select * from cust_src

select * from city_src
select * from country_src
select * from state_src
select *  from cust_dim_scd2
truncate table cust_dim_scd2


update cust_src
set m_status='um'
where cname='abhay'



update cust_src
set m_status='mar'
where cname='ajay'

update cust_src
set m_status='mar'
where cname='ajay'




select %%physloc%%,c_bkey
from cust_dim_scd2 c1
where %%physloc%% in(select min(%%physloc%%)
from cust_dim_scd2 c2
where c1.c_bkey=c2.c_bkey )
or %%physloc%% in(select max(%%physloc%%)
from cust_dim_scd2 c
where c1.c_bkey=c.c_bkey )
