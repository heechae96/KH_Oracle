-- 앞에서 USER_DEFAULT을 만들었고
-- 테이블에 내용은 없는 상태
INSERT INTO USER_DEFAULT VALUES(1, '일용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(2, '이용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(3, '삼용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(4, '사용자', DEFAULT, DEFAULT);    -- 최종 커밋, 트랜잭션 종료

COMMIT;

DELETE FROM USER_DEFAULT;
SELECT * FROM USER_DEFAULT; -- 데이터 다 날라감

ROLLBACK;   -- 최근 커밋 지점으로 돌아감 6line

SELECT * FROM USER_DEFAULT; -- 데이터 다 조회됨

INSERT INTO USER_DEFAULT VALUES(5, '오용자', DEFAULT, DEFAULT);    -- 임시저장 SAVEPOINT
SAVEPOINT temp1;
DELETE FROM USER_DEFAULT WHERE USER_NO = 5;
SELECT * FROM USER_DEFAULT; -- 5날라가고 4까지만 나옴
ROLLBACK TO temp1;
SELECT * FROM USER_DEFAULT; -- 5용자까지 나옴

ROLLBACK;
SELECT * FROM USER_DEFAULT; -- 5용자는 조회안됨. 4용자까지 나옴

ROLLBACK to temp1;  -- 6번째 라인으로 돌아감. 따라서 temp1은 없는상태.
-- temp1이라는 세이브 포인트가 없는데 temp1로 돌아가라고 하니까 에러발생
-- ORA-01086: savepoint 'TEMP1' never established in this session or is invalid





-- TCL
-- 트랜잭션이란?
-- 한꺼번에 수행되어야 할 최소의 작업 단위를 말함, 
-- 하나의 트랜잭션으로 이루어진 작업들은 반드시 한꺼번에 완료가 되어야 하며,
-- 그렇지 않은 경우에는 한꺼번에 취소 되어야 함
-- TCL의 종류
-- 1. COMMIT : 트랜잭션 작업이 정상 완료 되면 변경 내용을 영구히 저장 (모든 savepoint 삭제)
-- 2. ROLLBACK : 트랜잭션 작업을 모두 취소하고 가장 최근 commit 시점으로 이동
-- 3. SAVEPOINT : 현재 트랜잭션 작업 시점에 이름을 지정함, 하나의 트랜잭션 안에서 구역을 나눌수 있음
-- >> ROLLBACK TO 세이브포인트명 : 트랜잭션 작업을 취소하고 savepoint 시점으로 이동