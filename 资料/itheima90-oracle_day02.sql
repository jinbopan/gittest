------------------------使用system/orcl登录操作----------------------
--给scott用户授权dba权限，为了我们方便操作后面的知识点
grant dba to scott;
------------------------使用scott/tiger登录操作-----------------------
--1.视图
-------介绍，用于封装一条sql查询语句，给不同的用户查看（用户A只能看emp表中3个字段，用户B只能看5个字段）
--语法一（非只读）：create or replace view 视图名称 as sql查询语句;
create or replace view view_empA as
select empno,ename,job from emp;

--查询视图
select * from view_empA;
--更新操作
update view_empA set ename='SMITH-1' where empno=7369;--修改视图数据是成功
--查询视图是否修改了？答：已修改
select * from view_empA;
--原始表是否修改了？答：已修改
select * from emp;
--修改视图数据，怎么会导致原始表也修改了呢？答：因为视图时虚拟表，视图的数据都指向原始表，所以修改视图等于修改原始表
--视图是为了给用户查询看的数据，能不能让用户修改数据?答：不能，所以需要创建只读视图

-- 语法二（只读）：create or replace view 视图名称 as sql查询语句 with read only;
create or replace view view_empB as
select empno,ename,job from emp with read only;

-- 查询
select * from view_empB;
--更新操作（达到不允许修改视图数据）
update view_empB set ename='SMITH-2' where empno=7369;--修改视图数据是失败的
--创建其他用户，提供视图查询权限给到用户
create user testA identified by orcl 
default tablespace itheima90;
--给用户授权，授予普通用户权限，resource和connect角色权限
grant resource,connect to testA;
--授权当前用户里面的视图查询权限给testA
grant select on view_empB to testA;
----------------------使用testA/orcl用户登录操作
select * from view_empB;--这种方式是查询自己的表
select * from scott.view_empB;--可以查询，因为有权限
select * from scott.view_empA;--不能查询，没有权限

--视图的好处：可以避免敏感数据的泄露。


---------------------使用scott/tiger用户登录操作---------------------------
--2.索引
------介绍：索引用于提高查询效率的。
------例子：新华字典，存储很多汉字，我们查找汉字通过目录中按照拼音或偏旁部首查询，可以很快查到
------------想要的汉字，这里目录中拼音或偏旁部首就是数据库的索引，可以提高查询汉字的效率。但是
------------如果字典添加或删除汉字，需要重新维护目录，所以使用索引需要资源和时间的维护成本。
------查询数据方式：
-------------方式一：从数据表中第一条一直查找表中最后一条，这种方式是慢的。
-------------方式二：使用索引查询，需要对查询where后面的条件字段建立索引。
------疑问：为什么建立索引查询速度会快？答：由于索引使用的B树结构算法决定。
------索引的类型（2种）；一个表可以有多个索引
-------------单列索引，就是建立一个字段的索引，语法
create index 索引名字 on 表名(字段);
-------------复合索引，就是建立多个个字段的索引
create index 索引名字 on 表名(字段1,字段2,...);
------创建索引
create index index_emp_ename on emp(ename);
create index index_emp_ename on emp(ename,job);

------测试索引查询的性能，测试前题要求表中有大量数据
---创建一个表
create table t_test(
       id number(10) primary key,
       name varchar2(100)
);
---序列
create sequence seq_test_id;
---插入5000000数据
begin
  for i in 1..5000000
    loop
      insert into t_test values(seq_test_id.nextval,'测试数据'||i);
    end loop;
    commit;
end;

--查询记录数
select count(*) from  t_test;
--使用普通查询，查看性能
select * from t_test where name='测试数据4123456'  --2.11秒

--创建索引
create index index_test_name on t_test(name);
--使用索引查询，查看性能
select * from t_test where name='测试数据4123457'  --0.031秒





--索引的使用原则
-------1.表中的数据有大量数据，才会建索引
-------2.经常查询的字段，才会建索引，由于数据库维护索引需要一定成本所以不可以随便建。
-------3.对于频繁改变或更新数据的表，不建议创建索引，否则维护成本很大。
-------4.查询的时候写where条件优先将索引查询写在前面。
-------5.每个表的主键默认就是索引


--3.PL/SQL（Procedure Language/SQL）---------------------------------------------
------3.1介绍：就是在sql语句中加入过程，过程式的编程
------pl/sql过程结构语法：
[declare] 
   声明部分(变量 常量 引用变量 记录型变量 游标)  --如果没有声明就可以省略declare
begin
   逻辑处理
end;
-------创建一个过程sql
declare
   -- java中类定义成员，private String v_name='SCOTT';
   v_name varchar2(100):='SCOTT';            --定义变量并初始化,赋值用:=,判断使用=
   v_gender constant varchar2(2):='男';      --定义常量并初始化
   v_ename emp.ename%type;                   --引用变量，类型与emp表中ename字段类型一样
   v_row emp%rowtype;                        --记录型变量，就是可以存储指定表中一条记录的变量
