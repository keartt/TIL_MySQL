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
    
/* 원하는 순서대로 정렬하여 출력 : ORDER BY
⁃ 결과물에 대해 영향을 미치지는 않고 출력되는 순서를 조절하는 구문 ⁃ 기본적으로 오름차순 (ASCENDING) 정렬
⁃ 내림차순(DESCENDING)으로 정렬하려면 열 이름 뒤에 DESC */

SELECT Name, mDate FROM userTbl ORDER BY mDate DESC;  -- 내림차순 정렬 / 열 이름 뒤에 desc 

SELECT Name, height FROM userTbl ORDER BY height ASC, name ASC;  -- 키가 같을 경우 혼합하여 구문 사용 가능 

/* 중복된 것은 하나만 남기는 DISTINCT
	중복된 것을 골라서 세기 어려울 때 사용, 테이블의 크기가 클수록 효율적
	중복된 것은 1개씩만 보여주면서 출력 */
    
SELECT addr FROM userTbl ORDER BY addr; --  ASC

SELECT DISTINCT addr FROM userTbl; -- 중복된 항목이 1개로 나타난다.

/*출력하는 개수를 제한하는 LIMIT
	일부를 보기 위해 여러 건의 데이터를 출력하는 부담 줄임
	상위의 N개만 출력하는 ‘LIMIT N’ 구문 사용
	서버의 처리량을 많이 사용해 서버의 전반적인 성능을 나쁘게 하는 악성 쿼리문 개선할 때 사용 */
    
USE employees;
SELECT emp_no, hire_date FROM employees
	ORDER BY hire_date ASC; 			-- limit 없이 출력할 경우 : 처리량이 너무 많다.
    
USE employees;
SELECT emp_no, hire_date FROM employees
	ORDER BY hire_date ASC, emp_no ASC		-- order by hire date 기준으로 오름차순, 동일할경우 emp_no 기준 내림차순
    LIMIT 10; 								-- 0번째 부터 10개 출력 (0은 생략 가능)
    
SELECT emp_no, hire_date FROM employees
	ORDER BY hire_date DESC
    LIMIT 5;  								-- limit 5 > 5개까지만 출력됨
    
    
SELECT emp_no, hire_date FROM employees
	ORDER BY hire_date ASC, emp_no ASC
    LIMIT 0, 5;  							-- 0시작 5개

SELECT emp_no, hire_date FROM employees
	ORDER BY hire_date ASC, emp_no ASC
    LIMIT 2, 6;  							-- 5시작 5개

SELECT emp_no, hire_date FROM employees
	ORDER BY hire_date ASC, emp_no ASC
    LIMIT 3, 5;  							-- 3시작 5개
    
/* 테이블을 복사하는 CREATE TABLE … SELECT
	CREATE TABLE 새로운테이블 (SELECT 복사할열 FROM 기존테이블)
	지정된 일부 열만 테이블로 복사하는 것도 가능 / PK나 FK 같은 제약 조건은 복사되지 않음 */
    
USE sqlDB;
CREATE TABLE buyTbl2 (SELECT * FROM buyTbl);	-- schemas refresh 시 복사본 확인됨
SELECT * FROM buyTbl;
SELECT * FROM buyTbl2;


CREATE TABLE buyTbl3 (SELECT userID, prodName FROM buyTbl);

SELECT * FROM buyTbl;			-- 복사 전 원본
SELECT * FROM buyTbl3;			-- 복사 후 userID 와 prodName 만 복사된 것 확인됨

/*GROUP BY 및 HAVING 그리고 집계 함수
	GROUP BY :  그룹으로 묶어주는 역할 /  집계 함수(Aggregate Function)와 함께 사용
	읽기 좋게 하기 위해 별칭(Alias) AS 사용 */
    

USE sqlDB;
SELECT userID, SUM(amount) FROM buyTbl GROUP BY userID; 		-- 각 사용자 별로 구매한 개수를 합쳐 출력

SELECT userID AS '사용자 아이디', SUM(amount) AS '총 구매 개수'
	FROM buyTbl GROUP BY userID;								-- AS 이용하여 보기 쉽게 표현
    
SELECT * FROM buyTbl;
SELECT userID AS '사용자 아이디', SUM(price*amount) AS '총 구매액'
	FROM buyTbl GROUP BY userID;								-- 총 사용금액

-- AVG, MIN, MAX, COUNT, COUNT(DISTINCT), STDEV, VAR_SAMP 와 같은 함수들이 주로 같이 조합된다.


USE sqlDB;
SELECT AVG(amount) AS '평균 구매 개수' FROM buyTbl;
SELECT userID, AVG(amount) AS '평균 구매 개수' FROM buyTbl GROUP BY userID; 	-- 평균


SELECT Name, height FROM userTbl;

SELECT Name, MAX(height), MIN(height) FROM userTbl; -- 오류발생 / 실행은 되나 MAX와 MIN 의 이름이 하나로 나타남
SELECT Name, MAX(height), MIN(height) FROM userTbl GROUP BY Name; -- 그룹으로 오류 해소


