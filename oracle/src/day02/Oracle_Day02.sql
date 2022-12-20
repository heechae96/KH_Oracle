-- 테이블 생성
CREATE TABLE STUDENT_TBL(
    STUDENT_NAME VARCHAR2(20),
    STUDENT_AGE NUMBER,
    STUDENT_GRADE NUMBER,
    STUDENT_ADDRESS VARCHAR2(100)
);

-- 테이블 수정 -> 삭제 + 생성
-- 테이블 삭제
DROP TABLE STUDENT_TBL;

DESC DATATYPE_TBL;

INSERT INTO DATATYPE_TBL
VALUES('문자2', '문자열2', 22, SYSDATE, SYSTIMESTAMP);

UPDATE DATATYPE_TBL SET MOONJJAYUL = '오라클이 제일 쉬웠어요' WHERE MOONJJA = '문자';

CREATE TABLE DATATYPE_TBL(
    MOONJJA CHAR(10),   
    -- 알파벳 10글자, 한글 3글자
    MOONJJAYUL VARCHAR2(100),   
    -- 알파벳 100글자, 한글 33글자
    SOOJJA NUMBER,
    NALJJA DATE,
    NALJJA2 TIMESTAMP
);

-- TABLE에 데이터를 넣는 방법 -> 회원가입
INSERT INTO STUDENT_TBL(STUDENT_NAME, STUDENT_AGE, STUDENT_GRADE, STUDENT_ADDRESS) 
VALUES ('이용자', 22, 2, '서울');

INSERT INTO STUDENT_TBL VALUES ('일용자', 11, 1, '서울시 종로구');
INSERT INTO STUDENT_TBL VALUES ('', 44, 4, NULL);
--                              NULL
INSERT INTO STUDENT_TBL VALUES (' ', 44, 4, NULL);
--                              공백으로 값이 있는것

INSERT INTO STUDENT_TBL VALUES('이용자', 22, 2, '서울시 종로구');
INSERT INTO STUDENT_TBL VALUES('삼용자', 33, 3, '서울시 동대문구');
INSERT INTO STUDENT_TBL VALUES('사용자', 44, 4, '서울시 서대문구');

-- 데이터를 삭제해보자 -> 회원탈퇴
DELETE FROM STUDENT_TBL;
DELETE FROM STUDENT_TBL WHERE STUDENT_GRADE = 2;

-- 데이터를 수정해보자 -> 정보수정
UPDATE STUDENT_TBL SET STUDENT_AGE = 99 WHERE STUDENT_GRADE = 2;
UPDATE STUDENT_TBL SET STUDENT_AGE = 99;

-- 데이터 조회 -> 정보조회
SELECT * FROM STUDENT_TBL;
SELECT * FROM STUDENT_TBL WHERE STUDENT_GRADE=1;