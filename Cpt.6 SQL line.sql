use	mysql;
/* select * from membertbl 이 구문은 존재하지 않는다 -- 한칸 공백 띄우면 주석 
여러줄 주석은 위와 같이 묶는다. */

use shopdb; --  원하는 데이터 베이스 지정하는 구문
select * from membertbl; --  원하는 데이터를 가져와 주는 기본 구문 > 원하는 정보를 추출한다
-- 위 두 라인은 아래와 같이 하나의 라인으로 사용 가능하다 --
select * from employees.employees;
-- 주의사항: '데이터베이스이름.테이블이름'으로 select 문 사용시 실행은 되나 사용할 데이터베이스로 지정하는 것은 아님--

-- 실습1. DB, TABLE, 열의 이름이 확실하지 않을 때 조회하는 방법 --
show databases; -- 서버에 존재하는 db 확인 --
show table status; -- 데이터베이스 테이블 정보 조회 --
show tables; -- 테이블 이름만 조회 -- 

use employees;
desc employees; -- employees 테이블 열 확인, 앞에 employees 사용 위한 use 문 미사용하였더니 오류 발생 --

select first_name,gender from employees; -- 특정 데이터 조회 --
SELECT first_name 이름, gender 성별, hire_date `회사 입사일` FROM employees; -- 별칭(alias) 사용하여 표시 세 방법중 본 방법이 본인에게 편함--

-- 실습2. -- 
drop database if exists sqldb;
create database sqlDB;