SELECT Name, height
	FROM userTbl
    WHERE height = (SELECT MAX(height) FROM userTbl)
		OR height = (SELECT MIN(height) FROM userTbl);		-- 서브쿼리 활용, 제약사항 명확하기 표시
        
SELECT * FROM userTbl;
SELECT COUNT(*) FROM userTbl;   							-- 전체 회원수인 10 리턴
SELECT COUNT(mobile1) AS '휴대폰이 있는 사용자' FROM userTbl;



/*Having 절
	WHERE와 비슷한 개념으로 조건 제한,  집계 함수에 대해서 조건 제한하는 편리한 개념
	HAVING절은 꼭 GROUP BY절 다음에 나와야 함 ! 순서에 유의 */
    
    SELECT * FROM buyTbl;
SELECT userID AS '사용자 아이디', SUM(price*amount) AS '총 구매액'
	FROM buyTbl 
    GROUP BY userID;
    
        SELECT * FROM buyTbl;
SELECT userID AS '사용자 아이디', SUM(price*amount) AS '총 구매액'
	FROM buyTbl 					
    GROUP BY userID							-- SELECT * FROM buyTbL 은 WHERE 절에 사용이 불가
    HAVING SUM(price*amount) > 1000			-- HAVING 사용
    ORDER BY SUM(price*amount);  			-- 오름차순 (디폴트) 정렬 까지 추가해봄
    
/* ROLLUP for 소합계, 총합계
총합 또는 중간합계가 필요할 경우 사용
GROUP BY절과 함께 WITH ROLLUP문 사용 => 그룹별 중간합계 */

SELECT num, groupName, SUM(price*amount) AS '비용'  
	FROM buyTbl
    GROUP BY groupName, num
    WITH ROLLUP; 				 -- GroupName에 대해서 중간합계, num에 대해서도 중간합계 

SELECT groupName, SUM(price*amount) AS '비용'  
	FROM buyTbl
    GROUP BY groupName
    WITH ROLLUP;  				 -- GroupName에 대해서만 중간 합계 
    
    
/* 데이터의 삽입: INSERT
	테이블 이름 다음에 나오는 열 생략 가능
	생략할 경우에 VALUE 다음에 나오는 값들의 순서 및 개수가 테이블이 정의된 열 순서 및 개수와 동일해야 함 */
    
USE sqlDB;
    
CREATE TABLE testTbl1 (id int, userName char(3), age int);			-- 복사 테이블 만들기

INSERT INTO testTbl1 VALUES (1, '홍길동', 25);    					-- 열 생략 시, 순서 지켜야 함
INSERT INTO testTbl1(id, userName) VALUES (2, '설현');				-- 지정열 항목 데이터만 삽입
INSERT INTO testTbl1(userName, age, id) VALUES('초아', 26, 3);		-- 열 포함 시, 순서 바껴도 됨

SELECT * FROM testTbl1;												-- 확인
    

/* 자동으로 증가하는 Auto_Increment 
	INSERT에서는 해당 열이 없다고 생각하고 입력 >  NULL 값 지정하면 자동으로 값 입력
    1부터 증가하는 값 자동 입력 / 데이터 형은 숫자 형식만 사용 가능
    적용할 열이 PRIMARY KEY 또는 UNIQUE 일 때만 사용가능 */
    
    
USE sqlDB;
CREATE TABLE testTbl2
	(id int AUTO_INCREMENT PRIMARY KEY, userName char(3), age int);		-- 복사 테이블 만들기
    
INSERT INTO testTbl2 VALUES(NULL, '지민', 25); 
INSERT INTO testTbl2 VALUES(NULL, '유나', 22);
INSERT INTO testTbl2 VALUES(NULL, '유경', 21);
SELECT * FROM testTbl2;													


ALTER TABLE testTbl2 AUTO_INCREMENT=100;  								-- 시작번호를 100번으로 변경
INSERT INTO testTbl2 VALUES(NULL, '찬미', 23);  							-- 새로 하나 추가  (100번이 할당됨)
SELECT * FROM testTbl2; 												-- 확인 찬미 id 100

USE sqlDB;
CREATE TABLE testTbl3
	( id int AUTO_INCREMENT PRIMARY KEY, userName char(3), age int );	-- 복사 테이블 만들고 시작
    AlTER TABLE testTbl3 AUTO_INCREMENT=1000; 							-- 시작 1000
    SET @@auto_increment_increment=3; 									-- 시스ㅏ템 변수 3씩 건너띄기
    INSERT INTO testTbl3 VALUES(NULL, '지민', 25); 						-- 1000번 :  NULL 로 PUT 알아서 입됨
	INSERT INTO testTbl3 VALUES(NULL, '유나', 22); 						-- 1003번
	INSERT INTO testTbl3 VALUES(NULL, '유경', 21); 						-- 1006번				
    
SELECT * FROM testTbl3;													-- 결과 확인 동일


