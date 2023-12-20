USE smore;

-- 테이블 삭제
DROP TABLE IF EXISTS FREE_LIKED;
DROP TABLE IF EXISTS FREECMT;
DROP TABLE IF EXISTS FREEIMAGE;
DROP TABLE IF EXISTS FREEBOARD;
DROP TABLE IF EXISTS C_LIKED;
DROP TABLE IF EXISTS C_ATTACH;
DROP TABLE IF EXISTS C_IMAGE;
DROP TABLE IF EXISTS C_CMT;
DROP TABLE IF EXISTS C_BOARD;
DROP TABLE IF EXISTS Q_CMT;
DROP TABLE IF EXISTS Q_BOARD;
DROP TABLE IF EXISTS GRP_REDBELL;
DROP TABLE IF EXISTS CMT_REDBELL;
DROP TABLE IF EXISTS S_MEMBER;
DROP TABLE IF EXISTS S_ZZIM;
DROP TABLE IF EXISTS S_CMT;
DROP TABLE IF EXISTS S_GROUP;
DROP TABLE IF EXISTS ACCESS_LOG;
DROP TABLE IF EXISTS RETIRE_USERS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS SLEEP_USERS;

-- 테이블 생성
CREATE TABLE USERS (
	USER_NO				INT				NOT NULL AUTO_INCREMENT,
	ID					VARCHAR(50)		NOT NULL UNIQUE,
	NICKNAME			VARCHAR(20)		NOT NULL UNIQUE,
	PW					VARCHAR(64)		NOT NULL,
	NAME				VARCHAR(50)		NOT NULL,
	GRADE				SMALLINT		NULL,	-- 관리자:0 스터디장:1  일반: 2
	GENDER				VARCHAR(1)		NOT NULL,	-- M, F
	EMAIL				VARCHAR(50)		NOT NULL UNIQUE,
	MOBILE				VARCHAR(11)		NOT NULL,
	BIRTHYEAR			VARCHAR(4)		NOT NULL,
	BIRTHDAY			VARCHAR(4)		NOT NULL,
	POSTCODE			VARCHAR(5)		NULL,
	ROAD_ADDRESS		VARCHAR(100)	NULL,
	JIBUN_ADDRESS		VARCHAR(100)	NULL,
	DETAIL_ADDRESS		VARCHAR(100)	NULL,
	EXTRA_ADDRESS		VARCHAR(100)	NULL,
	AGREE_CODE			INT	NOT NULL,
	SNS_TYPE			VARCHAR(10)		NULL,
	JOIN_DATE			DATETIME		NOT NULL,
	PW_MODIFY_DATE		DATETIME		NULL,	-- 첫 수정일은 회원가입 당시 SYSDATE 비번 마지막 변경일자 + 3개월 마다 변경 안내창 띄우기
	INFO_MODIFY_DATE	DATETIME		NULL,
	SESSION_ID			VARCHAR(32)		NULL,
	SESSION_LIMIT_DATE	DATETIME		NULL,
	BLACK_CNT			INT				NULL,	-- 유저가 신고당한 횟수
	USER_STATE			SMALLINT		NOT NULL,	-- 일반회원(1) / 제재회원(0) 구분
    CONSTRAINT PK_USERS PRIMARY KEY (USER_NO)
);


CREATE TABLE ACCESS_LOG (  -- 탈퇴해도 접속기록은 남아있다.
	ACCESS_LOG_NO		INT				NOT NULL AUTO_INCREMENT,
	ID					VARCHAR(50)		NOT NULL,
	LAST_LOGIN_DATE		DATETIME		NOT NULL,
    CONSTRAINT PK_ACCESS_LOG PRIMARY KEY (ACCESS_LOG_NO)
);

CREATE TABLE RETIRE_USERS (
	USER_NO		INT				NOT NULL AUTO_INCREMENT,
	ID			VARCHAR(50)		NOT NULL,
	JOIN_DATE	DATETIME		NULL,
	RETIRE_DATE	DATETIME		NULL,
    CONSTRAINT PK_RETIRE_USERS PRIMARY KEY (USER_NO)
);

