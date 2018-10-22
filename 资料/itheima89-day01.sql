-----------------------ʹ��sytem/orcl�û���¼�������²���--------------

--ʹ��oracle�������ݵĲ���:
--     mysql�������ݵ�һ�����Ǵ������ݿ�
--����:oracle��mysql���Ӳ�ͬ�����ݿ���ͨ�����Ӳ�ͨ���û�
--1.������ռ�(�߼��ṹ�ռ�,�洢����)
create tablespace itheima89            --������ռ�
datafile 'c:\\itheima89.dbf' size 100m --ָ��ӳ��������ļ�,�������ļ���С
autoextend on                          --�Զ���չ,��Ĭ�ϴ�С�����Զ���չ
next 10m                               --�ռ䲻��,ÿ����չ10m
--�����û�,Ҫָ���û����ݴ洢���Ǹ���ռ���
create user itheima89                  --�����û���
identified by itheima89              --�����û�������
default tablespace itheima89           --�����û������ݴ洢��������ռ�
--���û���Ȩ
-- ��ʽ1:grant Ȩ��1,Ȩ��2,... to �û���
--            grant ALTER SYSTEM,AUDIT SYSTEM to itheima89
-- ��ʽ2(�Ƽ���ʽ):grant ��ɫ to �û��� 
-- ��ɫ,����Ȩ�޵ļ���,����ӵ�ж��Ȩ��
-- oracleϵͳĬ����3����ɫ:
--                 dba,����Ա��ɫ,ӵ������Ȩ��,����sys/system�ȶ���dba��ɫ�û�
--                 resources,��Դ������ɫ
--                 connect,����oracleȨ�޽�ɫ
--�鿴�û���ɫ
SELECT * FROM USER_ROLE_PRIVS;
--�鿴��ǰ�û�Ȩ�ޣ�
select * from session_privs;
--��itheima89����dbaȨ��,�������ǲ���
grant dba to itheima89;


-----------------------ʹ���Լ��������û�itheima89/itheima89�û���¼�������²���--------------
--ʹ���û���¼����sql
--�������ʽ
create table ����(
       �ֶ���1 �������� [default value] [not null] [primary key],
       �ֶ���2 �������� [default value] [not null],
       ...
);
-- oracle������������
/*
varchar	�ɱ䳤���ַ���, oracle���Ƽ�ʹ��,��ȷ���κΰ汾��֧��.���Ծ������д�������,oracleҲ���Զ�����ת��Ϊvarchar2
varchar2(n)	�ɱ䳤���ַ�����һ��Ӣ���ַ�ռһ���ֽڣ�����GBKռ2���ֽڣ�����utf-8ռ3���ֽڣ�oracle�Ƽ�ʹ��,���и��õİ汾�����ԡ�
            �ַ�����<=4000�ֽڡ�
number	��ֵ����,NUMBER(n)��ʾһ������,n����������λ����������n��n��Ч��Χ1~38
	      NUMBER(m,n):��ʾһ��С�����ܳ���(����,С��������2�ߵ��ܳ���)�� m��С
        ����n(С��������λ��)��������m-n��
        N����Ч��Χ��-84~127.
        123.9876����Number(5,2)���Ϊ��123.99
        12345.9876����Number(5,-2)���Ϊ��12300

date	��ʾ��������
Long	�ɱ䳤�ı��ַ��У���󳤶�������2GB�����ڲ���Ҫ���ַ��������ĳ������ݣ����Ҫ�����ַ�������Ҫ��varchar2���͡� long��һ�ֽ��ϵ��������ͣ��������𽥱�BLOB��CLOB�ȴ�Ķ�������������ȡ��
CLOB	����󣬱�ʾ���ı��������ͣ��ɴ� 4G
BLOB	����󣬱�ʾ���������ݣ��ɴ� 4G,�ʺϴ洢��Ƶ\�ĵ�������*/

-- ����person��
create table person(
       pid number(10) primary key,
       name varchar2(200) not null,
       sex varchar2(2),
       birthday date
);
--�����������(DML)
insert into person(pid,name) values(1,'����');
insert into person values(2,'����','��',to_date('2018-01-01','yyyy-MM-dd'));
-- ��oracle���������ɾ�����,�����ֶ��ύ����

------- ɾ��
-- 1.��ȫ���ٱ�(DDL)
   drop table person;
-- 2.ɾ�������������(DML)
   delete from person;



