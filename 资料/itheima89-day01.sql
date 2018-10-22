-----------------------使用sytem/orcl用户登录进行如下操作--------------

--使用oracle操作数据的步骤:
--     mysql操作数据第一步骤是创建数据库
--概念:oracle像mysql连接不同的数据库是通过连接不通的用户
--1.创建表空间(逻辑结构空间,存储数据)
create tablespace itheima89            --创建表空间
datafile 'c:\\itheima89.dbf' size 100m --指定映射的数据文件,并设置文件大小
autoextend on                          --自动扩展,以默认大小进行自动扩展
next 10m                               --空间不够,每次扩展10m
--创建用户,要指定用户数据存储在那个表空间上
create user itheima89                  --创建用户名
identified by itheima89              --设置用户的密码
default tablespace itheima89           --设置用户的数据存储的所属表空间
--给用户授权
-- 格式1:grant 权限1,权限2,... to 用户名
--            grant ALTER SYSTEM,AUDIT SYSTEM to itheima89
-- 格式2(推荐方式):grant 角色 to 用户名 
-- 角色,就是权限的集合,就是拥有多个权限
-- oracle系统默认有3个角色:
--                 dba,管理员角色,拥有所有权限,例如sys/system等都是dba角色用户
--                 resources,资源操作角色
--                 connect,连接oracle权限角色
--查看用户角色
SELECT * FROM USER_ROLE_PRIVS;
--查看当前用户权限：
select * from session_privs;
--给itheima89授予dba权限,方便我们操作
grant dba to itheima89;


-----------------------使用自己创建的用户itheima89/itheima89用户登录进行如下操作--------------
--使用用户登录操作sql
--创建表格式
create table 表名(
       字段名1 数据类型 [default value] [not null] [primary key],
       字段名2 数据类型 [default value] [not null],
       ...
);
-- oracle常见数据类型
/*
varchar	可变长度字符串, oracle不推荐使用,不确保任何版本的支持.所以就算代码写这个类型,oracle也会自动将其转换为varchar2
varchar2(n)	可变长度字符串，一个英文字符占一个字节，中文GBK占2个字节，中文utf-8占3个字节，oracle推荐使用,具有更好的版本兼容性。
            字符长度<=4000字节。
number	数值类型,NUMBER(n)表示一个整数,n代表整数的位数，长度是n，n有效范围1~38
	      NUMBER(m,n):表示一个小数，总长度(精度,小数点左右2边的总长度)是 m，小
        数是n(小数点后面的位数)，整数是m-n。
        N的有效范围，-84~127.
        123.9876存入Number(5,2)结果为：123.99
        12345.9876存入Number(5,-2)结果为：12300

date	表示日期类型
Long	可变长文本字符列，最大长度限制是2GB，用于不需要作字符串搜索的长串数据，如果要进行字符搜索就要用varchar2类型。 long是一种较老的数据类型，将来会逐渐被BLOB、CLOB等大的对象数据类型所取代
CLOB	大对象，表示大文本数据类型，可存 4G
BLOB	大对象，表示二进制数据，可存 4G,适合存储视频\文档等数据*/

-- 创建person表
create table person(
       pid number(10) primary key,
       name varchar2(200) not null,
       sex varchar2(2),
       birthday date
);
--插入测试数据(DML)
insert into person(pid,name) values(1,'张三');
insert into person values(2,'张三','男',to_date('2018-01-01','yyyy-MM-dd'));
-- 在oracle里面操作增删改语句,必须手动提交事务

------- 删表
-- 1.完全销毁表(DDL)
   drop table person;
-- 2.删除表里面的数据(DML)
   delete from person;



-- DDL修改表结构
-- 1.给person增加一个address列
alter table person add(address varchar2(200));
-- 2.修改address列数据类型为varchar2(100)
alter table person modify(address varchar2(100));
-- 3.修改address列名为address2
alter table person rename column address to address2;

-- DML
-- INSERT
insert into person values(3,'李四','男',to_date('2018-01-01','yyyy-MM-dd'),'');
-- update
update person set address2='广州'
-- delete
delete from person where pid=1;

--查看表
select * from person;

-----------------------使用用户scott/tiger用户登录进行如下操作---------
--部门表
select * from dept;
--员工表
select * from emp;
--薪水级别表
select * from salgrade;

