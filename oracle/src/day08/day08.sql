--@DQL종합실습문제

--문제1
--기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오.
SELECT EMP_NAME "이름", DEPT_CODE "부서코드", SALARY "급여"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '기술지원부';

--문제2
--기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오
-- 방법1
SELECT EMP_NAME "이름", DEPT_CODE "부서코드", SALARY "급여"
FROM EMPLOYEE E
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID              -- 중복 발생
WHERE DEPT_TITLE = '기술지원부'
AND SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID              -- 중복 발생
WHERE DEPT_TITLE = '기술지원부');

-- 방법2
-- 상관쿼리로 해보기!
--SELECT EMP_NAME "이름", DEPT_CODE "부서코드", SALARY "급여",
--(SELECT SUM(SALARY) FROM EMPLOYEE WHERE SALARY < E.SALARY)
--FROM EMPLOYEE E
--JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
--WHERE DEPT_TITME = '기술지원부';


--문제3
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 
--사번,이름,매니저 이름, 월급을 구하시오.
SELECT EMP_ID AS 사번, EMP_NAME AS 이름
, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS "매니저 이름"
, SALARY AS 월급
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);


-- 1. CHECK
CREATE TABLE USER_CHECK(
    USER_NO NUMBER PRIMARY KEY,
    USER_NAME VARCHAR2(30) NOT NULL,
    -- 3으로 해야 한글 1개 가능
    -- USER_GENDER CHAR(1) 
    -- 성별을 남 or 여로만 받고 싶은데?
    -- CHECK
    USER_GENDER CHAR(3) CONSTRAINT GENDER_VAL CHECK(USER_GENDER IN('남', '여'))
);

DROP TABLE USER_CHECK;  -- 삭제

ALTER TABLE USER_CHECK          -- 변경
MODIFY USER_GENDER CHAR(3); 

-- 테이블을 비우기전에 실행하면 오류
ALTER TABLE USER_CHECK          -- 추가
ADD CONSTRAINT GENDER_VAL CHECK(USER_GENDER IN('남', '여'));

INSERT INTO USER_CHECK VALUES('1', '일용자', '남');
INSERT INTO USER_CHECK VALUES('2', '이용자', '여');
INSERT INTO USER_CHECK VALUES('3', '삼용자', 'M');
INSERT INTO USER_CHECK VALUES('4', '사용자', 'F');

DELETE FROM USER_CHECK;

SELECT * FROM USER_CHECK;

-- 2. DEFAULT
-- DDL, DML, DCL, TCL
CREATE TABLE USER_DEFAULT(
    USER_NO NUMBER CONSTRAINT USER_NO_PK1 PRIMARY KEY,
    USER_NAME VARCHAR2(30) NOT NULL,
    USER_DATE DATE DEFAULT SYSDATE,
    USER_YN CHAR(1) DEFAULT 'Y'
);

DROP TABLE USER_DEFAULT;

ALTER TABLE USER_DEFAULT
ADD USER_DATE DEFAULT SYSDATE;
ALTER TABLE USER_DEFAULT
ADD USER_YN DEFAULT 'Y';

-- 2-1. '일용자', '오늘날짜', 'Y'
INSERT INTO USER_DEFAULT VALUES(1, '일용자', '2022/12/23', 'Y');
-- 2-2. '이용자', '오늘날짜', 'N'
INSERT INTO USER_DEFAULT VALUES(2, '이용자', SYSDATE, 'N');
-- DEFAULT
INSERT INTO USER_DEFAULT VALUES(1, '일용자', DEFAULT, DEFAULT); 
INSERT INTO USER_DEFAULT VALUES(2, '이용자', DEFAULT, DEFAULT);

SELECT * FROM USER_DEFAULT;


-- 3. 셀프조인
-- 매니저가 있는 사원중에 월급이 전체사원 평균을 넘는 직원 사번, 이름, 매니저 이름, 월급 구하기
SELECT EMP_ID "사번", EMP_NAME "이름"
, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) "매니저 이름"
, SALARY "월급"
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

-- 셀프조인을 이용
-- 상관쿼리를 이용한 매니저 이름 구하기 결과 같은 것은 셀프 조인을 이용해서 구할 수 있음.
SELECT E.EMP_ID, E.EMP_NAME, M.EMP_NAME, E.SALARY
FROM EMPLOYEE E
JOIN EMPLOYEE M
ON M.EMP_ID = E.MANAGER_ID;

-- 4. 상호조인
-- 카테이션 곱(Cartesian Product)라고도 함
-- 조인되는 테이블의 각 행들이 모두 매핑된 조인 방법
-- 한쪽 테이블의 모든 행과 다른쪽 테이블의 모든 행을 조인 시킴
-- 모든 경우의 수를 구하므로 결과는 두 테이블의 컬럼수를 곱한 개수가 나옴

-- 실습문제
-- 아래처럼 나오도록 하세요
--(SELECT AVG(SALARY) FROM EMPLOYEE) -- 스칼라 쿼리 사용 x

-------------------------------------------------------
-- 사원번호     사원명     월급      평균월급    월급-평균월급
-------------------------------------------------------
SELECT EMP_ID "사원번호", EMP_NAME "사원명",SALARY "월급"
, AVG_SAL "평균월급"
, SALARY-AVG_SAL "월급-평균월급"
FROM EMPLOYEE
CROSS JOIN (SELECT ROUND(AVG(SALARY)) "AVG_SAL" FROM EMPLOYEE);

SELECT EMP_ID AS 사원번호, EMP_NAME AS 사원명,SALARY AS 월급
, AVG_SAL AS 평균월급
, (CASE 
    WHEN SALARY-AVG_SAL > 0 
    THEN '+' 
    END) || (SALARY-AVG_SAL) AS "월급-평균월급"
FROM EMPLOYEE
CROSS JOIN (SELECT ROUND(AVG(SALARY)) "AVG_SAL" FROM EMPLOYEE);


-- 난이도 상!!!
-- - 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는 사원출력.
-- 부서코드, 사원명, 급여, 부서별 급여평균