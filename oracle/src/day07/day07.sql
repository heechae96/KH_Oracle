-- ## 서브쿼리(SubQuery)
-- > 하나의 SQL문 안에 포함되어 있는 또 따른 SQL문(SELECT)
-- > 메인쿼리가 서브쿼리를 포함하는 종속적인 관계
-- ### 특징
-- >> 서브쿼리는 연산자의 오른쪽에 위치해야 함
-- >> 서브쿼리는 반드시 소괄호로 묶어야 함 ( SELECT .... )

-- 1. '전지연' 직원의 관리자 이름을 출력하시오
-- step1. '전지연 직원의 관리자 ID는 무엇인가?
-- step2. 관리자 ID로 직원의 이름을 구한다
SELECT MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '전지연'; -- 214
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = 214;   -- 방명수
-- 합치기
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '전지연');

-- 2. 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하시오
-- STEP1. 평균 급여를 구한다
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE; -- 3047662
-- STEP2. 평균급여보다 많은 급여를 받는 직원을 조회한다.
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE SALARY > 3047662;
-- 한번에 처리
SELECT EMP_ID "사번", EMP_NAME "이름", JOB_CODE "직급코드", SALARY "급여"
FROM EMPLOYEE
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE);

-- ## 서브쿼리(Sub Query)의 유형
-- 1. 단일행 서브쿼리
-- 2. 다중행 서브쿼리
-- 3. 다중열 서브쿼리
-- 4. 다중행 다중열 서브쿼리
-- 5. 상(호여)관 서브쿼리
-- 6. 스칼라 서브쿼리

-- ### 1. 단일행 서브쿼리
-- 서브쿼리의 조회 결과값(행,튜플,레코드)의 갯수가 1개 일때

-- ### 2. 다중행 서브쿼리
-- 서브쿼리의 조회 결과값(행,튜플,레코드)이 여러개 일 때
-- 다중행 서브쿼리 앞에는 일반 비교연산자 사용불가 ( IN/NOT IN, ANY, ALL, EXIST )

-- 2.1 IN
-- 쿼리의 비교 조건이 결과 중에서 하나라도 일치하는 것, OR

-- 송종기나 박나라가 속한 부서에 속한 사원들 정보 출력
-- step1. 송중기 부서코드 구하고 박나라 부서코드 구하기
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '송종기'; -- D9
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '박나라'; -- D5
-- step2. 구한 부서코드 정보 출력
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9', 'D5');
-- 한번에
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('송종기', '박나라'));



-- 실습문제
-- 다중행 서브쿼리
-- 1. 차태연, 전지연 사원의 급여등급(emplyee테이블의 sal_level컬럼)과 같은 사원의 직급명, 사원명을 출력.
-- STEP1
SELECT SAL_LEVEL "급여등급"
FROM EMPLOYEE WHERE EMP_NAME IN ('차태현', '전지연');
-- STEP2
SELECT JOB_NAME "직급명", EMP_NAME "사원명"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);
-- 한번에
SELECT JOB_NAME "직급명", EMP_NAME "사원명"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연', '전지연'));

-- 2.Asia1지역에 근무하는 사원 정보출력(부서코드, 사원명)하시오.
-- 메인쿼리 조인 사용
SELECT DEPT_CODE "부서코드", EMP_NAME "사원명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1';

-- 다중행 서브쿼리 사용
SELECT DEPT_CODE "부서코드", EMP_NAME "사원명"
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT 
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1');

-- 2.2 NOT IN
-- 쿼리의 비교조건이 결과 중에서 하나도 일치하지 않는 것

-- ## 3. 다중열 서브쿼리        --pass
-- ## 4. 다중행 다중열 서브쿼리   --pass

-- ## 5. 상(호연)관 서브쿼리
-- >> 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음 그 결과를
-- 다시 메인쿼리로 반환해서 수행하는 쿼리
-- > 서브쿼리의 WHERE절 수행을 위해서는 메인쿼리가 먼저 수행되는 구조
-- > 메인 쿼리 테이블의 레코드(행)에 따라 서브쿼리의 결과 값도 바뀜
-- 구분하기! : 메인쿼리에 있는 것을 서브쿼리에 가져다 쓰면 상관 서브쿼리
-- 그렇지 않고 서브쿼리가 단독으로 사용되면 일반 서브쿼리

-- 실습문제
-- 직급이 대표, 부사장이 아닌 모든 사원을 부서별로 출력
-- step1. 대표, 부사장 JOB_CODE구하기
SELECT JOB_CODE FROM JOB WHERE JOB_NAME IN ('대표', '부사장');
-- step2. 구한 JOB_CODE 조건절에 넣기
-- 한방에
SELECT DEPT_CODE, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE NOT IN (SELECT JOB_CODE FROM JOB WHERE JOB_NAME IN ('대표', '부사장'))
ORDER BY 1;

