-- UNIQUE 제약조건
INSERT INTO JOB VALUES('J1', '대표');
INSERT INTO JOB VALUES('J2', '부사장');
INSERT INTO JOB VALUES('J3', '부장');
INSERT INTO JOB VALUES('J4', '차장');
INSERT INTO JOB VALUES('J5', '과장');
INSERT INTO JOB VALUES('J6', '대리');
INSERT INTO JOB VALUES('J7', '사원');
INSERT INTO JOB VALUES('J7', '신입사원');
-- ORA-00001: unique constraint (KH.JOB_PK) violated
INSERT INTO JOB VALUES(NULL, '주임');
-- ORA-01400: cannot insert NULL into ("KH"."JOB"."JOB_CODE")
-- PRIMARY KEY 제약조건
-- NULL이 들어가지 않고 중복도 되지 않도록 하는 제약조건
-- 고유식별자로써의 역할을 하도록함.
CREATE TABLE JOB(
    JOB_CODE CHAR(2) CONSTRAINT JOB_PK PRIMARY KEY,
    -- 제약조건명 지정 ex.JOB_PK
    JOB_NAME VARCHAR2(35)
);
DROP TABLE JOB;
DESC JOB;
-- NOT NULL 제약조건
INSERT INTO DEPARTMENT
VALUES(NULL, NULL, 'L1');
-- ORA-01400: cannot insert NULL into ("KH"."DEPARTMENT"."DEPT_CODE")
CREATE TABLE DEPARTMENT(
    DEPT_CODE CHAR(2) NOT NULL,
    DEPT_TITLE VARCHAR2(40),
    LOACTION_ID CHAR(2) NOT NULL
);
-- 제약조건 삭제
ALTER TABLE DEPARTMENT
DROP CONSTRAINT SYS_C0000343;
-- Table DEPARTMENT이(가) 변경되었습니다.
-- 제약조건 추가
ALTER TABLE DEPARTMENT
ADD CONSTRAINT DEPARTMENT_PK PRIMARY KEY(DEPT_CODE);
-- EMPLOYEE 제약조건 추가!
ALTER TABLE EMPLOYEE
ADD CONSTRAINT EMPLOYEE_PK PRIMARY KEY(EMP_ID);
ALTER TABLE EMPLOYEE
MODIFY EMP_NAME NOT NULL
MODIFY EMP_NO NOT NULL
MODIFY JOB_CODE NOT NULL
MODIFY SAL_LEVEL NOT NULL;

-- Table DEPARTMENT이(가) 변경되었습니다.
-- 제약조건이름 수정
ALTER TABLE DEPARTMENT
RENAME CONSTRAINT DEPARTMENT_PK TO DEPT_ID_PK;
-- Table DEPARTMENT이(가) 변경되었습니다.
DROP TABLE DEPARTMENT;

COMMENT ON COLUMN DEPARTMENT.DEPT_ID IS '부서코드';

DESC DEPARTMENT;

-- 컬럼명 수정
ALTER TABLE DEPARTMENT
RENAME COLUMN DEPT_ID TO DEPT_CODE;
-- Table DEPARTMENT이(가) 변경되었습니다.

-- 테이블명 수정, DEPARTMENT -> DEPARTMENT2 -> DEPARTMENT
ALTER TABLE DEPARTMENT
RENAME TO DEPARTMENT2;
-- Table DEPARTMENT이(가) 변경되었습니다.

RENAME DEPARTMENT2 TO DEPARTMENT;
-- 테이블 이름이 변경되었습니다.

-- 컬럼 데이터타입 수정
ALTER TABLE DEPARTMENT
MODIFY DEPT_TITLE VARCHAR2(40);
-- Table DEPARTMENT이(가) 변경되었습니다.
DESC DEPARTMENT;

-- 컬럼 추가
ALTER TABLE DEPARTMENT
ADD (DEPT_NAME VARCHAR2(30));
-- Table DEPARTMENT이(가) 변경되었습니다.

-- 컬럼 삭제
ALTER TABLE DEPARTMENT
DROP COLUMN DEPT_NAME;
-- Table DEPARTMENT이(가) 변경되었습니다.
DESC DEPARTMENT;

DESC DEPARTMENT;