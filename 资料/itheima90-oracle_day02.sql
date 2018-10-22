------------------------ʹ��system/orcl��¼����----------------------
--��scott�û���ȨdbaȨ�ޣ�Ϊ�����Ƿ�����������֪ʶ��
grant dba to scott;
------------------------ʹ��scott/tiger��¼����-----------------------
--1.��ͼ
-------���ܣ����ڷ�װһ��sql��ѯ��䣬����ͬ���û��鿴���û�Aֻ�ܿ�emp����3���ֶΣ��û�Bֻ�ܿ�5���ֶΣ�
--�﷨һ����ֻ������create or replace view ��ͼ���� as sql��ѯ���;
create or replace view view_empA as
select empno,ename,job from emp;

--��ѯ��ͼ
select * from view_empA;
--���²���
update view_empA set ename='SMITH-1' where empno=7369;--�޸���ͼ�����ǳɹ�
--��ѯ��ͼ�Ƿ��޸��ˣ������޸�
select * from view_empA;
--ԭʼ���Ƿ��޸��ˣ������޸�
select * from emp;
--�޸���ͼ���ݣ���ô�ᵼ��ԭʼ��Ҳ�޸����أ�����Ϊ��ͼʱ�������ͼ�����ݶ�ָ��ԭʼ�������޸���ͼ�����޸�ԭʼ��
--��ͼ��Ϊ�˸��û���ѯ�������ݣ��ܲ������û��޸�����?�𣺲��ܣ�������Ҫ����ֻ����ͼ

-- �﷨����ֻ������create or replace view ��ͼ���� as sql��ѯ��� with read only;
create or replace view view_empB as
select empno,ename,job from emp with read only;

-- ��ѯ
select * from view_empB;
--���²������ﵽ�������޸���ͼ���ݣ�
update view_empB set ename='SMITH-2' where empno=7369;--�޸���ͼ������ʧ�ܵ�
--���������û����ṩ��ͼ��ѯȨ�޸����û�
create user testA identified by orcl 
default tablespace itheima90;
--���û���Ȩ��������ͨ�û�Ȩ�ޣ�resource��connect��ɫȨ��
grant resource,connect to testA;
--��Ȩ��ǰ�û��������ͼ��ѯȨ�޸�testA
grant select on view_empB to testA;
----------------------ʹ��testA/orcl�û���¼����
select * from view_empB;--���ַ�ʽ�ǲ�ѯ�Լ��ı�
select * from scott.view_empB;--���Բ�ѯ����Ϊ��Ȩ��
select * from scott.view_empA;--���ܲ�ѯ��û��Ȩ��

--��ͼ�ĺô������Ա����������ݵ�й¶��


---------------------ʹ��scott/tiger�û���¼����---------------------------
--2.����
------���ܣ�����������߲�ѯЧ�ʵġ�
------���ӣ��»��ֵ䣬�洢�຺ܶ�֣����ǲ��Һ���ͨ��Ŀ¼�а���ƴ����ƫ�Բ��ײ�ѯ�����Ժܿ�鵽
------------��Ҫ�ĺ��֣�����Ŀ¼��ƴ����ƫ�Բ��׾������ݿ��������������߲�ѯ���ֵ�Ч�ʡ�����
------------����ֵ���ӻ�ɾ�����֣���Ҫ����ά��Ŀ¼������ʹ��������Ҫ��Դ��ʱ���ά���ɱ���
------��ѯ���ݷ�ʽ��
-------------��ʽһ�������ݱ��е�һ��һֱ���ұ������һ�������ַ�ʽ�����ġ�
-------------��ʽ����ʹ��������ѯ����Ҫ�Բ�ѯwhere����������ֶν���������
------���ʣ�Ϊʲô����������ѯ�ٶȻ�죿����������ʹ�õ�B���ṹ�㷨������
------���������ͣ�2�֣���һ��������ж������
-------------�������������ǽ���һ���ֶε��������﷨
create index �������� on ����(�ֶ�);
-------------�������������ǽ���������ֶε�����
create index �������� on ����(�ֶ�1,�ֶ�2,...);
------��������
create index index_emp_ename on emp(ename);
create index index_emp_ename on emp(ename,job);