CREATE TABLE SLEEP_USERS (
	USER_NO			INT				NOT NULL AUTO_INCREMENT,
	ID				VARCHAR(50)		NOT NULL,
    NICKNAME  		VARCHAR(20)   	NOT NULL UNIQUE,
	PW				VARCHAR(64)		NOT NULL,
	NAME			VARCHAR(50)		NOT NULL,
    GRADE   		INT   			NULL,   -- 관리자:0 스터디장:1  일반 : 2
	GENDER			VARCHAR(1)		NOT NULL,
	EMAIL			VARCHAR(50)		NOT NULL,
	MOBILE			VARCHAR(11)		NOT NULL,
	BIRTHYEAR   	VARCHAR(4)  	NOT NULL,
    BIRTHDAY  		VARCHAR(4)   	NOT NULL,
	POSTCODE   		VARCHAR(5)   	NULL,
    ROAD_ADDRESS    VARCHAR(100)  	NULL,
    JIBUN_ADDRESS   VARCHAR(100)    NULL,
    DETAIL_ADDRESS  VARCHAR(100)    NULL,
    EXTRA_ADDRESS   VARCHAR(100)    NULL,
    AGREE_CODE   	INT			    NOT NULL,
    SNS_TYPE   		VARCHAR(10)   	NULL,
	USER_STATE   	INT   			NOT NULL,
	JOIN_DATE		DATETIME		NULL,
	LAST_LOGIN_DATE	DATETIME		NULL,
	SLEEP_DATE		DATETIME		NULL,
    CONSTRAINT PK_SLEEP_USERS PRIMARY KEY (USER_NO)
);

CREATE TABLE FREEBOARD (
	FREE_NO		INT				NOT NULL AUTO_INCREMENT,
	NICKNAME	VARCHAR(20)		NULL,
	TITLE		VARCHAR(300)	NOT NULL,
	CONTENT		MEDIUMTEXT		NOT NULL,
	CREATE_DATE	DATETIME		NOT NULL,
	MODIFY_DATE	DATETIME		NOT NULL,
	HIT			INT				NOT NULL,
	IP			VARCHAR(20)		NULL,
    CONSTRAINT PK_FREEBOARD PRIMARY KEY (FREE_NO),
    CONSTRAINT FK_FREEBOARD_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE SET NULL
);

CREATE TABLE FREEIMAGE (
	FREE_NO		INT			NOT NULL AUTO_INCREMENT,
	FILESYSTEM	VARCHAR(40)	NULL,
    CONSTRAINT FK_FREEIMAGE_FREEBOARD FOREIGN KEY (FREE_NO) REFERENCES FREEBOARD (FREE_NO) ON DELETE CASCADE
);

CREATE TABLE FREECMT (
	CMT_NO			INT				NOT NULL AUTO_INCREMENT,
	FREE_NO			INT				NOT NULL,
	NICKNAME		VARCHAR(20)	    NULL,
	CMT_CONTENT		VARCHAR(300)	NOT NULL,
	CREATE_DATE		DATETIME		NOT NULL,
	MODIFY_DATE		DATETIME		NOT NULL,
	STATE			SMALLINT		NOT NULL,	-- 정상 1, 삭제 0
	DEPTH			SMALLINT		NOT NULL,	-- 댓글 0, 댓글의 답글 1
	GROUP_NO		INT				NOT NULL,   -- 댓글과 해당 댓글에 달린 답댓은 같은 그룹. insert 시 CURRVAL 용도
	IP				VARCHAR(20)		NOT NULL,
    CONSTRAINT PK_FREECMT PRIMARY KEY (CMT_NO),
    CONSTRAINT FK_FREECMT_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE SET NULL,
    CONSTRAINT FK_FREECMT_FREEBOARD FOREIGN KEY (FREE_NO) REFERENCES FREEBOARD (FREE_NO) ON DELETE CASCADE
);

CREATE TABLE FREE_LIKED (
	FREE_NO		INT			NOT NULL,
	NICKNAME	VARCHAR(20) NULL,
    CONSTRAINT FK_FREE_LIKED_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE SET NULL,
    CONSTRAINT FK_FREE_LIKED_FREEBOARD FOREIGN KEY (FREE_NO) REFERENCES FREEBOARD (FREE_NO) ON DELETE CASCADE
);

CREATE TABLE C_BOARD (
	CO_NO		INT				NOT NULL AUTO_INCREMENT,
	NICKNAME	VARCHAR(20)		NULL,
	TITLE		VARCHAR(300)	NOT NULL,
	CONTENT		MEDIUMTEXT		NOT NULL,
	CREATE_DATE	DATETIME		NOT NULL,
	MODIFY_DATE	DATETIME		NOT NULL,
	HIT			INT				NOT NULL,
	IP			VARCHAR(20)		NOT NULL,
	CONSTRAINT PK_C_BOARD PRIMARY KEY (CO_NO),
    CONSTRAINT FK_C_BOARD_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE SET NULL
);
                          