begin
   --修改变量
   v_name:='SCOTT2';
   --打印变量
   dbms_output.put_line('变量='||v_name);
   --修改常量
   --v_gender:='女'; 常量不可以修改
   --打印常量
   dbms_output.put_line('常量='||v_gender);
   --给引用变量赋值
   select ename into v_ename  from emp where empno=7369;
   --打印引用变量
    dbms_output.put_line('引用变量='||v_ename);
   --给记录型变量赋值
   select * into v_row from emp where ename='SCOTT';
   --打印SCOTT用户编号，名称，职位
   dbms_output.put_line('记录型变量,'||v_row.empno||'---'||v_row.ename||'---'||v_row.job);
  
end;


---3.2 游标
-------介绍：可以存储多条记录数据，是一个数据集,类似一个java的jdbc中ResultSet
-------创建游标语法
cursor 游标名字 is sql查询语句;
-------使用游标语法
open 游标名称;  --打开游标
     loop      --遍历数据集
       fetch 游标名称 into 记录型变量;
       exit when 游标名称%notfound;
       逻辑处理每条记录里面的数据
     end loop
close 游标名称 --关闭游标
-------要求：查找20号部门所有员工,将其姓名,薪水,job打印出来
declare 
  cursor cursor_emps is select * from emp where deptno=20;--定义游标
  v_row emp%rowtype;    --记录型变量，用于接收每一条员工数据
begin
  open cursor_emps;
       loop
         fetch cursor_emps into v_row;
         exit when cursor_emps%notfound;
         dbms_output.put_line('游标数据,'||v_row.ename||'---'||v_row.sal||'---'||v_row.job);
       end loop;
  close cursor_emps;
end;


---3.3 if分支结构
----介绍，用于分支条件判断
------语法1：
if 条件 then
  逻辑处理
end if;
------语法2：
if 条件 then
  逻辑处理
else
  逻辑处理
end if;
------语法3：
if 条件 then
  逻辑处理
elsif 条件 then
  逻辑处理
else
  逻辑处理
end if;

-- 案例 18岁以下输出未成年人，18~60输出成年人，60岁以上输出老年人
declare
   v_age number(8):=&age;  --&,用户动态弹出输入框接收输入的数据
begin
   if v_age<18 then
     dbms_output.put_line('未成年人');
   elsif v_age>=18 and v_age<=60 then
     dbms_output.put_line('成年人');
   else
     dbms_output.put_line('老年人');
   end if;
end;

---3.4循环结构
-----语法1：无条件循环
loop
  exit when 条件;--退出循环条件
  逻辑处理
end loop;
-----案例：输出1~100
declare
    v_i number(8):=1;
begin
  loop
    exit when v_i>100;--退出循环条件
    dbms_output.put_line(v_i);
    --v_i++; oracle没有++,只有如下方式
    v_i:=v_i+1;
  end loop;
end;

-----语法2:while有条件循环
while 条件
  loop
    逻辑处理
  end loop;
-----案例：输出1~200
declare
    v_i number(8):=1;
begin
  while v_i<201
  loop
    dbms_output.put_line(v_i);
    --v_i++; oracle没有++,只有如下方式
    v_i:=v_i+1;
  end loop;
end;

-----语法2:for有限次数循环
for 循环变量 in 起始值..结束值
  loop
    逻辑处理
  end loop;
-----案例：输出1~200

begin
  for v_i in 1..300
  loop
    dbms_output.put_line(v_i);
  end loop;
end;

--为什么学习pl-sql？
---3.5 plsql综合案例：按员工的工种涨工资,总裁 1000 元，经理涨 800 元其，他人员涨 400 元。
declare
   cursor cursor_emps is select * from emp;--定义游标存储所有员工
   v_row emp%rowtype;                      --定义记录型变量接收员工表每条记录
   v_sal number(8);
begin
  open cursor_emps; --打开游标
       loop
         fetch cursor_emps into v_row;
         exit when cursor_emps%notfound;
         --判断不同职位确定要涨的工资值
         if v_row.job='PRESIDENT' THEN
           v_sal:=1000;
         elsif v_row.job='MANAGER' then
           v_sal:=800;
         else
           v_sal:=400;
         end if;
         --涨工资
         update emp set sal=sal+v_sal where empno = v_row.empno;
       end loop;
       commit; --提交
  close cursor_emps; --关闭游标
end;

  

--4、存储过程--------------------------------------
----4.1 介绍，就是对上面一堆plssql编程语句起一个名字就可以调用，就是存储过程
----4.2 好处，存储过程是预编译的（意味着每次直接执行，不需要编译），重用性高。
----4.3 创建语法
-----------in，输入参数，作用将参数传入到存储过程里面使用,in可以不写，默认就是输入参数
-----------out,输出参数，存储过程运行完成后输出的数据，类似于方法返回值。
-----------注意：输入或输出参数定义数据类型不写长度
create or replace procedure 存储过程名字(变量名称N [in]/out 数据类型)
is | as   --类似declare,用于声明变量，但是不可以省略，使用is或者as
   声明部分
