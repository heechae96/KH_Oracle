-- #PL/SQL
-- > Oracle's Procedural Language Extension to SQL의 약자
-- > 오라클 자체에 내장되어 있는 절차적 언어로써 
-- SQL의 단점을 보완하여 SQL 문장내에서 변수의 정의, 조건처리, 반복처리 등을 지원함

-- ## PL/SQL의 구조(익명블록)
-- 1. 선언부(선택)
-- DECLARE : 변수나 상수를 선언하는 부분
-- 2. 실행부(필수)
-- BEGIN : 제어문, 반복문, 함수 정의 등 로직 기술
-- 3. 예외처리부(선택)
-- EXCEPTION : 예외사항 발생시 해결하기 위한 문장 기술
-- END; --블록 종료
-- /    -- PL/SQL 종료 및 실행

SET SERVEROUTPUT ON;
-- 활성화 필요

-- '선동일' 이라는 사람의 EMP_ID값을 추출하여 ID라는 변수에 넣어주고 PUT_LINE을 통해 출력함
--만약 '선동일' 이라는 사람이 없으면 'No Data!!!' 라는 예외 구문을 출력하도록 함
DECLARE
    vId NUMBER;
BEGIN
    SELECT EMP_ID
    INTO vId
    FROM EMPLOYEE
    WHERE EMP_NAME = '선동일';
    DBMS_OUTPUT.PUT_LINE('ID='||vId);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data!!');
END;
/

-- ## 변수 선언
-- 변수명 [CONSTANT] 자료형(바이트크기) [NOT NULL] [:=초기값];

-- ## 변수의 종류
-- 일반변수, 상수, %TYPE, %ROWTYPE, 레코드(RECORD)

-- ## 상수
-- 일반변수와 유사하나 CONSTANT라는 키워드가 자료형 앞에 붙고
-- 선언시에 값을 할당해주어야 함.
DECLARE
    EMPNO NUMBER := 507;
    ENAME VARCHAR2(20) := '일용자';
BEGIN
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMPNO);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
END;
/

DECLARE
    USER_NAME VARCHAR2(20) := '일용자';
    MNAME CONSTANT VARCHAR2(20) := '삼용자';
BEGIN
    USER_NAME := '이용자';
    DBMS_OUTPUT.PUT_LINE('이름 : '|| USER_NAME);
    -- MNAME := '사용자';
    -- PLS-00363: expression 'MNAME' cannot be used as an assignment target
    DBMS_OUTPUT.PUT_LINE('상수 : '|| MNAME);
END;
/

-- PL/SQL문에서 SELECT문
-- > SQL에서 사용하는 명령어를 그대로 사용할 수 있으며 SELECT 쿼리 결과로 나온 값을
-- 변수에 할당하기 위해 사용함.
--예제1)
--PL/SQL의 SELECT문으로 EMPLOYEE 테이블에서 주민번호와 이름 조회하기
DESC EMPLOYEE;

DECLARE
    VEMPNO EMPLOYEE.EMP_NO%TYPE; -- CHAR(14)
    VENAME EMPLOYEE.EMP_NAME%TYPE; -- VARCHAR2(20)
BEGIN
    SELECT EMP_NO AS 주민번호, EMP_NAME AS 이름
    INTO VEMPNO, VENAME
    FROM EMPLOYEE
    WHERE EMP_NAME = '송종기';
    DBMS_OUTPUT.PUT_LINE('주민등록번호 : '||VEMPNO);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| VENAME);
END;
/

--예제 2)
--송종기 사원의 사원번호, 이름, 급여, 입사일을 출력하시오
DECLARE
    VEMPID EMPLOYEE.EMP_NO%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    VHIREDATE EMPLOYEE.HIRE_DATE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
    INTO VEMPID, VENAME, VSALARY, VHIREDATE
    FROM EMPLOYEE
    WHERE EMP_NAME = '송종기';
    DBMS_OUTPUT.PUT_LINE('사원번호 : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||VENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||VSALARY);
    DBMS_OUTPUT.PUT_LINE('입사일 : '||VHIREDATE);
END;
/


--예제 3)
--송종기 사원을 입력받아 사원번호, 이름, 급여, 입사일을 출력하시오
DECLARE
    VEMPID EMPLOYEE.EMP_NO%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    VHIREDATE EMPLOYEE.HIRE_DATE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
    INTO VEMPID, VENAME, VSALARY, VHIREDATE
    FROM EMPLOYEE
    WHERE EMP_NAME = '&VENAME';  -- 입력받기 