CREATE TABLE C_IMAGE (
	CO_NO		INT			NOT NULL,
	FILESYSTEM	VARCHAR(40)	NULL,
    CONSTRAINT FK_C_IMAGE_C_BOARD FOREIGN KEY (CO_NO) REFERENCES C_BOARD (CO_NO) ON DELETE CASCADE
);

CREATE TABLE C_ATTACH (
	ATTACH_NO		INT				NOT NULL AUTO_INCREMENT,
	CO_NO			INT				NOT NULL,
	PATH			VARCHAR(300)	NULL,	-- 파일의 경로
	ORIGIN			VARCHAR(300)	NULL,	-- 원본이름
	FILESYSTEM		VARCHAR(40)		NULL,	-- 파일의 저장된 이름
	DOWNLOAD_CNT	INT				NULL,
    CONSTRAINT PK_C_ATTACH PRIMARY KEY (ATTACH_NO),
    CONSTRAINT FK_C_ATTACH_C_BOARD FOREIGN KEY (CO_NO) REFERENCES C_BOARD (CO_NO) ON DELETE CASCADE
);

CREATE TABLE C_CMT (
	CMT_NO			INT				NOT NULL AUTO_INCREMENT,
	CO_NO			INT				NOT NULL,
	NICKNAME		VARCHAR(20)		NULL,
	CMT_CONTENT		VARCHAR(300)	NOT NULL,
	CREATE_DATE		DATETIME		NOT NULL,
	MODIFY_DATE		DATETIME		NOT NULL,
	STATE			SMALLINT		NOT NULL,	-- 정상 1, 삭제 0
	DEPTH			SMALLINT		NOT NULL,	-- 댓글 0, 댓글의 답글 1
	GROUP_NO		INT				NOT NULL,   -- 댓글과 해당 댓글에 달린 답댓은 같은 그룹. insert 시 CURRVAL 용도
	IP				VARCHAR(20)		NOT NULL,
    CONSTRAINT PK_C_CMT PRIMARY KEY (CMT_NO),
    CONSTRAINT FK_C_CMT_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE SET NULL,
    CONSTRAINT FK_C_CMT_C_BOARD FOREIGN KEY (CO_NO) REFERENCES C_BOARD (CO_NO) ON DELETE CASCADE
);

CREATE TABLE C_LIKED (
	CO_NO		INT			NOT NULL,
	NICKNAME	VARCHAR(20)	NULL,
    CONSTRAINT FK_C_LIKED_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE SET NULL,
    CONSTRAINT FK_C_LIKED_C_BOARD FOREIGN KEY (CO_NO) REFERENCES C_BOARD (CO_NO) ON DELETE CASCADE
);

CREATE TABLE Q_BOARD (
	QA_NO		INT				NOT NULL AUTO_INCREMENT,
	NICKNAME	VARCHAR(20)		NULL,
	TITLE		VARCHAR(300)	NOT NULL,
	CONTENT		MEDIUMTEXT		NOT NULL,
	PW			INT				NULL,
	CREATE_DATE	DATETIME		NOT NULL,
	MODIFY_DATE	DATETIME		NOT NULL,
	HIT			INT				NOT NULL,
	IP			VARCHAR(20)		NULL,
	ANSWER	 	INT				NOT NULL,
    CONSTRAINT PK_Q_BOARD PRIMARY KEY (QA_NO),
    CONSTRAINT FK_Q_BOARD_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE SET NULL
);

CREATE TABLE Q_CMT (
	CMT_NO			INT				NOT NULL AUTO_INCREMENT,
	QA_NO			INT				NOT NULL,
    NICKNAME		VARCHAR(20)		NOT NULL,
	CMT_CONTENT		VARCHAR(300)	NOT NULL,  -- 관리자만 댓글 작성 가능
	CREATE_DATE		DATETIME		NOT NULL,
	MODIFY_DATE		DATETIME		NOT NULL,
	STATE			SMALLINT		NOT NULL,	-- 정상 1, 삭제 0
	IP				VARCHAR(20)		NOT NULL,
    CONSTRAINT PK_Q_CMT PRIMARY KEY (CMT_NO),
    CONSTRAINT FK_Q_CMT_Q_BOARD FOREIGN KEY (QA_NO) REFERENCES Q_BOARD (QA_NO) ON DELETE CASCADE
);

