-- 최종 실습 문제

-- 문제1. 
-- 입사일이 5년 이상, 10년 이하인 직원의 이름,주민번호,급여,입사일을 검색하여라
SELECT EMP_NAME as 이름, EMP_NO "주민번호", SALARY "급여", HIRE_DATE as 입사일
FROM EMPLOYEE
--WHERE SYSDATE-HIRE_DATE > 5*365 AND SYSDATE-HIRE_DATE < 10*365;
WHERE CEIL((SYSDATE-HIRE_DATE)/365) BETWEEN 5 AND 10;


-- 문제2.
-- 재직중이 아닌 직원의 이름,부서코드, 고용일, 근무기간, 퇴직일을 검색하여라 
--(퇴사 여부 : ENT_YN)
--SELECT EMP_NAME AS 이름, DEPT_CODE AS 부서코드, HIRE_DATE AS 고용일, SYSDATE-HIRE_DATE "근무기간", ENT_DATE "퇴직일"
SELECT EMP_NAME AS 이름, DEPT_CODE AS 부서코드, HIRE_DATE AS 고용일, ENT_DATE-HIRE_DATE "근무기간", ENT_DATE "퇴직일"
FROM EMPLOYEE
--WHERE ENT_YN = 'Y';
WHERE ENT_YN != 'N';

-- 문제3.
-- 근속년수가 10년 이상인 직원들을 검색하여
-- 출력 결과는 이름,급여,근속년수(소수점X)를 근속년수가 오름차순으로 정렬하여 출력하여라
-- 단, 급여는 50% 인상된 급여로 출력되도록 하여라.
SELECT EMP_NAME AS 이름, SALARY*1.5 AS 급여, FLOOR((SYSDATE-HIRE_DATE)/365) "근속년수"
FROM EMPLOYEE
WHERE SYSDATE-HIRE_DATE > 10*365
--ORDER BY FLOOR(SYSDATE-HIRE_DATE) ASC;
ORDER BY 3 ASC;


-- 문제4.
-- 입사일이 99/01/01 ~ 10/01/01 인 사람 중에서 급여가 2000000 원 이하인 사람의
-- 이름,주민번호,이메일,폰번호,급여를 검색 하시오
SELECT EMP_NAME AS 이름, EMP_NO AS 주민번호, EMAIL AS 이메일, SALARY AS 급여
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN TO_DATE('99/01/01') AND TO_DATE('10/01/01')
-- BETWEEN A AND B
AND SALARY < 2000000;

-- 문제5.
-- 급여가 2000000원 ~ 3000000원 인 여직원 중에서 4월 생일자를 검색하여 
-- 이름,주민번호,급여,부서코드를 주민번호 순으로(내림차순) 출력하여라
-- 단, 부서코드가 null인 사람은 부서코드가 '없음' 으로 출력 하여라. ##안배움
SELECT EMP_NAME "이름", EMP_NO "주민번호", NVL(DEPT_CODE, '없음') "부서코드"
FROM EMPLOYEE
WHERE (SALARY >= 2000000 AND 3000000 >= SALARY) 
--AND (SUBSTR(EMP_NO, 8, 1) IN ('2', '4')) 
AND (SUBSTR(EMP_NO, 8, 1) BETWEEN '2' AND '4') 
AND (SUBSTR(EMP_NO, 4, 1) = '4')
--ORDER BY EMP_NO DESC;
ORDER BY 2 DESC;


-- 문제6.
-- 남자 사원 중 보너스가 없는 사원의 오늘까지 근무일을 측정하여 
-- 1000일 마다(소수점 제외) 
-- 급여의 10% 보너스를 계산하여 이름,특별 보너스 (계산 금액) 결과를 출력하여라.
-- 단, 이름 순으로 오름 차순 정렬하여 출력하여라.
SELECT EMP_NAME "이름", FLOOR((SYSDATE-HIRE_DATE) / 1000) * 0.1 * SALARY "특별보너스"
FROM EMPLOYEE
--WHERE (SUBSTR(EMP_NO, 8, 1) IN ('1', '3')) AND BONUS IS NULL
WHERE (EMP_NO LIKE '%-1%' OR EMP_NO LIKE '%-3%') AND BONUS IS NULL
ORDER BY EMP_NAME ASC;

