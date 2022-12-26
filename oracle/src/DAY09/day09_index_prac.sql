-- INDEX
-- SQL 명령문의 처리속도를 향상시키기 위해서 컬럼에 대해서 생성하는 오라클 객체
-- -> key-value형태로 생성이 되며 key에는 인덱스로 만들 컬럼값, value에는 행이 제거됨
-- 주소값이 저장됨
-- 장점1) 검색속도가 빨라지고 시스템에 걸리는 부하를 줄여서 시스템 전체 성능을 향상 시킬 수 있음
-- 단점1) 인덱스를 위한 추가 저장 공간이 필요하고, 인덱스를 생성하는데 시간이 걸림
-- 단점2) 데이터 변경작업(insert/update/delete)이 자주 일어나는 테이블에 index

-- 인덱스 정보조회
SELECT * FROM USER_INDEXES
WHERE TABLE_NAME = 'EMPLOYEE';

-- 한번도 만들지 않았으나 PK, UNIQUE 제약조건 컬럼은 자동으로 동일한 이름의 인덱스를 생성함
-- index 생성
-- CREATE INDEX 인덱스명 ON 테이블명(컬럼명1, 컬럼명2, ...);
SELECT * FROM EMPLOYEE WHERE EMP_NAME = '송종기';
-- 오라클 플랜, 튜닝할 때 사용하고 f10으로 실행 가능
CREATE INDEX IDX_EMP_NAME ON EMPLOYEE(EMP_NAME);
-- INDEX IDX_EMP_NAME(가) 생성되었음

-- 인덱스 삭제
DROP INDEX IDX_EMP_NAME;