--@실습문제
--1. EMPLOYEE 테이블에서 직급이 J1을 제외하고, 직급별 사원수 및 평균급여를 출력하세요.
SELECT JOB_CODE "직급", COUNT(*) "사원수", TO_CHAR(SUM(SALARY), 'L999,999,999') "평균급여"
FROM EMPLOYEE
WHERE DEPT_CODE <> 'J1'
--WHERE DEPT_CODE != 'J1'
GROUP BY JOB_CODE;


--2. EMPLOYEE테이블에서 직급이 J1을 제외하고,  입사년도별 인원수를 조회해서, 입사년 기준으로 오름차순 정렬하세요.
SELECT EXTRACT(YEAR FROM HIRE_DATE) "입사년도별", COUNT(*)
FROM EMPLOYEE
WHERE JOB_CODE <> 'J1'
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
ORDER BY 1 ASC;

--3. [EMPLOYEE] 테이블에서 EMP_NO의 8번째 자리가 1, 3 이면 '남', 2, 4 이면 '여'로 결과를 조회하고,
-- 성별별 급여의 평균(정수처리), 급여의 합계, 인원수를 조회한 뒤 인원수로 내림차순을 정렬 하시오
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남','3','남','2','여','4','여') "성별",
FLOOR(AVG(SALARY)) "급여의 평균(정수처리)", SUM(SALARY) "급여의 합계", COUNT(*) "인원수"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1),'1','남','3','남','2','여','4','여')
ORDER BY 4 DESC;

--4. 부서내 성별 인원수를 구하세요.
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남','3','남','2','여','4','여') "성별", 
COUNT(*) "인원수"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1),'1','남','3','남','2','여','4','여');


-- HAVING절
-- 그룹함수로 값을 구해온 그룹에 대해 조건을 설정할때는
-- HAVING절에 기술함!! 
-- WHERE절 사용 불가!
--5. 부서별 급여 평균이 3,000,000원(버림적용) 이상인  부서들에 대해서 부서명, 급여평균을 출력하세요.
--'D1'제외
SELECT DEPT_CODE "부서명", FlOOR(AVG(SALARY)) "급여평균"
FROM EMPLOYEE
WHERE DEPT_CODE != 'D1'
--WHERE FlOOR(AVG(SALARY)) > 3000000
--00934. 00000 -  "group function is not allowed here"
GROUP BY DEPT_CODE
HAVING FlOOR(AVG(SALARY)) > 3000000;


--@실습문제
--1. 부서별 인원이 5명보다 많은 부서와 인원수를 출력하세요.
SELECT DEPT_CODE "부서", COUNT(*) "인원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(*) > 5;

--2. 부서별 직급별 인원수가 3명이상인 직급의 부서코드, 직급코드, 인원수를 출력하세요.
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
HAVING COUNT(*) >= 3
ORDER BY 1 ASC;

--3. 매니져가 관리하는 사원이 2명이상인 매니져아이디와 관리하는 사원수를 출력하세요.
SELECT MANAGER_ID, COUNT(*)
FROM EMPLOYEE
GROUP BY MANAGER_ID
HAVING COUNT(*) >=2 AND MANAGER_ID IS NOT NULL
ORDER BY 1;
-- 뒤에 조건 없으면 오름차순