------ 单行函数
--伪表dual,假表,是oracle为了给大家查一条数据时使用提供的虚拟表
-- mysql:select 'aaa',可以
-- oracle:select 'aaa',不可以,因为oracle的sql更加严谨,格式必须为select *|列 from 表
select 'aaa' from dual; 
--字符串函数
--upper('aaa'),转成大写
select upper('aaa') from dual;
--lower('AAA'),转成小写
select lower('AAA') FROM dual;
--replace(数据,'查找已有字符','替换后的字符'),替换字符串函数
select replace('aabbcc','bb','hello') from dual;
--数值函数
--格式:round(数据),四舍五入取整
--格式:round(数据,n),保留指定小数n位,四舍五入取整
select round(123.23) from dual;--123
select round(123.25,1) from dual;--123.3
--日期函数
--oracle系统关键字对象:sysdate,获取当前系统时间
--操作日系如下:
--日期-日期=数字(以天为单位)
--日期+数字=日期
--日期-数字=日期
select sysdate from dual;
select sysdate+1 from dual;
select sysdate-1 from dual;
--oracle给字段起别名
select 'aaa' as "测试" from dual;
select 'aaa' as 测试 from dual;
select 'aaa'  测试 from dual;
select 'aaa'  "测试" from dual;
--获取员工入职的天数,分析当前系统日期-入职日期
select emp.ename,emp.hiredate,sysdate-emp.hiredate 入职天数 from emp;
--获取员工入职的周数,分析(当前系统日期-入职日期)/7
select emp.ename,emp.hiredate,(sysdate-emp.hiredate)/7 入职周数 from emp;
--获取员工入职的月数
--months_between(日期1,日期2),就是日期1-日期2返回的相差的月数
select emp.ename,emp.hiredate,months_between(sysdate,emp.hiredate) 入职月数 from emp;
--获取员工入职的年数
--months_between(日期1,日期2)/12
select emp.ename,emp.hiredate,months_between(sysdate,emp.hiredate)/12 入职年数 from emp;


--转换函数
--日期转换为字符串,to_char(日期,'格式')
--格式:yyyy-MM-dd HH:mi:ss,oracle不区分大小写
-- hh,12进制的小时
-- hh24,24进制的小时
--fmyyyy-MM-dd HH:mi:ss,去掉补0数据
select emp.hiredate from emp;--1980/12/17
select to_char(emp.hiredate,'yyyy-MM-dd') from emp;--1981-02-22
select to_char(emp.hiredate,'fmyyyy-MM-dd') from emp;--1981-2-22
select to_char(emp.hiredate,'yyyy-MM-dd HH:mi:ss') from emp;
--字符串转换为日期,to_date(字符串,'格式')
select to_date('2018-01-01','yyyy-mm-dd') from dual;

--通用函数
--1.判空函数,nvl(数据,为空的时候返回的数据)
-- 统计每个员工年薪,月工资*12+年终奖
select emp.ename,emp.sal,emp.sal*12+nvl(emp.comm,0) 年薪 from emp;
--2.if-else判断函数decode函数,格式:
-- decode(数据,'aa','数据为aa的时候返回的值','bb','数据为bb的时候返回的值',...,'else之前条件都不符合返回的值')
-- 显示员工职位中文名字
select emp.ename,
       emp.job, 
       decode(emp.job,
              'CLERK','业务员',
              'SALESMAN','销售员',
              'MANAGER','经理',
              /*'ANALYST','分析师',*/
              'PRESIDENT','总裁',
              '其他'
       ) 中文职位
  from emp;
--3.case when then
--格式:   case 数据 
--             when 'aa' then '数据为aa的时候返回的值'
--             when 'bb' then '数据为bb的时候返回的值'
--        else 'else之前条件都不符合返回的值'
--        end
select emp.ename,
       emp.job, 
       case emp.job
         when 'CLERK' then '业务员'
         when 'SALESMAN' then '销售员'
         when 'MANAGER' then '经理'
         when 'PRESIDENT' then '总裁'
         else     '其他'
       end  中文职位
  from emp;

------ 多行函数(聚合函数,分组函数)
--count(*),max(字段),min(字段),avg(字段),sum(字段)
--范例：查询出所有员工记录数
select count(*) from emp;
--范例：查询出来员工最低工资
select min(emp.sal) from emp;
--范例：查询出员工的最高工资
select max(emp.sal) from emp;
--范例：查询出员工的平均工资
select avg(emp.sal) from emp;
--范例：查询出 20  号部门的员工的工资总和
select sum(emp.sal) from emp where emp.deptno=20;

-- 分组, group by
--范例：查询出每个部门的平均工资
select emp.deptno,avg(emp.sal) from emp group by emp.deptno;
--范例：查询每个部门的人数
select emp.deptno,count(*) from emp group by emp.deptno;
--分组常见错误说明
--select emp.deptno,emp.ename,avg(emp.sal) from emp group by emp.deptno;oracle会报错,mysql不会报错
--oracle分组注意
--       1.查询的字段在分组的时候要么是聚合函数,要么必须放在groupby后面进行分组
---sql语句执行关键字的顺序: from  where  group by select having(必须与groupby一起使用) orderby 
--范例：按部门分组，查询出部门名称和部门的员工数量
--员工表,部门表
select e.deptno,d.dname,count(*) from emp e,dept d where e.deptno=d.deptno group by e.deptno,d.dname

--范例：查询出部门人数大于 5 人的部门
select e.deptno, d.dname, count(*)
  from emp e, dept d
 where e.deptno = d.deptno
 group by e.deptno, d.dname
having count(*) > 5

--范例：查询出部门平均工资大于 2000 的部门
select e.deptno, d.dname, count(*)
  from emp e, dept d
 where e.deptno = d.deptno
 group by e.deptno, d.dname
having avg(e.sal) > 2000