-- DDL�޸ı�ṹ
-- 1.��person����һ��address��
alter table person add(address varchar2(200));
-- 2.�޸�address����������Ϊvarchar2(100)
alter table person modify(address varchar2(100));
-- 3.�޸�address����Ϊaddress2
alter table person rename column address to address2;

-- DML
-- INSERT
insert into person values(3,'����','��',to_date('2018-01-01','yyyy-MM-dd'),'');
-- update
update person set address2='����'
-- delete
delete from person where pid=1;

--�鿴��
select * from person;

-----------------------ʹ���û�scott/tiger�û���¼�������²���---------
--���ű�
select * from dept;
--Ա����
select * from emp;
--нˮ�����
select * from salgrade;

------ ���к���
--α��dual,�ٱ�,��oracleΪ�˸���Ҳ�һ������ʱʹ���ṩ�������
-- mysql:select 'aaa',����
-- oracle:select 'aaa',������,��Ϊoracle��sql�����Ͻ�,��ʽ����Ϊselect *|�� from ��
select 'aaa' from dual; 
--�ַ�������
--upper('aaa'),ת�ɴ�д
select upper('aaa') from dual;
--lower('AAA'),ת��Сд
select lower('AAA') FROM dual;
--replace(����,'���������ַ�','�滻����ַ�'),�滻�ַ�������
select replace('aabbcc','bb','hello') from dual;
--��ֵ����
--��ʽ:round(����),��������ȡ��
--��ʽ:round(����,n),����ָ��С��nλ,��������ȡ��
select round(123.23) from dual;--123
select round(123.25,1) from dual;--123.3
--���ں���
--oracleϵͳ�ؼ��ֶ���:sysdate,��ȡ��ǰϵͳʱ��
--������ϵ����:
--����-����=����(����Ϊ��λ)
--����+����=����
--����-����=����
select sysdate from dual;
select sysdate+1 from dual;
select sysdate-1 from dual;
--oracle���ֶ������
select 'aaa' as "����" from dual;
select 'aaa' as ���� from dual;
select 'aaa'  ���� from dual;
select 'aaa'  "����" from dual;
--��ȡԱ����ְ������,������ǰϵͳ����-��ְ����
select emp.ename,emp.hiredate,sysdate-emp.hiredate ��ְ���� from emp;
--��ȡԱ����ְ������,����(��ǰϵͳ����-��ְ����)/7
select emp.ename,emp.hiredate,(sysdate-emp.hiredate)/7 ��ְ���� from emp;
--��ȡԱ����ְ������
--months_between(����1,����2),��������1-����2���ص���������
select emp.ename,emp.hiredate,months_between(sysdate,emp.hiredate) ��ְ���� from emp;
--��ȡԱ����ְ������
--months_between(����1,����2)/12
select emp.ename,emp.hiredate,months_between(sysdate,emp.hiredate)/12 ��ְ���� from emp;


--ת������
--����ת��Ϊ�ַ���,to_char(����,'��ʽ')
--��ʽ:yyyy-MM-dd HH:mi:ss,oracle�����ִ�Сд
-- hh,12���Ƶ�Сʱ
-- hh24,24���Ƶ�Сʱ
--fmyyyy-MM-dd HH:mi:ss,ȥ����0����
select emp.hiredate from emp;--1980/12/17
select to_char(emp.hiredate,'yyyy-MM-dd') from emp;--1981-02-22
select to_char(emp.hiredate,'fmyyyy-MM-dd') from emp;--1981-2-22
select to_char(emp.hiredate,'yyyy-MM-dd HH:mi:ss') from emp;
--�ַ���ת��Ϊ����,to_date(�ַ���,'��ʽ')
select to_date('2018-01-01','yyyy-mm-dd') from dual;

--ͨ�ú���
--1.�пպ���,nvl(����,Ϊ�յ�ʱ�򷵻ص�����)
-- ͳ��ÿ��Ա����н,�¹���*12+���ս�
select emp.ename,emp.sal,emp.sal*12+nvl(emp.comm,0) ��н from emp;
--2.if-else�жϺ���decode����,��ʽ:
-- decode(����,'aa','����Ϊaa��ʱ�򷵻ص�ֵ','bb','����Ϊbb��ʱ�򷵻ص�ֵ',...,'else֮ǰ�����������Ϸ��ص�ֵ')
-- ��ʾԱ��ְλ��������
select emp.ename,
       emp.job, 
       decode(emp.job,
              'CLERK','ҵ��Ա',
              'SALESMAN','����Ա',
              'MANAGER','����',
              /*'ANALYST','����ʦ',*/
              'PRESIDENT','�ܲ�',
              '����'
       ) ����ְλ
  from emp;