--    WHERE EMP_NAME = &VENAME;   -- '송종기'
    DBMS_OUTPUT.PUT_LINE('사원번호 : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||VENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||VSALARY);
    DBMS_OUTPUT.PUT_LINE('입사일 : '||VHIREDATE);
END;
/





--## 간단 실습 1 ##
-- 해당 사원의 사원번호를 입력시
-- 이름,부서코드,직급코드가 출력되도록 PL/SQL로 만들어 보시오.
DECLARE
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDEPTCODE EMPLOYEE.DEPT_CODE%TYPE;
    VJOBCODE EMPLOYEE.JOB_CODE%TYPE;
BEGIN
    SELECT EMP_NAME, DEPT_CODE, JOB_CODE
    INTO VENAME, VDEPTCODE, VJOBCODE
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMPID';
    -- WHERE EMP_ID = '&AAA';   -- 가이드메시지
    DBMS_OUTPUT.PUT_LINE('이름 : '||VENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||VDEPTCODE);
    DBMS_OUTPUT.PUT_LINE('직급코드 : '||VJOBCODE);
END;
/

--## 간단 실습 2 ##
-- 해당 사원의 사원번호를 입력시
-- 이름,부서명,직급명이 출력되도록 PL/SQL로 만들어 보시오
DECLARE
    VNAME EMPLOYEE.EMP_NAME%TYPE;
    VDEPTTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    VJOBNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
    INTO VNAME, VDEPTTITLE, VJOBNAME
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
    LEFT JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMPID';
    DBMS_OUTPUT.PUT_LINE('이름 : '|| VNAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : '|| VDEPTTITLE);
    DBMS_OUTPUT.PUT_LINE('직급명 : '|| VJOBNAME);
END;
/

-- PL/SQL의 선택문
-- 모든 문장들을 기술한 순서대로 순차적으로 수행됨
-- 문장을 선택적으로 수행하려면 IF문을 사용하면됨
-- IF ~ THEN ~ END IF;

-- 예제1. 사원번호를 가기조 사원의 사번, 이름, 급여, 보너스율을 출력하고
-- 보너스율이 없으면 '보너스를 지급받지 않는 사원입니다'를 출력하시오
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    VBONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO VEMPID, VENAME, VSALARY, VBONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '200';
    DBMS_OUTPUT.PUT_LINE('사번 : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||VENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '||VSALARY);
    -- 보너스율이 있으면 보너스를 출력하고
    -- 보녀스율이 없으면(0이면) 보너스를 지급받지 않는 사원입니다. 출력
    -- IF ~ THEN ~ END IF; 문
    IF(VBONUS <> 0) -- 보너스가 0이 아니면
    THEN DBMS_OUTPUT.PUT_LINE('보너스 : '|| VBONUS * 100 || '%');
    ELSE DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
END;
/


-- 예제2) 사원 코드를 입력 받았을때 사번, 이름, 직급코드, 직급명, 소속 값을 출력
-- 그때, 소속값 J1, J2는 임원진, 그 외에는 일반직원으로 출력되게 하시오
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VJOBCODE EMPLOYEE.JOB_CODE%TYPE;
    VJOBNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
    INTO VEMPID, VEMPNAME, VJOBCODE, VJOBNAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMPID';        -- 가이드메세지
    DBMS_OUTPUT.PUT_LINE('사번 : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||VEMPNAME);
    DBMS_OUTPUT.PUT_LINE('직급코드 : '||VJOBCODE);
    DBMS_OUTPUT.PUT_LINE('직급명 : '||VJOBNAME);
    -- 따로 받음
    IF(VJOBCODE IN ('J1', 'J2'))
    THEN DBMS_OUTPUT.PUT_LINE('소속 : '|| '임원진');
    ELSE DBMS_OUTPUT.PUT_LINE('소속 : '|| '일반직원'); 
    END IF;
END;
/


DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VJOBCODE EMPLOYEE.JOB_CODE%TYPE;
    VJOBNAME JOB.JOB_NAME%TYPE;
    VTEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
    INTO VEMPID, VEMPNAME, VJOBCODE, VJOBNAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMPID';    
    IF(VJOBCODE IN ('J1', 'J2'))
    THEN VTEAM := '임원진';
    ELSE VTEAM := '일반직원';
    END IF;
    DBMS_OUTPUT.PUT_LINE('사번 : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||VEMPNAME);
    DBMS_OUTPUT.PUT_LINE('직급코드 : '||VJOBCODE);
    DBMS_OUTPUT.PUT_LINE('직급명 : '||VJOBNAME);
    DBMS_OUTPUT.PUT_LINE('소속 : '|| VTEAM);
END;
/


--## 간단 실습 1 ##
-- 사원 번호를 가지고 해당 사원을 조회
-- 이때 사원명,부서명 을 출력하여라.
-- 만약 부서가 없다면 부서명을 출력하지 않고,
-- '부서가 없는 사원 입니다' 를 출력하고
-- 부서가 있다면 부서명을 출력하여라.
DECLARE
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VDTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    VDID DEPARTMENT.DEPT_ID%TYPE;
BEGIN
    SELECT EMP_NAME, DEPT_TITLE, DEPT_ID
    INTO VEMPNAME, VDTITLE, VDID
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&사원번호';
    DBMS_OUTPUT.PUT_LINE('이름 : ' || VEMPNAME);
    IF(VDID IS NULL) 
    THEN DBMS_OUTPUT.PUT_LINE('부서가 없는 사원입니다.');
    ELSE DBMS_OUTPUT.PUT_LINE('부서명 : '|| VDTITLE);
    END IF;
END;
/


--## 간단 실습2 ##
--사번을 입력 받은 후 급여에 따라 등급을 나누어 출력하도록 하시오 
--그때 출력 값은 사번,이름,급여,급여등급을 출력하시오

--0만원 ~ 99만원 : F
--100만원 ~ 199만원 : E
--200만원 ~ 299만원 : D
--300만원 ~ 399만원 : C
--400만원 ~ 499만원 : B
--500만원 이상(그외) : A

--ex) 200
--사번 : 200
--이름 : 선동일
--급여 : 8000000
--등급 : A

DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    SGRADE VARCHAR2(3);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO VEMPID, VENAME, VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&검색할사번';
    VSALARY := VSALARY / 10000;
    IF(VSALARY BETWEEN 0 AND 99) THEN SGRADE := 'F';
    ELSIF(VSALARY >= 100 AND VSALARY <= 199) THEN SGRADE := 'E';
    ELSIF(VSALARY >= 200 AND VSALARY <= 299) THEN SGRADE := 'D';
    ELSIF(VSALARY BETWEEN 300 AND 399) THEN SGRADE := 'C';
    ELSIF(VSALARY BETWEEN 400 AND 499) THEN SGRADE := 'B';
    ELSE SGRADE := 'A';
    END IF;
    DBMS_OUTPUT.PUT_LINE('사번 : '|| VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| VENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '|| VSALARY);
    DBMS_OUTPUT.PUT_LINE('등급 : '|| SGRADE);
END;
/

-- CASE문

-- 값으로 하는경우
-- CASE변수
--      WHEN 값1 THEN 실행문1;
--      WHEN 값2 THEN 실행문2;
--      ELSE 실행문3;
-- END CASE;

-- 범위(조건식)로 하는 경우
-- CASE
--      WHEN 값1 THEN 실행문1;
--      WHEN 값2 THEN 실행문2;
--      ELSE 실행문3;
-- END CASE;

-- 범위(조건식)로 하는 경우
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    SGRADE VARCHAR2(3);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO VEMPID, VENAME, VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&검색할사번';
    VSALARY := VSALARY / 10000;
    CASE
        WHEN (VSALARY >= 0 AND VSALARY <= 99)       THEN SGRADE := 'F';
        WHEN (VSALARY BETWEEN 100 AND 199)          THEN SGRADE := 'E';
        WHEN (VSALARY BETWEEN 200 AND 299)          THEN SGRADE := 'D';
        WHEN (VSALARY BETWEEN 300 AND 399)          THEN SGRADE := 'C';
        WHEN (VSALARY >= 400 AND VSALARY <= 499)    THEN SGRADE := 'B';
        ELSE SGRADE := 'A';
    END CASE;
    DBMS_OUTPUT.PUT_LINE('사번 : '|| VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| VENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '|| VSALARY || '만원');
    DBMS_OUTPUT.PUT_LINE('등급 : '|| SGRADE);
END;
/

-- 값으로 하는경우
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    SGRADE VARCHAR2(3);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO VEMPID, VENAME, VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&검색할사번';
    VSALARY := VSALARY / 10000;
    CASE FLOOR(VSALARY/100)
        WHEN 0 THEN SGRADE := 'F';
        WHEN 1 THEN SGRADE := 'E';
        WHEN 2 THEN SGRADE := 'D';
        WHEN 3 THEN SGRADE := 'C';
        WHEN 4 THEN SGRADE := 'B';
        ELSE SGRADE := 'A';
    END CASE;    
    DBMS_OUTPUT.PUT_LINE('사번 : '|| VEMPID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| VENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '|| VSALARY || '만원');
    DBMS_OUTPUT.PUT_LINE('등급 : '|| SGRADE);
END;
/