---------------------------------------多表查询
--内连接
--多表查询
--范例：查询员工表和部门表
--emp,14条
--dept,4条
--14*4=56条,笛卡尔积.
select * from emp,dept order by ename;

--范例：查询出雇员的编号，姓名，部门的编号和名称，地址
select emp.empno,emp.ename,dept.deptno,dept.dname,dept.loc from emp,dept where emp.deptno=dept.deptno

--范例：查询出每个员工的上级领导
--(员工编号、员工姓名、员工部门编号、员工工资、领导编号、领导姓名、领导工资)
-- 自查询,自己连接自己
select e1.empno, e1.ename, e1.deptno, e1.sal, e2.empno, e2.ename, e2.sal
  from emp e1, emp e2
 where e1.mgr = e2.empno;

--范例: 在上一个例子的基础上查询该员工的部门名称
select e1.empno, e1.ename, e1.deptno, e1.sal,d1.dname, e2.empno, e2.ename, e2.sal
  from emp e1, emp e2,dept d1
 where e1.mgr = e2.empno and e1.deptno=d1.deptno;

--范例：在上一个例子的基础上查询出每个员工 工资等级和他的上级领导工资等级
select e1.empno, e1.ename, e1.deptno, e1.sal,d1.dname,s1.grade 员工工资级别, e2.empno, e2.ename, e2.sal,s2.grade 领导工资级别
  from emp e1, emp e2,dept d1,salgrade s1,salgrade s2
 where e1.mgr = e2.empno 
   and e1.deptno=d1.deptno
   and e1.sal between s1.losal and s1.hisal
   and e2.sal between s2.losal and s2.hisal;
   
   --select * from salgrade;
--外连接
--     左外连接(左连接)
--     右外连接(右连接)
--上面查询出13条数据,员工表14条数据,因为总裁没有上级领导所以总裁没有出来
--范例：查询出所有员工的上级领导(所有员工,就是14条数据全部显示出来)

-- 标准的左连接
select e1.empno, e1.ename, e1.deptno, e1.sal, e2.empno, e2.ename, e2.sal
  from emp e1 left join  emp e2 on e1.mgr = e2.empno;
-- oracle独有方式
--全量表,那个数据全出来,没有出来需要拉出来,使用(+)
select e1.empno, e1.ename, e1.deptno, e1.sal, e2.empno, e2.ename, e2.sal
  from emp e1, emp e2
 where e1.mgr = e2.empno(+);
--范例：查询出所有的部门下的员工，要求把没有员工的部门也展示出来
select * from dept,emp 
where dept.deptno=emp.deptno(+)
--课下将其上面转换为标准方式

---------------子查询
--1.查询比SCOTT工资高的员工
--select sal from emp where ename='SCOTT';--mysql不区分,oracle查询区分大小写.
--select * from emp where sal>3000;

select * from emp where sal>(select sal from emp where ename='SCOTT');

--查询工资最低的员工
 select * from emp where sal=(select min(sal) from emp);

--查询出和scott同部门并且同职位的员工
select * from emp 
where deptno=(select deptno from emp where ename='SCOTT')
  and job=(select job from emp where ename='SCOTT')
  and ename!='SCOTT'
--and ename<>'SCOTT'
--优化代码
select * from emp 
where (deptno,job)=(select deptno,job from emp where ename='SCOTT')
  and ename<>'SCOTT'
  --注意(deptno,job),必须有()
--查询每个部门的最低工资和最低工资的员工和部门名称
select * from (select emp.deptno,dept.dname,min(emp.sal) minsal from emp,dept
where emp.deptno=dept.deptno
group by emp.deptno,dept.dname ) t,emp
where t.minsal=emp.sal and t.deptno=emp.deptno

-- 子查询总结
-------子查询返回单行单列数据
-------子查询返回单行多列数据
-------子查询返回多行多列数据
-------子查询性能高,推荐使用子查询
--员工表,10w条,部门表1w条(1000000000条)(多表连接先产生笛卡尔积在去重复,所以慢)
select * from emp,dept where emp.deptno=dept.deptno and emp.deptno=20;--性能差
select * from (select * from emp where emp.dept=20),dept where emp.deptno=dept.deptno;--性能高




----------分页
--mysql利用limit进行分页,oracle没有limit
--oracle有伪列(虚拟列)
--     rowid,用于表中当前一条数据指向物理存储的地址编号
--     rownum,动态给每查询出来每行的数据增加一个序号,在执行select的时候动态加

--员工数据分页查询，每页显示5条，查询第一页、第二页数据
select emp.*,rownum from emp where rownum<6;
--第二页
--select emp.*,rownum from emp where rownum>5 and rownum<11; 不行,因为rownum只能使用小于号
select * from (select emp.*,rownum rowno from emp where  rownum<11) t where t.rowno>5
--按照工资由高到低查询第一页第二页
select t.*,rownum from (select emp.* from emp order by sal desc) t where rownum<6;
--第二页
select * from (
select t.*,rownum rowno from (select emp.* from emp order by sal desc) t where rownum<11
) t2 where t2.rowno>5;