------����������ѯ�����ܣ�����ǰ��Ҫ������д�������
---����һ����
create table t_test(
       id number(10) primary key,
       name varchar2(100)
);
---����
create sequence seq_test_id;
---����5000000����
begin
  for i in 1..5000000
    loop
      insert into t_test values(seq_test_id.nextval,'��������'||i);
    end loop;
    commit;
end;

--��ѯ��¼��
select count(*) from  t_test;
--ʹ����ͨ��ѯ���鿴����
select * from t_test where name='��������4123456'  --2.11��

--��������
create index index_test_name on t_test(name);
--ʹ��������ѯ���鿴����
select * from t_test where name='��������4123457'  --0.031��





--������ʹ��ԭ��
-------1.���е������д������ݣ��ŻὨ����
-------2.������ѯ���ֶΣ��ŻὨ�������������ݿ�ά��������Ҫһ���ɱ����Բ�������㽨��
-------3.����Ƶ���ı��������ݵı������鴴������������ά���ɱ��ܴ�
-------4.��ѯ��ʱ��дwhere�������Ƚ�������ѯд��ǰ�档
-------5.ÿ���������Ĭ�Ͼ�������


--3.PL/SQL��Procedure Language/SQL��---------------------------------------------
------3.1���ܣ�������sql����м�����̣�����ʽ�ı��
------pl/sql���̽ṹ�﷨��
[declare] 
   ��������(���� ���� ���ñ��� ��¼�ͱ��� �α�)  --���û�������Ϳ���ʡ��declare
begin
   �߼�����
end;
-------����һ������sql
declare
   -- java���ඨ���Ա��private String v_name='SCOTT';
   v_name varchar2(100):='SCOTT';            --�����������ʼ��,��ֵ��:=,�ж�ʹ��=
   v_gender constant varchar2(2):='��';      --���峣������ʼ��
   v_ename emp.ename%type;                   --���ñ�����������emp����ename�ֶ�����һ��
   v_row emp%rowtype;                        --��¼�ͱ��������ǿ��Դ洢ָ������һ����¼�ı���
begin
   --�޸ı���
   v_name:='SCOTT2';
   --��ӡ����
   dbms_output.put_line('����='||v_name);
   --�޸ĳ���
   --v_gender:='Ů'; �����������޸�
   --��ӡ����
   dbms_output.put_line('����='||v_gender);
   --�����ñ�����ֵ
   select ename into v_ename  from emp where empno=7369;
   --��ӡ���ñ���
    dbms_output.put_line('���ñ���='||v_ename);
   --����¼�ͱ�����ֵ
   select * into v_row from emp where ename='SCOTT';
   --��ӡSCOTT�û���ţ����ƣ�ְλ
   dbms_output.put_line('��¼�ͱ���,'||v_row.empno||'---'||v_row.ename||'---'||v_row.job);
  
end;


---3.2 �α�
-------���ܣ����Դ洢������¼���ݣ���һ�����ݼ�,����һ��java��jdbc��ResultSet
-------�����α��﷨
cursor �α����� is sql��ѯ���;
-------ʹ���α��﷨
open �α�����;  --���α�
     loop      --�������ݼ�
       fetch �α����� into ��¼�ͱ���;
       exit when �α�����%notfound;
       �߼�����ÿ����¼���������
     end loop
close �α����� --�ر��α�
-------Ҫ�󣺲���20�Ų�������Ա��,��������,нˮ,job��ӡ����
declare 
  cursor cursor_emps is select * from emp where deptno=20;--�����α�
  v_row emp%rowtype;    --��¼�ͱ��������ڽ���ÿһ��Ա������
begin
  open cursor_emps;
       loop
         fetch cursor_emps into v_row;
         exit when cursor_emps%notfound;
         dbms_output.put_line('�α�����,'||v_row.ename||'---'||v_row.sal||'---'||v_row.job);
       end loop;
  close cursor_emps;
end;


---3.3 if��֧�ṹ
----���ܣ����ڷ�֧�����ж�
------�﷨1��
if ���� then
  �߼�����
end if;
------�﷨2��
if ���� then
  �߼�����
else
  �߼�����
end if;
------�﷨3��
if ���� then
  �߼�����
elsif ���� then
  �߼�����
else
  �߼�����
end if;

-- ���� 18���������δ�����ˣ�18~60��������ˣ�60���������������
declare
   v_age number(8):=&age;  --&,�û���̬���������������������
