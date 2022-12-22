--@조인실습문제_kh
-- 조인문제 아닌것도 있음

--1. 2022년 12월 25일이 무슨 요일인지 조회하시오.
SELECT TO_CHAR(SYSDATE, 'DAY') "요일"
FROM DUAL;


--2. 주민번호가 1970년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT EMP_NAME "사원명", EMP_NO "주민번호", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
--WHERE '19' || SUBSTR(EMP_NO,1,2) LIKE '19%' 
WHERE (SUBSTR(EMP_NO,1,2)) BETWEEN 70 AND 79
AND SUBSTR(EMP_NO,8,1) = '2' 
AND EMP_NAME LIKE '전%';


--3. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
SELECT EMP_NO "사번", EMP_NAME "사원명", DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE EMP_NAME LIKE '%형%';

--4. 없음

--5. 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_CODE "부서코드",  DEPT_TITLE "부서명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE DEPT_TITLE LIKE '해외영업%';


--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME "사원명", BONUS "보너스", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCAL_CODE = LOCATION_ID
WHERE BONUS IS NOT NULL;


--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역명"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE DEPT_CODE = 'D2';


--8. 급여등급테이블의 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
-- (사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 조인할 것)
-- 데이터 존재 하지 않음
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여", SALARY*12 "연봉"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE MAX_SAL < SARALY;


--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "지역명", NATIONAL_NAME "국가명"
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_ID = DEPT_CODE
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
JOIN NATIONAL USING(NATIONAL_CODE)
--WHERE NATIONAL_CODE = 'KO' OR NATIONAL_CODE = 'JP';
WHERE NATIONAL_CODE IN ('KO', 'JP');


--10. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오. 
--단, join과 IN 사용할 것
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL 
AND JOB_NAME IN ('차장', '사원');

--11. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
SELECT DECODE(ENT_YN, 'Y', '퇴직', 'N', '재직') "근속여부", COUNT(*) "직원수"
FROM EMPLOYEE
GROUP BY DECODE(ENT_YN, 'Y', '퇴직', 'N', '재직');