--3.case when then
--��ʽ:   case ���� 
--             when 'aa' then '����Ϊaa��ʱ�򷵻ص�ֵ'
--             when 'bb' then '����Ϊbb��ʱ�򷵻ص�ֵ'
--        else 'else֮ǰ�����������Ϸ��ص�ֵ'
--        end
select emp.ename,
       emp.job, 
       case emp.job
         when 'CLERK' then 'ҵ��Ա'
         when 'SALESMAN' then '����Ա'
         when 'MANAGER' then '����'
         when 'PRESIDENT' then '�ܲ�'
         else     '����'
       end  ����ְλ
  from emp;

------ ���к���(�ۺϺ���,���麯��)
--count(*),max(�ֶ�),min(�ֶ�),avg(�ֶ�),sum(�ֶ�)
--��������ѯ������Ա����¼��
select count(*) from emp;
--��������ѯ����Ա����͹���
select min(emp.sal) from emp;
--��������ѯ��Ա������߹���
select max(emp.sal) from emp;
--��������ѯ��Ա����ƽ������
select avg(emp.sal) from emp;
--��������ѯ�� 20  �Ų��ŵ�Ա���Ĺ����ܺ�
select sum(emp.sal) from emp where emp.deptno=20;

-- ����, group by
--��������ѯ��ÿ�����ŵ�ƽ������
select emp.deptno,avg(emp.sal) from emp group by emp.deptno;
--��������ѯÿ�����ŵ�����
select emp.deptno,count(*) from emp group by emp.deptno;
--���鳣������˵��
--select emp.deptno,emp.ename,avg(emp.sal) from emp group by emp.deptno;oracle�ᱨ��,mysql���ᱨ��
--oracle����ע��
--       1.��ѯ���ֶ��ڷ����ʱ��Ҫô�ǾۺϺ���,Ҫô�������groupby������з���
---sql���ִ�йؼ��ֵ�˳��: from  where  group by select having(������groupbyһ��ʹ��) orderby 
--�����������ŷ��飬��ѯ���������ƺͲ��ŵ�Ա������
--Ա����,���ű�
select e.deptno,d.dname,count(*) from emp e,dept d where e.deptno=d.deptno group by e.deptno,d.dname

--��������ѯ�������������� 5 �˵Ĳ���
select e.deptno, d.dname, count(*)
  from emp e, dept d
 where e.deptno = d.deptno
 group by e.deptno, d.dname
having count(*) > 5

--��������ѯ������ƽ�����ʴ��� 2000 �Ĳ���
select e.deptno, d.dname, count(*)
  from emp e, dept d
 where e.deptno = d.deptno
 group by e.deptno, d.dname
having avg(e.sal) > 2000

---------------------------------------����ѯ
--������
--����ѯ
--��������ѯԱ����Ͳ��ű�
--emp,14��
--dept,4��
--14*4=56��,�ѿ�����.
select * from emp,dept order by ename;

--��������ѯ����Ա�ı�ţ����������ŵı�ź����ƣ���ַ
select emp.empno,emp.ename,dept.deptno,dept.dname,dept.loc from emp,dept where emp.deptno=dept.deptno

--��������ѯ��ÿ��Ա�����ϼ��쵼
--(Ա����š�Ա��������Ա�����ű�š�Ա�����ʡ��쵼��š��쵼�������쵼����)
-- �Բ�ѯ,�Լ������Լ�
select e1.empno, e1.ename, e1.deptno, e1.sal, e2.empno, e2.ename, e2.sal
  from emp e1, emp e2
 where e1.mgr = e2.empno;

--����: ����һ�����ӵĻ����ϲ�ѯ��Ա���Ĳ�������
select e1.empno, e1.ename, e1.deptno, e1.sal,d1.dname, e2.empno, e2.ename, e2.sal
  from emp e1, emp e2,dept d1
 where e1.mgr = e2.empno and e1.deptno=d1.deptno;

