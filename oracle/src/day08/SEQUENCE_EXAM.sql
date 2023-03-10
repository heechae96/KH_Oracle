-- SEQUENCE(시퀀스)
DELETE FROM USER_DEFAULT;
COMMIT;

DELETE FROM USER_DEFAULT;
DROP SEQUENCE SEQ_SAMPLE1;
DROP SEQUENCE SEQ_USERNO;

INSERT INTO USER_DEFAULT VALUES(1, '일용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(2, '이용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(3, '삼용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(4, '사용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(5, '오용자', DEFAULT, DEFAULT);

SELECT * FROM USER_DEFAULT;

-- 이전에 추가한 데이터를 몇 번까지 만들었는지 모르는 경우
-- PK이어서 겹치면 안된다!!
-- 조회하는 과정이 귀찮다!

-- ORA-00001: unique constraint (KH.USER_NO_PK1) violated
INSERT INTO USER_DEFAULT VALUES(5, '오용자', DEFAULT, DEFAULT);

-- 시퀀스 생성(자동번호 발생기 생성)
CREATE SEQUENCE SEQ_USERNO;
-- 만들어진 시퀀스 확인
SELECT * FROM USER_SEQUENCES;
-- 사용법은?
-- 쓸려고 했는데 SEQ_USERNO.NEXTVAL 1부터 들어갈텐데.. 이미 1값이 있다!
-- DELETE FROM USER_DEFAULT 후 INSERT INTO 하자!
DELETE FROM USER_DEFAULT;
INSERT INTO USER_DEFAULT VALUES(SEQ_USERNO.NEXTVAL, '오용자', DEFAULT, DEFAULT);
SELECT SEQ_USERNO.CURRVAL FROM DUAL; -- 오류가 발생해서 값이 안들어가도 계속 올라감...

-- 시퀀스 수정
-- START WITH값은 변경이 불가능하기 때문에 변경하려면 삭제 후 다시 생성해야함
CREATE SEQUENCE SEQ_SAMPLE1;
-- 시퀀스 생성
SELECT * FROM USER_SEQUENCES;
ALTER SEQUENCE SEQ_SAMPLE1 INCREMENT BY 10;
SELECT SEQ_SAMPLE1.NEXTVAL FROM DUAL;
SELECT SEQ_SAMPLE1.CURRVAL FROM DUAL; -- 10









-- DAY07 어려웠던 문제..
-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는 사원출력.
-- 부서코드, 사원명, 급여, 부서별 급여평균

-- SELECT 부서코드, 사원명, 급여, 부서별 급여평균
-- FROM EMPLOYEE
-- WHERE 직급이 xxx아닌 AND 부서별 평균급여보다;

SELECT 
    E.DEPT_CODE AS 부서코드
    , E.EMP_NAME AS 사원명
    , E.SALARY AS 급여
    , AVG_SAL AS "부서별 급여평균"
FROM EMPLOYEE E
JOIN (SELECT DEPT_CODE, CEIL(AVG(SALARY)) "AVG_SAL"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE) A ON E.DEPT_CODE = A.DEPT_CODE
WHERE JOB_CODE NOT IN('J1', 'J2', 'J3') AND E.SALARY > AVG_SAL;

SELECT DEPT_CODE, CEIL(AVG(SALARY)) "AVG_SAL"
FROM EMPLOYEE
GROUP BY DEPT_CODE;