begin
   逻辑处理
end;

----4.4 存储过程案例1(输入参数)：打印指定员工的年薪
create or replace procedure proce_emp_yearsal(v_empno number)
is
 v_yearsal number(10,2);
begin
  select sal*12+nvl(emp.comm,0) into v_yearsal from emp where empno=v_empno;
  --打印
  dbms_output.put_line(v_empno||'年薪：'||v_yearsal);
end;

--调用存储过程有2种方式
-- 方式一：
call proce_emp_yearsal(7369);
-- 方式二
begin
  proce_emp_yearsal(7839);
end;

-----4.5 存储过程案例2（输出参数）：获取指定员工的年薪,之后再打印出来
create or replace procedure proce_emp_yearsal(v_empno number,v_yearsal out number)
is
begin
  select sal*12+nvl(emp.comm,0) into v_yearsal from emp where empno=v_empno;
end;

--调用,有输出参数调用只能如下格式：
declare
  v_yearsal number(10,2);
begin
  proce_emp_yearsal(7839,v_yearsal);
  --打印
  dbms_output.put_line(v_yearsal);
end;

------5 存储函数
-------介绍：oracle系统提供单行函数和多行函数，我们可以自己定义函数就是存储函数
-------定义语法
create or replace function 存储函数名字(变量名称N [in]/out 数据类型)
return 数据类型 ---定义返回的数据类型，函数有返回值
is | as   --类似declare,用于声明变量，但是不可以省略，使用is或者as
   声明部分
begin
   逻辑处理
end;

------案例：存储函数：获取指定员工的年薪
create or replace function func_emp_yearsal(v_empno number)
return number
is
   v_yearsal number(10,2);
begin
  select sal*12+nvl(emp.comm,0) into v_yearsal from emp where empno=v_empno;
  return v_yearsal;
end;

--调用函数
select empno,ename,sal,func_emp_yearsal(empno) from emp;
--函数特点：sql语句直接调用

----函数与存储过程的企业实践：
------1.函数直接返回，一般应用在sql语句直接查询调用
------2.以后java代码操作数据库，一般执行sql语句或存储过程，一般不会单独调用函数；

----6.触发器-----------------------------------
----介绍：当数据库执行insert/update/delete等dml语句时就可以触发执行的命令就是触发器
----语法
create or replace trigger 触发器名字
before | after  --在执行dml语句之前触发还是之后触发
insert | update | delete [of 列名] --具体执行dml语句那个的时候触发，可以写多个使用or连接
on 表名  ---操作那个表的时候
[for each row ] --触发器的级别
[declare]

begin
  
end;

------触发器案例1：当插入emp表数据的时候,打印"有新入职人员加入"
create or replace trigger trigger_emp_insert
after --dml语句操作之后触发
insert --是insert语句时触发
on emp --操作emp时触发
begin
  dbms_output.put_line('有新入职人员加入');
end;

--执行emp表insert之后触发
insert into emp values(1111,'tom','CLERK',7902,to_date('1980/12/17','yyyy-MM-dd'),1000,null,20);


----触发器案例2：要求当前系统日期为'2018-09-07',不允许插入数据,给出报错
create or replace trigger trigger_emp_insert
before --dml语句操作之前触发
insert
on emp
begin
  if to_char(sysdate,'yyyy-MM-dd')='2018-09-07' then
    --发生错误，让sql语句不能执行（类似抛出异常，结束插入语句）
    --raise_application_error(状态码,错误消息);
    -- 状态码,oracle给开发人员预留-20001~-29999
    raise_application_error(-20001,'非工作时间，不允许插入数据');
  end if;
end;

--执行emp表insert之前触发
insert into emp values(22222,'tom2','CLERK',7902,to_date('1980/12/17','yyyy-MM-dd'),1000,null,20);

-----触发器案例3：应用场景,修改了员工的薪水就要去将修改数据备份到一个单独表中
--新建一个表，用于备份数据
create table t_sal_log(
       id number(8) primary key,
       empno number(8),     --记录调整薪水的员工编号
       sal1 number(10,2),   --调整前薪水
       sal2 number(10,2),   --跳转后的薪水
       updateTime  date
       
);

-- 序列
create sequence seq_sal_log_id;

--创建触发器
create or replace trigger trigger_emp_sal_update
after  --在执行dml语句之后触发
update of sal --具体执行dml语句那个的时候触发，可以写多个使用or连接
on emp  ---操作那个表的时候
for each row --触发器的级别(行级触发器和语句级触发器，没有这个就是语句级，有这个就是行级，只要是用了:new和:old就必须使用行级)
--[declare]
begin
  --使用伪记录
  --:new,dml语句操作之后的当前记录
  --:old,dml语句操作之前的当前记录
  --插入备份表
  insert into t_sal_log values(seq_sal_log_id.nextval,:new.empno,:old.sal,:new.sal,sysdate);
end;

update emp set sal=1400 where empno=7369;


select * from t_sal_log;