--����������һ�����ӵĻ����ϲ�ѯ��ÿ��Ա�� ���ʵȼ��������ϼ��쵼���ʵȼ�
select e1.empno, e1.ename, e1.deptno, e1.sal,d1.dname,s1.grade Ա�����ʼ���, e2.empno, e2.ename, e2.sal,s2.grade �쵼���ʼ���
  from emp e1, emp e2,dept d1,salgrade s1,salgrade s2
 where e1.mgr = e2.empno 
   and e1.deptno=d1.deptno
   and e1.sal between s1.losal and s1.hisal
   and e2.sal between s2.losal and s2.hisal;
   
   --select * from salgrade;
--������
--     ��������(������)
--     ��������(������)
--�����ѯ��13������,Ա����14������,��Ϊ�ܲ�û���ϼ��쵼�����ܲ�û�г���
--��������ѯ������Ա�����ϼ��쵼(����Ա��,����14������ȫ����ʾ����)

-- ��׼��������
select e1.empno, e1.ename, e1.deptno, e1.sal, e2.empno, e2.ename, e2.sal
  from emp e1 left join  emp e2 on e1.mgr = e2.empno;
-- oracle���з�ʽ
--ȫ����,�Ǹ�����ȫ����,û�г�����Ҫ������,ʹ��(+)
select e1.empno, e1.ename, e1.deptno, e1.sal, e2.empno, e2.ename, e2.sal
  from emp e1, emp e2
 where e1.mgr = e2.empno(+);
--��������ѯ�����еĲ����µ�Ա����Ҫ���û��Ա���Ĳ���Ҳչʾ����
select * from dept,emp 
where dept.deptno=emp.deptno(+)
--���½�������ת��Ϊ��׼��ʽ

---------------�Ӳ�ѯ
--1.��ѯ��SCOTT���ʸߵ�Ա��
--select sal from emp where ename='SCOTT';--mysql������,oracle��ѯ���ִ�Сд.
--select * from emp where sal>3000;

select * from emp where sal>(select sal from emp where ename='SCOTT');

--��ѯ������͵�Ա��
 select * from emp where sal=(select min(sal) from emp);

--��ѯ����scottͬ���Ų���ְͬλ��Ա��
select * from emp 
where deptno=(select deptno from emp where ename='SCOTT')
  and job=(select job from emp where ename='SCOTT')
  and ename!='SCOTT'
--and ename<>'SCOTT'
--�Ż�����
select * from emp 
where (deptno,job)=(select deptno,job from emp where ename='SCOTT')
  and ename<>'SCOTT'
  --ע��(deptno,job),������()
--��ѯÿ�����ŵ���͹��ʺ���͹��ʵ�Ա���Ͳ�������
select * from (select emp.deptno,dept.dname,min(emp.sal) minsal from emp,dept
where emp.deptno=dept.deptno
group by emp.deptno,dept.dname ) t,emp
where t.minsal=emp.sal and t.deptno=emp.deptno

-- �Ӳ�ѯ�ܽ�
-------�Ӳ�ѯ���ص��е�������
-------�Ӳ�ѯ���ص��ж�������
-------�Ӳ�ѯ���ض��ж�������
-------�Ӳ�ѯ���ܸ�,�Ƽ�ʹ���Ӳ�ѯ
--Ա����,10w��,���ű�1w��(1000000000��)(��������Ȳ����ѿ�������ȥ�ظ�,������)
select * from emp,dept where emp.deptno=dept.deptno and emp.deptno=20;--���ܲ�
select * from (select * from emp where emp.dept=20),dept where emp.deptno=dept.deptno;--���ܸ�




----------��ҳ
--mysql����limit���з�ҳ,oracleû��limit
--oracle��α��(������)
--     rowid,���ڱ��е�ǰһ������ָ������洢�ĵ�ַ���
--     rownum,��̬��ÿ��ѯ����ÿ�е���������һ�����,��ִ��select��ʱ��̬��

--Ա�����ݷ�ҳ��ѯ��ÿҳ��ʾ5������ѯ��һҳ���ڶ�ҳ����
select emp.*,rownum from emp where rownum<6;
--�ڶ�ҳ
--select emp.*,rownum from emp where rownum>5 and rownum<11; ����,��Ϊrownumֻ��ʹ��С�ں�
select * from (select emp.*,rownum rowno from emp where  rownum<11) t where t.rowno>5
--���չ����ɸߵ��Ͳ�ѯ��һҳ�ڶ�ҳ
select t.*,rownum from (select emp.* from emp order by sal desc) t where rownum<6;
--�ڶ�ҳ
select * from (
select t.*,rownum rowno from (select emp.* from emp order by sal desc) t where rownum<11
) t2 where t2.rowno>5;










