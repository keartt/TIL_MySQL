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
-- sqldb 만들기 --
use sqldb;
select* from usertbl where name='이승기'; -- 특정한 조건 부여하여 원하는 데이터만 조회 --

SELECT userID, Name 
	FROM userTbl 
    WHERE birthYear >= 1970 AND height >= 182;  -- 유저테이블에서 관계 연산자 속 만족하는 데이터 조회한 값 --
    
SELECT * 
	FROM userTbl 
    WHERE birthYear >= 1970 OR height >= 182; 
    
SELECT *
	FROM userTbl
    WHERE height >= 180 AND height <= 183;
    
    
SELECT *
	FROM userTbl
    WHERE height BETWEEN 180 AND 183;  -- 숫자 데이터에서만 가능, 연속적인 데이터 표시 가능-- 


 SELECT Name, addr
	FROM userTbl
    WHERE addr IN ('경남', '전남', '경북');  -- 이산적인 데이터값의 조건 -- 
    
    
SELECT name, height 
	FROM userTbl
    WHERE name LIKE '이%';  -- %(앞 문자 뒤에 뭐든 허용) 사용시 like 와 함께 사용필요 --
    
SELECT Name, height
	FROM userTbl
	WHERE name LIKE '_종신';  -- _는 앞에 한 글자만 허용 like 와 함께 사용 필요함 --
    
    
-- 서브쿼리  ⁃ 쿼리문 안에 또 쿼리문이 들어 있는 것, 결과가 둘 이상일 경우 에러 발생함 --


SELECT Name, height FROM userTbl
	WHERE height > (SELECT height FROM userTbl WHERE name='이승기'); -- 이승기의 키를 확인하고 그보다 큰 사람 조회 --
    
    -- 서브쿼리 리턴값이 하나 이상인 경우 오류 발생 >> ANY 구문을 사용해야 함 --
    
SELECT Name, height FROM userTbl      -- sub query return 173, 170
	WHERE height >= ANY (SELECT height FROM usertbl WHERE addr='경남'); 
    

-- 정확히 170, 173 인것만 리턴 '= ANY '는 IN 과 동일하다
SELECT Name, height FROM userTbl   
	WHERE height = ANY (SELECT height FROM usertbl WHERE addr='경남');
    
    

    