-- 상(호연)관 서브쿼리
-- 일반 서브쿼리
SELECT EMP_NAME, SALARY
FROM EMPLOYEE 
WHERE JOB_CODE = (SELECT JOB_CODE FROM JOB WHERE JOB_NAME = '대표');
-- 상(호연) 서브쿼리
-- 메인쿼리에 있는 것을 서브쿼리에 가져다 쓰면 상관 서브쿼리
-- 부하직원이 한명이라도 있는 직원, 매니저를 출력하세요
SELECT EMP_NAME, EMP_ID, MANAGER_ID, SALARY
FROM EMPLOYEE E
WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);

SELECT DISTINCT MANAGER_ID FROM EMPLOYEE;

-- 상(호연)서브쿼리를 다른 쿼리문으로 대체 할 수 있는 경우엔 다른거 써도 괜찮음!!
-- DEPT_CODE가 없는 사람을 출력하시오.
SELECT EMP_NAME FROM EMPLOYEE WHERE DEPT_CODE IS NULL;

-- 메인쿼리에서 가져다 써야되는 컬럼은 무엇인가? , DEPT_CODE
-- 그 값은 어느 테이블에서 써야되는가? , DEPARTMENT
SELECT EMP_NAME FROM EMPLOYEE E 
WHERE NOT EXISTS(SELECT 1 FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE);

-- 가장 많은 급여를 받는 사원을 exists 상관 서브쿼리를 이용해서 구하라.
-- 일반 서브쿼리
SELECT EMP_NAME "사원"
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);
-- 상관 서브커리
SELECT EMP_NAME "사원"
FROM EMPLOYEE E
WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
--WHERE

-- 가장 적은 급여를 받는 사원을 exists 상관 서브쿼리를 이용해서 구하라.
-- 일반 서브쿼리
SELECT EMP_NAME "사원"
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);
-- 상관 서브커리
SELECT EMP_NAME "사원"
FROM EMPLOYEE E
WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);

-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는 사원출력.
-- 부서코드, 사원명, 급여, 부서별 급여평균
SELECT DEPT_ID "부서코드", EMP_NAME "사원명", SALARY "급여", AVG(SALARY) "급여평균"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE;



-- ## 6. 스칼라 서브쿼리
-- 결과값이 1개인 상관서브쿼리, SELECT문에서 사용됨
-- ### 6.1 스칼라 서브쿼리
-- ex) 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회하세요
SELECT 
    EMP_ID "사번", 
    EMP_NAME "이름", 
    MANAGER_ID "관리자사번",
    (SELECT EMP_NAME FROM EMPLOYEE M WHERE M.EMP_ID = E.MANAGER_ID)
FROM EMPLOYEE E;

--@실습문제
--1. 사원명, 부서명, 부서별 평균임금을 스칼라서브쿼리를 이용해서 출력하세요.
SELECT 
    EMP_NAME "사원명", 
    DEPT_TITLE "부서명",
    (SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = D.DEPT_ID) "부서별 평균임금"
FROM EMPLOYEE
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID;

-- ### 6.2 스칼라 서브쿼리 - WHERE절
-- ex) 자신이 속한 직급의 평균 급여보다 많이 받는 직원의 이름, 직급, 급여를 조회하세요

-- ### 6.3 스칼라 서브쿼리 - ORDER BY절
-- ex) 모든 직원의 사번, 이름, 소속부서를 조회후 부서명을 오름차순으로 정렬하세요

-- 7. 인라인뷰
-- FROM절에 서브쿼리를 사용한 것
-- 이전시간까지는 WHERE절, SELECT절에서만 사용했음

-- DEPARTMENT에는 3가지 컬럼이 있지만 2개만 가지고 있는 테이블로 보는것
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
FROM (SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT);

SELECT EMP_ID, SALARY, MANAGER_ID
FROM (SELECT EMP_NAME, EMP_ID, SALARY, EMP_NO FROM EMPLOYEE);

--@실습문제
--1. employee테이블에서 2010년도에 입사한 사원의 사번, 사원명, 입사년도를 인라인뷰를 사용해서 출력.
SELECT *
FROM 
(SELECT EMP_ID "사번", EMP_NAME "사원명", EXTRACT(YEAR FROM HIRE_DATE) "입사년도" FROM EMPLOYEE)
WHERE 입사년도 BETWEEN 2010 AND 2019;

-- JOIN 사용한것과 JOIN 사용하지 않은것 결과 차이 yes!

--2. employee테이블에서 사원중 30대, 40대인 여자사원의 사번, 부서명, 성별, 나이를 인라인뷰를 사용해서 출력하라.
-- JOIN사용
SELECT *
FROM
(SELECT 
    EMP_ID "사번", 
    DEPT_TITlE "부서명", 
    DECODE(SUBSTR(EMP_NO,8,1), '1', '남', '3', '남', '여') "성별", 
    EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) "나이"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID)
WHERE 성별 = '여' AND FLOOR(나이/10) IN (3, 4);

-- JOIN사용 x
SELECT *
FROM
(SELECT 
    EMP_ID AS 사번
    , (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = DEPT_CODE) AS 부서명
    , DECODE(SUBSTR(EMP_NO,8,1), '1','남', '3','남','여') 성별
    , EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS 나이
FROM EMPLOYEE)
WHERE 성별 = '여' AND FLOOR(나이/10) IN (3, 4);