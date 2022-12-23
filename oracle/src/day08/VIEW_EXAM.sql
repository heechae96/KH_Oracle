-- 오라클 객체(Object)
--테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 패키지(PACKAGE), 
--프로시저(PROCEDUAL), 함수(FUNCTION), 트리거(TRIGGER), 동의어(SYNONYM), 
--사용자(USER)가 있다.
SELECT DISTINCT OBJECT_TYPE FROM ALL_OBJECTS;

-- 뷰
CREATE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;

SELECT * FROM V_EMPLOYEE
WHERE EMP_ID = 200;

-- 뷰 삭제
-- 하나 이상의 테이블에서 원하는 데이터를 선택하여 가상의 테이블을 만들어 주는것
-- 다른 테이블에 있는 데이터를 보여줄 뿐이며, 데이터 자체를 포함하고 있는것은 아님
-- 즉, 저장장치 내에 물리적으로 존재하지 않고 가상테이블로 만들어짐
-- 물리적인 실제 테이블과의 링크 개념
-- 뷰를 사용하며 특정 사용자가 원본 테이블에 모든 데이터를 보게 하는 것을 방지 할 수 있음
-- 다시 말해, 원본 테이블이 아닌 뷰를 통한 특정데이터만 보져지게 만듦
-- 뷰를 만들기 위해서는 권한이 필요함.
-- RESOURCE롤에는 포함되어 있지 않음!!(주의)
DROP VIEW V_EMPLOYEE;

CREATE VIEW V_EMP_READ
AS SELECT EMP_ID, DEPT_TITLE FROM EMPLOYEE JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;

SELECT * FROM V_EMP_READ;

-- 뷰 수정
UPDATE V_EMPLOYEE
SET DEPT_CODE = 'D8'
WHERE EMP_ID = 200;

SELECT * FROM V_EMPLOYEE
WHERE EMP_ID = 200;

-- 원본 테이블을 확인해보니 수정되어있음
SELECT * FROM EMPLOYEE WHERE EMP_ID = 200;