CREATE TABLE S_GROUP (
	STUD_NO		INT				NOT NULL AUTO_INCREMENT,
	NICKNAME	VARCHAR(20)		NOT NULL,
	TITLE		VARCHAR(300)	NOT NULL,
	CONTENT		MEDIUMTEXT		NOT NULL,
	CREATE_DATE	DATETIME		NOT NULL,
	MODIFY_DATE	DATETIME		NOT NULL,
	HIT			INT				NOT NULL,
	GENDER		VARCHAR(1)		NOT NULL,
	REGION		VARCHAR(300)	NOT NULL,
	WIDO		VARCHAR(30)		NOT NULL,
	GDO			VARCHAR(30)		NOT NULL,
	LANG		VARCHAR(500)	NOT NULL,
	PEOPLE		VARCHAR(50)		NOT NULL,
	CONTACT		VARCHAR(30)		NOT NULL,
	STUD_DATE	DATETIME		NOT NULL,
	IP			VARCHAR(20)		NOT NULL,
    CONSTRAINT PK_S_GROUP PRIMARY KEY (STUD_NO),
    CONSTRAINT FK_S_GROUP_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE CASCADE
);

CREATE TABLE S_CMT (
	CMT_NO			INT				NOT NULL AUTO_INCREMENT,
	STUD_NO			INT				NOT NULL,
	NICKNAME		VARCHAR(20)		NULL,
	CMT_CONTENT		VARCHAR(300)	NOT NULL,
	CREATE_DATE		DATETIME		NOT NULL,
	STATE			SMALLINT		NOT NULL,	-- 정상 1, 삭제 0
	DEPTH			SMALLINT		NOT NULL,	-- 댓글0, 댓글의 답글 1
	GROUP_NO		INT				NOT NULL,   -- 댓글과 해당 댓글에 달린 답댓은 같은 그룹. insert 시 CURRVAL 용도
	IP				VARCHAR(20)		NOT NULL,
    CONSTRAINT PK_S_CMT PRIMARY KEY (CMT_NO),
    CONSTRAINT FK_S_CMT_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE SET NULL,
    CONSTRAINT FK_S_CMT_S_GROUP FOREIGN KEY (STUD_NO) REFERENCES S_GROUP (STUD_NO) ON DELETE CASCADE
);

CREATE TABLE S_ZZIM (
	STUD_NO		INT			NOT NULL,
	NICKNAME	VARCHAR(20)	NOT NULL,
    CONSTRAINT FK_S_ZZIM_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE CASCADE,
    CONSTRAINT FK_S_ZZIM_S_GROUP FOREIGN KEY (STUD_NO) REFERENCES S_GROUP (STUD_NO) ON DELETE CASCADE
);

CREATE TABLE S_MEMBER (
	NICKNAME		VARCHAR(20)	NOT NULL,
	STUD_NO			INT			NOT NULL,
	APPLY_DATE		DATETIME	NULL,
	APPLY_GUBUN		SMALLINT	NULL,	-- 대기:0, 확정:1,  취소:2
    CONSTRAINT FK_S_MEMBER_USERS FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME) ON DELETE CASCADE,
    CONSTRAINT FK_S_MEMBER_S_GROUP FOREIGN KEY (STUD_NO) REFERENCES S_GROUP (STUD_NO) ON DELETE CASCADE
);

CREATE TABLE GRP_REDBELL (
   RED_NO   	INT      	  NOT NULL AUTO_INCREMENT, -- PK 시퀀스
   ID  		 	VARCHAR(50)   NOT NULL, -- 유저테이블 외래키
   STUD_NO   	INT      	  NOT NULL, -- 스터디그룹 외래키
   RED_CONTENT  VARCHAR(300)  NOT NULL,
   RED_DATE   	DATETIME      NOT NULL,
   CONSTRAINT PK_GRP_REDBELL PRIMARY KEY (RED_NO),
   CONSTRAINT FK_GRP_REDBELL_USERS FOREIGN KEY (ID) REFERENCES USERS (ID) ON DELETE CASCADE,
   CONSTRAINT FK_GRP_REDBELL_S_GROUP FOREIGN KEY (STUD_NO) REFERENCES S_GROUP (STUD_NO) ON DELETE CASCADE
);



