-- ROLE
-- 사용자에게 여러 개의 권한을 한번에 부여할 수 있는 데이터베이스 객체
-- 사용자에게 권한을 부여할 때 한개씩 부여하게 된다면 권한 부여 및 회수의 관리가 불편하므로 사용!
-- ex. GRANT CONNECT, RESOURCE TO KH;
-- 권한과 관련된 명령어는 반드시 SYSTEM에서 수행

-- CONNECT, RESOURCE 롤이다. 롤은 권한이 여러개가 모여있다.
-- 롤은 필요한 권한을 묶어서 관리할 때 편하고 부여, 회수할 때 편하다!!
-- ROLE
-- CONNECT롤 : CREATE SESSION
-- RESOURCE롤 : CREATE CLUSTER, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE
--             CREATE TRIGGER, CREATE TYPE, CREATE INDEXTYPE, CREATE OPERATOR;

-- 1. KH에서 조회됨
-- 2. SYSTEM에서 조회안됨
-- 3. KH에서는 부여 받았고, SYSTEM에서는 부여받지 않음
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'CONNECT';
--WHERE ROLE = 'RESOURCE';

-- 생성
CREATE ROLE ROLE_PUBLIC_EMP;
GRANT SELECT ON KH.V_EMP_INFO TO ROLE_PUBLIC_EMP;
GRANT SELECT ON KH.V_EMP_INFO TO CONNECT;
-- 사용
GRANT ROLE_PUBLIC_EMP TO 계정명;

SELECT * FROM USER_SYS_PRIVS;