begin
   if v_age<18 then
     dbms_output.put_line('δ������');
   elsif v_age>=18 and v_age<=60 then
     dbms_output.put_line('������');
   else
     dbms_output.put_line('������');
   end if;
end;

---3.4ѭ���ṹ
-----�﷨1��������ѭ��
loop
  exit when ����;--�˳�ѭ������
  �߼�����
end loop;
-----���������1~100
declare
    v_i number(8):=1;
begin
  loop
    exit when v_i>100;--�˳�ѭ������
    dbms_output.put_line(v_i);
    --v_i++; oracleû��++,ֻ�����·�ʽ
    v_i:=v_i+1;
  end loop;
end;

-----�﷨2:while������ѭ��
while ����
  loop
    �߼�����
  end loop;
-----���������1~200
declare
    v_i number(8):=1;
begin
  while v_i<201
  loop
    dbms_output.put_line(v_i);
    --v_i++; oracleû��++,ֻ�����·�ʽ
    v_i:=v_i+1;
  end loop;
end;

-----�﷨2:for���޴���ѭ��
for ѭ������ in ��ʼֵ..����ֵ
  loop
    �߼�����
  end loop;
-----���������1~200

begin
  for v_i in 1..300
  loop
    dbms_output.put_line(v_i);
  end loop;
end;

--Ϊʲôѧϰpl-sql��
---3.5 plsql�ۺϰ�������Ա���Ĺ����ǹ���,�ܲ� 1000 Ԫ�������� 800 Ԫ�䣬����Ա�� 400 Ԫ��
declare
   cursor cursor_emps is select * from emp;--�����α�洢����Ա��
   v_row emp%rowtype;                      --�����¼�ͱ�������Ա����ÿ����¼
   v_sal number(8);
begin
  open cursor_emps; --���α�
       loop
         fetch cursor_emps into v_row;
         exit when cursor_emps%notfound;
         --�жϲ�ְͬλȷ��Ҫ�ǵĹ���ֵ
         if v_row.job='PRESIDENT' THEN
           v_sal:=1000;
         elsif v_row.job='MANAGER' then
           v_sal:=800;
         else
           v_sal:=400;
         end if;
         --�ǹ���
         update emp set sal=sal+v_sal where empno = v_row.empno;
       end loop;
       commit; --�ύ
  close cursor_emps; --�ر��α�
end;

  

--4���洢����--------------------------------------
----4.1 ���ܣ����Ƕ�����һ��plssql��������һ�����־Ϳ��Ե��ã����Ǵ洢����
----4.2 �ô����洢������Ԥ����ģ���ζ��ÿ��ֱ��ִ�У�����Ҫ���룩�������Ըߡ�
----4.3 �����﷨
-----------in��������������ý��������뵽�洢��������ʹ��,in���Բ�д��Ĭ�Ͼ����������
-----------out,����������洢����������ɺ���������ݣ������ڷ�������ֵ��
-----------ע�⣺�����������������������Ͳ�д����
create or replace procedure �洢��������(��������N [in]/out ��������)
is | as   --����declare,�����������������ǲ�����ʡ�ԣ�ʹ��is����as
   ��������
begin
   �߼�����
end;

----4.4 �洢���̰���1(�������)����ӡָ��Ա������н
create or replace procedure proce_emp_yearsal(v_empno number)
is
 v_yearsal number(10,2);
begin
  select sal*12+nvl(emp.comm,0) into v_yearsal from emp where empno=v_empno;
  --��ӡ
  dbms_output.put_line(v_empno||'��н��'||v_yearsal);
end;

--���ô洢������2�ַ�ʽ
-- ��ʽһ��
call proce_emp_yearsal(7369);
-- ��ʽ��
begin
  proce_emp_yearsal(7839);
end;

-----4.5 �洢���̰���2���������������ȡָ��Ա������н,֮���ٴ�ӡ����
create or replace procedure proce_emp_yearsal(v_empno number,v_yearsal out number)
is
begin
  select sal*12+nvl(emp.comm,0) into v_yearsal from emp where empno=v_empno;
end;

--����,�������������ֻ�����¸�ʽ��
declare
  v_yearsal number(10,2);
begin
  proce_emp_yearsal(7839,v_yearsal);
  --��ӡ
  dbms_output.put_line(v_yearsal);
