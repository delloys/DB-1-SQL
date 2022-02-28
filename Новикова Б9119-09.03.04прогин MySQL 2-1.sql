use staff;

#1.Вывести всех сотрудников, у которых дата трудоустройства меньше максимальной даты
select * from emp
	where emp_date < (select max(emp_date) 
						from emp);
    
#2.Вывести всех программистов, которые трудоустроились позже 2020.01.01
select * 
from (select * 
		from emp
		where upper(emp_posit) like '%ПРОГРАММИСТ%') m
where m.emp_date>'2020/01/01';

#3. Вывести список сотрудников, которые начали работать в первой половине жизни компании
select emp_id, emp_date,emp_name
from emp
group by emp_id
having emp_date<(select avg(emp_date) from emp);

#4.Вывести количество квалификаций каждого сотрудника
select dep_id,emp_name,
	(select count(*) 
    from empquali q 
    where q.emp_id = e.emp_id) cnt
from emp e;

#5.Повысить всех программистов, которые начали работать в период с 2011.01.01 по 2014.01.01
SET SQL_SAFE_UPDATES = 0;
update emp
	set emp_posit = 'Старший программист'
    where emp_posit ='Программист' and emp_date = ( select * 
														from (
                                                        select emp_date from emp
                                                        where emp_date between '2011/01/01' and '2014/01/01') m) ;
SET SQL_SAFE_UPDATES = 1;    

#6.Выводит список сотрудников с их должностью,отделом и квалификацией
drop view emp_depname;
create view emp_depname
	as select DISTINCT e.emp_name,e.emp_posit,d.dep_name,q.quali_name
	from emp e, dep d,empquali q
	where emp_date<(select max(emp_date) 
						from emp) and e.dep_id=d.dep_id
                        and e.emp_id=q.emp_id;
	
select * from emp_depname;

#7. ПРедставление всех программистов, трудоустроившихся раньше 2020.01.01
drop view emp_view2;
create view emp_view2
	as select * 
	from (select * 
		from emp
		where upper(emp_posit) like '%ПРОГРАММИСТ%') m
	where m.emp_date<'2020/01/01';
    
select * from emp_view2;

#8.Создание новой таблицы отделов
drop table dep_new;
create table if not exists dep_new (
	dep_id int,
    dep_name varchar(100),
    primary key (dep_id)
);

#9.Заполнение новой таблицы отделов
insert into dep_new
	values (240,'Отдел тестирования'),
			(10,'Отдел разработки');
            
#10.Представление на объединение (UNION) таблиц Отделы и Новые отделы
select dep_id,dep_name from dep
union
select dep_id,dep_name from dep_new;