--------------------------------------------------------------------------------

--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오. 
-- 그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오  ## 안배움
--	    직원명    년생      보너스
--	ex) 선동일	    1962	    0.3
--	ex) 송은희	    1963  	    0

SELECT EMP_NAME "직원명", CONCAT('19', SUBSTR(EMP_NO,1,2)) "년생", NVL(BONUS,0) "보너스"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 69;
--WHERE EMP_NO LIKE '6%';

--4. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
--	   인원
--	ex) 3명

-- 날짜 처리 함수
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
SELECT EXTRACT(YEAR FROM HIRE_DATE) FROM EMPLOYEE;
--SELECT EXTRACT(YEAR FROM TO_DATE(EMP_NO)) FROM EMPLOYEE;
--SELECT EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2))) FROM EMPLOYEE;
SELECT EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RR')) FROM EMPLOYEE;
-- 66 : 너무 짧음
-- 66년인지 모르겠어서 년도라는걸 알려줘야함 RR
-- YY를 쓰면 2000년대로 인식함. 2066년..


--5. 직원명과 입사년월을 출력하시오 
--	단, 아래와 같이 출력되도록 만들어 보시오
--	    직원명		입사년월
--	ex) 전형돈		2012년 12월
--	ex) 전지연		1997년 3월
SELECT EMP_NAME "직원명", 
EXTRACT(YEAR FROM HIRE_DATE) || '년 ' || EXTRACT(MONTH FROM HIRE_DATE) || '월' "입사년월"
FROM EMPLOYEE;

--6. 직원명과 주민번호를 조회하시오
--	단, 주민번호 9번째 자리부터 끝까지는 '*' 문자로 채워서출력 하시오
--	ex) 홍길동 771120-1******
SELECT EMP_NAME AS 직원명 ,SUBSTR(EMP_NO,1,8) || '******' "주민번호"
FROM EMPLOYEE;


--7. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
SELECT EMP_NAME AS 직원명, JOB_CODE AS 직급코드, 
TO_CHAR(SALARY*12+SALARY*NVL(BONUS,0), '999,999,999,999') "연봉(원)"
FROM EMPLOYEE;

SELECT TO_CHAR(SALARY, 'L999,999,999') FROM EMPLOYEE;
SELECT TO_CHAR(SALARY, 'L000,000,000') FROM EMPLOYEE;

--8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
--   사번 사원명 부서코드 입사일
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_CODE "부서코드",
TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') "입사일"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;

--9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--	* 주말도 포함 , 소수점 아래는 버림

--10. 직원명, 부서코드, 생년월일, 나이(만) 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
--	* 주민번호가 이상한 사람들은 제외시키고 진행 하도록(200,201,214 번 제외)
--	* HINT : NOT IN 사용
SELECT EMP_NAME AS 직원명, DEPT_CODE AS 부서코드
,'19' || SUBSTR(EMP_NO,1,2) || '년 ' || SUBSTR(EMP_NO,3,2) || '월 ' || SUBSTR(EMP_NO,5,2) || '일' AS 생년월일
, EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RR')) 
|| '년 ' || EXTRACT(MONTH FROM TO_DATE(SUBSTR(EMP_NO,3,2), 'MM')) 
|| '월 ' || EXTRACT(DAY FROM TO_DATE(SUBSTR(EMP_NO,5,2), 'DD')) || '일' "생년월일2"
, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) AS "나이(만)"
, EXTRACT(YEAR FROM SYSDATE) - (1900+TO_NUMBER(SUBSTR(EMP_NO,1,2))) "나이(만)2"
, EXTRACT(YEAR FROM SYSDATE) - (DECODE(SUBSTR(EMP_NO,8,1),'1',1900,'2',1900,2000)+TO_NUMBER(SUBSTR(EMP_NO,1,2))) "나이(만)3"
FROM EMPLOYEE
WHERE EMP_ID NOT IN(200,201,214);

SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남자','2','여자','3','남자','4','여자') "성별"
FROM EMPLOYEE;

--11. 사원명과, 부서명을 출력하세요.
--   부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.

--------------------------------------------------------------------------------