end;

------5 �洢����
-------���ܣ�oracleϵͳ�ṩ���к����Ͷ��к��������ǿ����Լ����庯�����Ǵ洢����
-------�����﷨
create or replace function �洢��������(��������N [in]/out ��������)
return �������� ---���巵�ص��������ͣ������з���ֵ
is | as   --����declare,�����������������ǲ�����ʡ�ԣ�ʹ��is����as
   ��������
begin
   �߼�����
end;

------�������洢��������ȡָ��Ա������н
create or replace function func_emp_yearsal(v_empno number)
return number
is
   v_yearsal number(10,2);
begin
  select sal*12+nvl(emp.comm,0) into v_yearsal from emp where empno=v_empno;
  return v_yearsal;
end;

--���ú���
select empno,ename,sal,func_emp_yearsal(empno) from emp;
--�����ص㣺sql���ֱ�ӵ���

----������洢���̵���ҵʵ����
------1.����ֱ�ӷ��أ�һ��Ӧ����sql���ֱ�Ӳ�ѯ����
------2.�Ժ�java����������ݿ⣬һ��ִ��sql����洢���̣�һ�㲻�ᵥ�����ú�����

----6.������-----------------------------------
----���ܣ������ݿ�ִ��insert/update/delete��dml���ʱ�Ϳ��Դ���ִ�е�������Ǵ�����
----�﷨
create or replace trigger ����������
before | after  --��ִ��dml���֮ǰ��������֮�󴥷�
insert | update | delete [of ����] --����ִ��dml����Ǹ���ʱ�򴥷�������д���ʹ��or����
on ����  ---�����Ǹ����ʱ��
[for each row ] --�������ļ���
[declare]

begin
  
end;

------����������1��������emp�����ݵ�ʱ��,��ӡ"������ְ��Ա����"
create or replace trigger trigger_emp_insert
after --dml������֮�󴥷�
insert --��insert���ʱ����
on emp --����empʱ����
begin
  dbms_output.put_line('������ְ��Ա����');
end;

--ִ��emp��insert֮�󴥷�
insert into emp values(1111,'tom','CLERK',7902,to_date('1980/12/17','yyyy-MM-dd'),1000,null,20);


----����������2��Ҫ��ǰϵͳ����Ϊ'2018-09-07',�������������,��������
create or replace trigger trigger_emp_insert
before --dml������֮ǰ����
insert
on emp
begin
  if to_char(sysdate,'yyyy-MM-dd')='2018-09-07' then
    --����������sql��䲻��ִ�У������׳��쳣������������䣩
    --raise_application_error(״̬��,������Ϣ);
    -- ״̬��,oracle��������ԱԤ��-20001~-29999
    raise_application_error(-20001,'�ǹ���ʱ�䣬�������������');
  end if;
end;

--ִ��emp��insert֮ǰ����
insert into emp values(22222,'tom2','CLERK',7902,to_date('1980/12/17','yyyy-MM-dd'),1000,null,20);

-----����������3��Ӧ�ó���,�޸���Ա����нˮ��Ҫȥ���޸����ݱ��ݵ�һ����������
--�½�һ�������ڱ�������
create table t_sal_log(
       id number(8) primary key,
       empno number(8),     --��¼����нˮ��Ա�����
       sal1 number(10,2),   --����ǰнˮ
       sal2 number(10,2),   --��ת���нˮ
       updateTime  date
       
);

-- ����
create sequence seq_sal_log_id;

--����������
create or replace trigger trigger_emp_sal_update
after  --��ִ��dml���֮�󴥷�
update of sal --����ִ��dml����Ǹ���ʱ�򴥷�������д���ʹ��or����
on emp  ---�����Ǹ����ʱ��
for each row --�������ļ���(�м�����������伶��������û�����������伶������������м���ֻҪ������:new��:old�ͱ���ʹ���м�)
--[declare]
begin
  --ʹ��α��¼
  --:new,dml������֮��ĵ�ǰ��¼
  --:old,dml������֮ǰ�ĵ�ǰ��¼
  --���뱸�ݱ�
  insert into t_sal_log values(seq_sal_log_id.nextval,:new.empno,:old.sal,:new.sal,sysdate);
end;

update emp set sal=1400 where empno=7369;


select * from t_sal_log;










