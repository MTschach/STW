create table USER (
	ID_USER				int not null primary key,
	USER_NAME			nvarchar(50) not null,
	FIRST_NAME			nvarchar(100) not null,
	LAST_NAME			nvarchar(100) not null,
	ID_USER_GROUP     int not null,
	MEMBER_SINCE		timestamp not null,
   RECORD_STATE		char(1) not null,
   DATE_INSERT			timestamp not null,
   ID_USER_INSERT		int not null,
   DATE_UPDATE			timestamp null
   ID_USER_UPDATE    int null	
)

create table USER_GROUP (
   ID_USER_GROUP		int not null primary key,
   NAME					nvarchar(25) not null,
   DESCRIPTION			nvarchar(255) not null default '',
   RECORD_STATE		char(1) not null,
   DATE_INSERT			timestamp not null,
   ID_USER_INSERT		int not null,
   DATE_UPDATE			timestamp null
   ID_USER_UPDATE    int null
)

create table USER_GROUP_TEXT (
	ID_USER_GROUP_TEXT	int not null primary key,
	ID_USER_GROUP			int not null,
	LANGUAGE					char(2) not null,
	NAME						nvarchar(25) not null,
	DESCRIPTION				nvarchar(255) not null default '',
   RECORD_STATE			char(1) not null,
   DATE_INSERT				timestamp not null,
   ID_USER_INSERT			int not null,
   DATE_UPDATE				timestamp null
   ID_USER_UPDATE    	int null,
   foreign key (ID_USER_GROUP) references USER_GROUP (ID_USER_GROUP)
)

create index on USER_GROUP_TEXT (ID_USER_GROUP, LANGUAGE)


create table RIGHTS (
	ID_RIGHTS			int not null primary key,
	NAME					nvarchar(50) not null,
	DESCRIPTION			nvarchar(255) not null default '',
	RECORD_STATE      char(1) not null,
	DATE_INSERT			timestamp not null,
   ID_USER_INSERT		int not null,
   DATE_UPDATE			timestamp null
   ID_USER_UPDATE    int null
)

create table RIGHTS_TEXT (
	ID_RIGHTS_TEXT    int not null primary key,
	ID_RIGHTS			int not null,
	LANGUAGE				char(2),
	NAME					nvarchar(50) not null,
	DESCRIPTION			nvarchar(255) not null default '',
	RECORD_STATE      char(1) not null,
	DATE_INSERT			timestamp not null,
   ID_USER_INSERT		int not null,
   DATE_UPDATE			timestamp null
   ID_USER_UPDATE    int null,
	foreign key (ID_RIGHTS) references RIGHTS(ID_RIGHTS)
)

create index on RIGHTS_TEXT (ID_RIGHTS, LANGUAGE)