CREATE TABLE CMT_REDBELL (
   RED_CMT_NO    INT     		NOT NULL AUTO_INCREMENT, -- PK 시퀀스
   ID   		 VARCHAR(50)    NOT NULL, -- 유저테이블 외래키
   CMT_NO   	 INT      		NOT NULL, -- 스터디댓글 테이블 외래키
   RED_CONTENT   VARCHAR(300)   NOT NULL,
   RED_DATE   	 DATETIME       NOT NULL,
   CONSTRAINT PK_CMT_REDBELL PRIMARY KEY (RED_CMT_NO),
   CONSTRAINT FK_CMT_REDBELL_USERS FOREIGN KEY (ID) REFERENCES USERS (ID) ON DELETE CASCADE,
   CONSTRAINT FK_CMT_REDBELL_S_CMT FOREIGN KEY (CMT_NO) REFERENCES S_CMT (CMT_NO) ON DELETE CASCADE
);

DROP TABLE IF EXISTS JOBS;

CREATE TABLE JOBS (
	JOB_NO 		 INT 			NOT NULL AUTO_INCREMENT,
    TITLE 		 VARCHAR(50) 	NOT NULL,	-- 구인 공고 제목
    NICKNAME	 VARCHAR(20)	NOT NULL,
    COMPANY_NAME VARCHAR(50) 	NOT NULL,	-- 회사 이름
    CONTACT 	 VARCHAR(15)  	NULL,		-- 회사 연락처
	HOMEPAGE 	 VARCHAR(80) 	NULL,		-- 회사 홈페이지 링크
    PROFILE 	 MEDIUMTEXT 	NOT NULL,	-- 회사 소개
    -- USERS 테이블이랑 조인 해야되나..? 조인 하기엔 슬데 없는게 넘 많은데 우짜노..
    HR_NAME 	 VARCHAR(15) 	NOT NULL,	-- 채용 담당자 이름
    HR_CONTACT 	 VARCHAR(11) 	NOT NULL, 	-- 인사 관련 연락처
    HR_EMAIL 	 VARCHAR(60) 	NOT NULL,	-- 채용 담당자 이메일
    -- 
	STATUS 		 SMALLINT 		NOT NULL, 	-- 채용중0, 채용완료1
    SKILL_STACK	 VARCHAR(500) 	NULL,  		-- 기술스택
    CAREER 		 VARCHAR(30) 	NOT NULL,   -- 요구 경력
    POSITION 	 VARCHAR(50) 	NOT NULL,	-- 포지션(프론트/백)
	LOCATION 	 VARCHAR(100) 	NOT NULL,	-- 근무 지역
    JOB_TYPE 	 VARCHAR(30) 	NOT NULL,  	-- 고용 형태 (정규직/계약직)
    CONTENT 	 MEDIUMTEXT 	NOT NULL,	-- 공고 내용
    CREATE_DATE  DATETIME 		NOT NULL,	
	HIT			 INT 	 		NOT NULL,
    
    CONSTRAINT PRIMARY KEY (JOB_NO),
    CONSTRAINT FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME)
);

ALTER TABLE USERS MODIFY COLUMN GRADE SMALLINT NOT NULL;  -- USERS 테이블FREECMTJOBS
ALTER TABLE JOBS MODIFY COLUMN HR_CONTACT VARCHAR(13) NOT NULL;
ALTER TABLE JOBS MODIFY COLUMN CONTACT VARCHAR(13) NOT NULL;

DROP TABLE IF EXISTS JOB_ZZIM;
CREATE TABLE JOB_ZZIM (
	JOB_NO      INT 		NOT NULL,
    NICKNAME 	VARCHAR(20)	NOT NULL,
    CONSTRAINT FOREIGN KEY (JOB_NO) REFERENCES JOBS (JOB_NO),
    CONSTRAINT FOREIGN KEY (NICKNAME) REFERENCES USERS (NICKNAME)
);

ALTER TABLE S_GROUP MODIFY STUD_DATE VARCHAR(20);
ALTER TABLE JOB_ZZIM DROP FOREIGN KEY JOB_ZZIM_IBFK_1;
ALTER TABLE JOB_ZZIM ADD CONSTRAINT FOREIGN KEY (JOB_NO) REFERENCES JOBS (JOB_NO) ON DELETE CASCADE;

COMMIT;


-- 닉네임fk...... el로 loginUser 닉네임으로 fk
-- alter table jobs add column career varchar(30) not null;
-- alter table jobs add column skill varchar(500) null;   -- 기술스택
-- alter table jobs add column staus smallint not null;   -- 채용중0 채용완료1
-- alter table jobs add foreign key (nickname) references users (nickname); 