/* 대량의 샘플 데이터 생성 -  INSERT INTO… SELECT 구문 사용
	다른 테이블의 데이터를 가져와(SELECT) 대량으로 입력하는(INSERT INTO) 효과
	SELECT문의  열의 개수 =  INSERT 할 테이블의 열의 개수 */
    
    
USE sqlDB;
CREATE TABLE testTbl4
(id int, Fname varchar(50), Lname varchar(50));
    
INSERT INTO testTbl4 SELECT emp_no, first_name, 						
last_name FROM employees.employees; 									-- emp 에서 내용 가져와 채워넣기 

SELECT * FROM testTbl4;
    
CREATE TABLE testTbl5
	(SELECT emp_no, first_name, last_name FROM employees.employees);		-- table 도 한번에 가져와서 insert 까지 하기
SELECT * FROM testTbl5;
describe testTbl5;

/*  데이터수정 ㅣ UPDATE 
WHERE절 생략 가능하나 WHERE절 생략하면 테이블의 전체 행의 내용 변경됨 > 주의 */

SELECT * FROM testTbl4
	WHERE Fname='Kyoichi';					-- 수정 전 확인
    
UPDATE testTbl4
	SET Lname = '없음'
    WHERE Fname = 'Kyoichi';
    
SELECT * FROM testTbl4
	WHERE Fname='Kyoichi';					-- 수정 내용 확인
    
/* 데이터 삭제 데이터의 삭제: DELETE FROM
	행 단위로 데이터 삭제하는 구문 		DELETE FROM 테이블이름 WHERE 조건; */
    
    
USE sqlDB;
SELECT * FROM testTbl4
	WHERE Fname='Aamer';								-- 삭제 전 확인
    
DELETE FROM testTbl4 WHERE Fname = 'Aamer' LIMIT 5;		-- 5개 삭제 

DELETE FROM testTbl4 WHERE Fname = 'Aamer';  			-- 나머지 모두 삭제

SELECT * FROM testTbl4
	WHERE Fname='Aamer';								-- 삭제 여부 확인
    
-- 대용량 데이터 삭제 
    
    USE sqlDB;
CREATE TABLE bigTbl1 (SELECT * FROM employees.employees);	-- 삭제 위해 테이블 만들기 
CREATE TABLE bigTbl2 (SELECT * FROM employees.employees);
CREATE TABLE bigTbl3 (SELECT * FROM employees.employees);

DELETE FROM  bigTbl1;						-- 트랜잭션 로그 기록 작업 때문에 오래 걸림, 사용하지 말 것 (비효율적)
DROP TABLE bigTbl2;    						-- 빠름(트랜잭션 로그 기록 작업 없음), 테이블 구조까지 제거
TRUNCATE TABLE bigTbl3;   					-- 빠름(트랜잭션 로그 기록 작업 없음), 테이블 구조는 남김

select * FROM	bigtbl1;
-- select * FROM	bigtbl2;				-- 오류 : 구조까지 제거되어 확인 불가 
select * FROM	bigtbl3;

/*	조건부 데이터 입력, 변경 -- 기본 키가 중복된 데이터를 입력한 경우: 오류로 입력 불가
대용량 데이터 처리의 경우 에러 발생하지 않는 구문 실행 
	INSERT IGNORE문 사용 - 에러 발생해도 다음 구문으로 넘어가게 처리 > 에러 메시지 보면 적용되지 않은 구문이 어느 것인지 구분 가능 
	ON DUPLICATE KEY UPDATE > 기본 키가 중복되면 데이터를 수정되도록 하는 구문도 활용 가능 */
    

USE sqlDB;
CREATE TABLE memberTBL (SELECT userID, name, addr FROM userTbl LIMIT 3);
ALTER TABLE memberTBL ADD CONSTRAINT pk_memberTBL PRIMARY KEY (userID);
SELECT * FROM memberTBL;

INSERT INTO memberTBL VALUES('BBK', '비비코', '미국');		-- 중복으로 오류발생
INSERT INTO memberTBL VALUES('SJH', '서장훈', '서울');
INSERT INTO memberTBL VALUES('HJY', '현주엽', '경기');
SELECT * FROM memberTBL; 

INSERT IGNORE INTO memberTBL VALUES('BBK', '비비코', '미국');			-- PX 오류 발생해도 넘어감 
INSERT IGNORE INTO memberTBL VALUES('SJH', '서장훈', '서울');
INSERT IGNORE INTO memberTBL VALUES('HJY', '현주엽', '경기');			
SELECT * FROM memberTBL; 


INSERT INTO memberTBL VALUES('BBK', '비비코', '미국')
	ON DUPLICATE KEY UPDATE name='비비코', addr='미국';
INSERT INTO memberTBL VALUES('DJM', '동짜몽', '일본')
	ON DUPLICATE KEY UPDATE name='동짜몽', addr='일본';
SELECT * FROM memberTBL; -- check


 DROP TABLE memberTBL;