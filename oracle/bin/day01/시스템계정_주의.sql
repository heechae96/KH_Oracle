-- 사용자 계정 생성, 권한부여 및 해제

-- 주석
-- opt + cmd + / : 여러행 주석 
-- ctrl + enter : 실행
-- command + , : 환경설정
-- ctrl + fn + f7 : 자동정렬

-- 디렉토리 조회
SELECT * FROM DICTIONARY;

-- 계정생성
--          계정명                 비밀번호(대소문자 구별)
CREATE USER STUDENT IDENTIFIED BY STUDENT;
-- Grant을(를) 성공했습니다.
GRANT CONNECT TO STUDENT;

GRANT RESOURCE TO STUDENT;

-- 테이블 생성
CREATE TABLE STUDENT_TBL(
    STUDENT_NAME VARCHAR(20),
    STUDENT_AGE NUMBER,
    STUDENT_GRADE NUMBER,
    STUDENT_ADDRESS VARCHAR(100)
);

-- KH계정을 만들고 그 비밀번호는 KH로 해주세요
CREATE USER KH IDENTIFIED BY KH;
GRANT RESOURCE, CONNECT TO KH;