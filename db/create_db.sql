users-db
========

alle Tabellen enthalten
RecordState 
DateInsert
DateUpdate
IdUserInsert
IdUserUpdate

user
----
IdUser
DisplayName
EMail
State
Type
EncryptedPassword



DOI
---
IdUser
DOIHash


App
---
IdApp
Name
Description
Useable

RefUSerApps
-----------
IdRefUSerApps
IdUser
IdApp



"Master"-DB
DELIMITER $$

create table NUMBER_RANGES (
	ID_NUMER_RANGE				int not null primary key,
	NAME							varchar(30) not null,
	MIN_NUMBER					int not null,
	CURRENT_NUMBER				int not null,
	RECORD_STATE			char(1) not null
) engine = InnoDB


insert into NUMBER_RANGES values (1, 'USER_NUBMER', 1457, 1457)


create table SYS_USER (
	ID_SYS_USER					int not null primary key,
	FIRST_NAME					nvarchar(90) not null,
	LAST_NAME					nvarchar(90) not null,
	LOGIN_NAME					nvarchar(30) not null,
	LOGIN_PASSWORD				varchar(50) not null,
	PW_VALID_FROM				date not null,
	PW_VALID_TO					date not null,
	PREFERRED_LANGUAGE		char(2) not null default 'en',
	RECORD_STATE				char(1) not null,
	IS_SYS_USER					boolean not null default false,
	DATE_INSERT					timestamp not null default '2000-01-01 00:00:00.000',
	ID_SYS_USER_INSERT		int not null, 
	DATE_UPDATE					timestamp null,
	ID_SYS_USER_UPDATE		int null,
	foreign key (ID_SYS_USER_INSERT) references SYS_USER (ID_SYS_USER),
	foreign key (ID_SYS_USER_UPDATE) references SYS_USER (ID_SYS_USER)
) engine = InnoDB


insert into SYS_USER (ID_SYS_USER, FIRST_NAME, LAST_NAME, LOGIN_NAME,       LOGIN_PASSWORD,                              PW_VALID_FROM, PW_VALID_TO,           PREFERRED_LANGUAGE, RECORD_STATE, IS_SYS_USER, DATE_INSERT, ID_SYS_USER_INSERT)
values (              1,           'SCRIPT',   'UPDATER', 'SCRIPT_UPDATER', password('ghez698Hfd34HGfd3587jHd236Kbhf6'), NOW(),         '9999-12-31 23:59:59', 'en',               'A',          true,        NOW(),       1)

insert into SYS_USER (ID_SYS_USER, FIRST_NAME, LAST_NAME, LOGIN_NAME, LOGIN_PASSWORD, PW_VALID_FROM, PW_VALID_TO,           PREFERRED_LANGUAGE, RECORD_STATE, IS_SYS_USER, DATE_INSERT, ID_SYS_USER_INSERT)
values (              0,           'SYSTEM',   'SYSTEM',  'SYSTEM',   '',             NOW(),         '9999-12-31 23:59:59', 'en',               'A',          true,        NOW(),       1)

insert into SYS_USER (ID_SYS_USER, FIRST_NAME, LAST_NAME,  LOGIN_NAME,     LOGIN_PASSWORD,                               PW_VALID_FROM, PW_VALID_TO,           PREFERRED_LANGUAGE, RECORD_STATE, IS_SYS_USER, DATE_INSERT, ID_SYS_USER_INSERT)
values (              2,           'APACHE',  'WEBSERVER', 'APACHE_LOGIN', password('ghtDfI86Fedcmloox236HfebJzdi58SD'), NOW(),         '9999-12-31 23:59:59', 'en',               'A',          true,        NOW(),       1)


create table SYS_USER_HISTORY (
	ID_SYS_USER_HISTORY	bigint not null auto_increment primary key,
	ID_SYS_USER				int not null,
	FIELD_NAME				varchar(30) not null,
	OLD_VALUE				nvarchar(200) not null,
	NEW_VALUE				nvarchar(200) not null,
	DATE_INSERT				timestamp not null,
	ID_SYS_USER_INSERT	int not null,
	foreign key (ID_SYS_USER) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER)
) engine = InnoDB


create table PASSWORD_HISTORY (
	ID_PASSWORD_HISTORY		bigint not null primary key auto_increment,
	ID_SYS_USER					int not null,
	LOGIN_PASSWORD          varchar(50) not null,
	RELEVANT						boolean not null default true,
	DATE_INSERT					timestamp not null,
	ID_SYS_USER_INSERT		int not null,
	foreign key (ID_SYS_USER) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER)
) engine = InnoDB


create function getSysUser (ID_SU int) returns int
deterministic
begin
   if (ID_SU is null) then
      select ID_SYS_USER into ID_SU from SYS_USER where LOGIN_NAME = CURRENT_USER();
   end if;
   
   if not exists (select 1 from SYS_USER where ID_SYS_USER = ID_SU and RECORD_STATE = 'A') then
      set ID_SU = 0;
   end if;
   
   if (ID_SU is null) then
      set ID_SU = 0;
   end if;
   
   return (ID_SU);
end 


create procedure spInsertSysUser (
   in  FIRST_NAME nvarchar(90),
   in  LAST_NAME nvarchar(90),
   in  LOGIN_NAME nvarchar(30),
   in  LOGIN_PASSWORD nvarchar(50),
   in  PREFERRED_LANGUAGE char(2),
   in  RECORD_STATE char(1),
   in  ID_SYS_USER_INSERT int,
   out ID_SYS_USER int
)
begin
   select getSysUser(@ID_SYS_USER_INSERT) into @ID_SYS_USER_INSERT;
   start transaction;
      select max(ID_SYS_USER) + 1 into @ID_SYS_USER;
      if (@ID_SYS_USER is null) then
         set @ID_SYS_USER = 1;
      end if;
      insert into SYS_USER ( ID_SYS_USER,  FIRST_NAME,  LAST_NAME,  LOGIN_NAME, LOGIN_PASSWORD,          PW_VALID_FROM, PW_VALID_TO,                       PREFERRED_LANGUAGE, IS_SYS_USER, RECORD_STATE, DATE_INSERT, ID_SYS_USER_INSERT)
         values (           @ID_SYS_USER, @FIRST_NAME, @LAST_NAME, @LOGIN_NAME, passwd(@LOGIN_PASSWORD), NOW(),         DATE_ADD(NOW(), INTERVAL 90 DAY), @PREFERRED_LANGUAGE, false,       'I',          NOW(),      @ID_SYS_USER_INSERT);
   commit;
end


create trigger tu_sys_user before update on SYS_USER for each row
begin
   declare ID_SYS_USER int;
   select getSysUser(NEW.ID_SYS_USER_UPDATE) into ID_SYS_USER;
   
   if (NEW.IS_SYS_USER != OLD.IS_SYS_USER) then
      SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'IS_SYS_USER is not changeable';
   end if;
   
   if (NEW.FIRST_NAME != OLD.FIRST_NAME) then
      insert into SYS_USER_HISTORY (ID_SYS_USER, FIELD_NAME, OLD_VALUE, NEW_VALUE, DATE_INSERT, ID_SYS_USER_INSERT)
         values (OLD.ID_SYS_USER, 'FIRST_NAME', OLD.FIRST_NAME, NEW.FIRST_NAME, now(), ID_SYS_USER);
   end if;
   
   if (NEW.LAST_NAME != OLD.LAST_NAME) then
      insert into SYS_USER_HISTORY (ID_SYS_USER, FIELD_NAME, OLD_VALUE, NEW_VALUE, DATE_INSERT, ID_SYS_USER_INSERT)
         values (OLD.ID_SYS_USER, 'LAST_NAME', OLD.LAST_NAME, NEW.LAST_NAME, now(), ID_SYS_USER);
   end if;
   
   if (NEW.LOGIN_NAME != OLD.LOGIN_NAME) then
      insert into SYS_USER_HISTORY (ID_SYS_USER, FIELD_NAME, OLD_VALUE, NEW_VALUE, DATE_INSERT, ID_SYS_USER_INSERT)
         values (OLD.ID_SYS_USER, 'LOGIN_NAME', OLD.LOGIN_NAME, NEW.LOGIN_NAME, now(), ID_SYS_USER);
   end if;
   
   if (NEW.LOGIN_PASSWORD != OLD.LOGIN_PASSWORD) then
      insert into PASSWORD_HISTORY (ID_SYS_USER, LOGIN_PASSWORD, RELEVANT, DATE_INSERT, ID_SYS_USER_INSERT)
         values (OLD.ID_SYS_USER, OLD.LOGIN_PASSWORD, true, now(), ID_SYS_USER);
   end if;

   if (NEW.PW_VALID_FROM != OLD.PW_VALID_FROM) then
      insert into SYS_USER_HISTORY (ID_SYS_USER, FIELD_NAME, OLD_VALUE, NEW_VALUE, DATE_INSERT, ID_SYS_USER_INSERT)
         values (OLD.ID_SYS_USER, 'PW_VALID_FROM', OLD.PW_VALID_FROM, NEW.PW_VALID_FROM, now(), ID_SYS_USER);
   end if;
   
   if (NEW.PW_VALID_TO != OLD.PW_VALID_TO) then
      insert into SYS_USER_HISTORY (ID_SYS_USER, FIELD_NAME, OLD_VALUE, NEW_VALUE, DATE_INSERT, ID_SYS_USER_INSERT)
         values (OLD.ID_SYS_USER, 'PW_VALID_TO', OLD.PW_VALID_TO, NEW.PW_VALID_TO, now(), ID_SYS_USER);
   end if;
   
   if (NEW.PREFERRED_LANGUAGE != OLD.PREFERRED_LANGUAGE) then
      insert into SYS_USER_HISTORY (ID_SYS_USER, FIELD_NAME, OLD_VALUE, NEW_VALUE, DATE_INSERT, ID_SYS_USER_INSERT)
         values (OLD.ID_SYS_USER, 'PREFERRED_LANGUAGE', OLD.PREFERRED_LANGUAGE, NEW.PREFERRED_LANGUAGE, now(), ID_SYS_USER);
   end if;                                                                                 
   
   if (NEW.RECORD_STATE != OLD.RECORD_STATE) then
      insert into SYS_USER_HISTORY (ID_SYS_USER, FIELD_NAME, OLD_VALUE, NEW_VALUE, DATE_INSERT, ID_SYS_USER_INSERT)
         values (OLD.ID_SYS_USER, 'RECORD_STATE', OLD.RECORD_STATE, NEW.RECORD_STATE, now(), ID_SYS_USER);
   end if;
end


create trigger td_sys_user before delete on SYS_USER for each row
	SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'table SYS_USER does not support deletion, update RECORD_STATE to ''D'' instead'


create table CONTACT_TYPE (
   ID_CONTACT_TYPE         int not null primary key,
   CONTACT_TYPE            nvarchar(30) not null,
   DESCRIPTION             nvarchar(10240) not null,
   REQUIRED                boolean not null default true,
   RECORD_STATE            char(1) not null
) engine = InnoDB

create table CONTACT_TYPE_TEXT (
   ID_CONTACT_TYPE_TEXT    int not null primary key auto_increment,
   ID_CONTACT_TYPE         int not null,
   LANGUAGE                char(2) not null,
   CONTACT_TYPE            nvarchar(30) not null,
   DESCRIPTION             nvarchar(10240) not null,
   RECORD_STATE            char(1) not null,
   foreign key (ID_CONTACT_TYPE) references CONTACT_TYPE (ID_CONTACT_TYPE)
) engine = InnoDB


insert into CONTACT_TYPE values (1, 'E-mail', '', true, 'A')
insert into CONTACT_TYPE values (2, 'Mobile phone', '', false, 'A')

insert into CONTACT_TYPE_TEXT (ID_CONTACT_TYPE, LANGUAGE, CONTACT_TYPE, DESCRIPTION, RECORD_STATE)
values (1, 'de', 'E-Mail', '', 'A')
insert into CONTACT_TYPE_TEXT (ID_CONTACT_TYPE, LANGUAGE, CONTACT_TYPE, DESCRIPTION, RECORD_STATE)
values (2, 'de', 'Mobil', '', 'A')


create table SYS_USER_CONTACT (
	ID_SYS_USER_CONTACT			bigint not null auto_increment primary key,
	ID_SYS_USER						int not null,
	ID_CONTACT_TYPE				int not null,
	CONTACT							nvarchar(2048) not null,
	RECORD_STATE					char(1) not null,
	DATE_INSERT						timestamp not null default '2000-01-01 00:00:00.000',
	ID_SYS_USER_INSERT			int not null,
	DATE_UPDATE						timestamp null,
	ID_SYS_USER_UPDATE			int null,
	foreign key (ID_CONTACT_TYPE) references CONTACT_TYPE (ID_CONTACT_TYPE),
	foreign key (ID_SYS_USER) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_UPDATE) references SYS_USER(ID_SYS_USER)
) engine = InnoDB



create table APP (
	ID_APP							int not null auto_increment primary key,
	APP_NAME							nvarchar(100) not null,
	INTERNAL_APP_ID				char(32) not null,
	DESCRIPTION						TEXT not null,
	WEBSITE							nvarchar(150) not null,
	
	RECORD_STATE					char(1) not null
) engine = InnoDB


create table APP_TEXT (
	ID_APP_TEXT						int not null auto_increment primary key,
	ID_APP							int not null,
	LANGUAGE							char(2) not null,
	APP_NAME							nvarchar(100) not null,
	DESCRIPTION						TEXT not null,
	foreign key (ID_APP) references APP (ID_APP)
) engine = InnoDB


create table REF_APP_SYS_USER (
	ID_REF_APP_SYS_USER			bigint not null auto_increment primary key,
	ID_APP							int not null,
	ID_SYS_USER						int not null,
	RECORD_STATE					char(1) not null,
	DATE_INSERT						timestamp not null default '2000-01-01 00:00:00.000',
	ID_SYS_USER_INSERT			int not null,
	DATE_UPDATE						timestamp null,
	ID_SYS_USER_UPDATE			int null,
	foreign key (ID_APP) references APP (ID_APP),
	foreign key (ID_SYS_USER) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_UPDATE) references SYS_USER(ID_SYS_USER)
) engine = InnoDB


create table RIGHTS (
	ID_RIGHTS						int not null primary key,
	RIGHT_NAME						varchar(50) not null,
	NAME								nvarchar(50) not null,
	DESCRIPTION						nvarchar(10240) not null,
	RECORD_STATE					char(1) not null
) engine = InnoDB


create table RIGHTS_TEXT (
	ID_RIGHTS_TEXT					int not null auto_increment primary key,
	ID_RIGHTS						int not null,
	LANGUAGE							char(2) not null,
	NAME								nvarchar(50) not null,
	DESCRIPTION						nvarchar(10240) not null,
	RECORD_STATE					char(1) not null,
	foreign key (ID_RIGHTS)	references RIGHTS(ID_RIGHTS)
) engine = InnoDB


create table REF_RIGHTS_SYS_USER (
	ID_REF_RIGHTS_SYS_USER		bigint not null auto_increment primary key,
	ID_RIGHTS						int not null,
	ID_SYS_USER						int not null,
	GRANTED							boolean not null default true,
	RECORD_STATE					char(1) not null,
	DATE_INSERT						timestamp not null default '2000-01-01 00:00:00.000',
	ID_SYS_USER_INSERT			int not null,
	DATE_UPDATE						timestamp null,
	ID_SYS_USER_UPDATE			int null,
	foreign key (ID_RIGHTS) references RIGHTS (ID_RIGHTS),
	foreign key (ID_SYS_USER) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_UPDATE) references SYS_USER(ID_SYS_USER)
) engine = InnoDB


create table GROUPS (
	ID_GROUPS						int not null primary key,
	NAME								nvarchar(50) not null,
	DESCRIPTION						nvarchar(10240) not null,
	RECORD_STATE					char(1) not null
) engine = InnoDB



create table REF_RIGHTS_GROUPS (
	ID_REF_RIGHTS_GROUPS			bigint not null auto_increment primary key,
	ID_RIGHTS						int not null,
	ID_GROUPS						int not null,
	GRANTED							boolean not null default true,
	RECORD_STATE					char(1) not null,
	DATE_INSERT						timestamp not null default '2000-01-01 00:00:00.000',
	ID_SYS_USER_INSERT			int not null,
	DATE_UPDATE						timestamp null,
	ID_SYS_USER_UPDATE			int null,
	foreign key (ID_RIGHTS) references RIGHTS (ID_RIGHTS),
	foreign key (ID_GROUPS) references GROUPS(ID_GROUPS),
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_UPDATE) references SYS_USER(ID_SYS_USER)
) engine = InnoDB


create table REF_GROUPS_SYS_USER (
	ID_REF_GROUPS_SYS_USER		bigint not null auto_increment primary key,
	ID_RIGHTS						int not null,
	ID_GROUPS						int not null,
	GRANTED							boolean not null default true,
	RECORD_STATE					char(1) not null,
	DATE_INSERT						timestamp not null default '2000-01-01 00:00:00.000',
	ID_SYS_USER_INSERT			int not null,
	DATE_UPDATE						timestamp null,
	ID_SYS_USER_UPDATE			int null,
	foreign key (ID_RIGHTS) references RIGHTS (ID_RIGHTS),
	foreign key (ID_GROUPS) references GROUPS(ID_GROUPS),
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_UPDATE) references SYS_USER(ID_SYS_USER)
) engine = InnoDB




create table SYS_USER_DATA (
	ID_SYS_USER_DATA		bigint not null primary key autoincrement,
	ID_SYS_USER				int not null,
	FIELD_NAME				varchar(30)		not null,
	VALUE						nvarchar(200)	not null,
	RECORD_STATE			char(1) not null,
	DATE_INSERT				timestamp not null,
	ID_SYS_USER_INSERT	int not null,
	DATE_UPDATE				timestamp null,
	ID_SYS_USER_UPDATE	int null,
	foreign key (ID_SYS_USER) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_UPDATE) references SYS_USER(ID_SYS_USER)
) engine = InnoDB;



create table USER_CONTACT (
	ID_USER_CONTACT			bigint not null primary key auto_increment,
	ID_REGISTERED_USER		int not null,
	ID_CONTACT_TYPE			int not null,
	CONTACT						nvarchar(128) not null,
	DOI_SENT_DATE				datetime null,
	DOI_HASH						nvarchar(50) null,
	DOI_CONFIRM					timestamp null
	
	RECORD_STATE			char(1) not null,
	DATE_INSERT				timestamp not null,
	ID_SYS_USER_INSERT	int not null,
	DATE_UPDATE				timestamp null,
	ID_SYS_USER_UPDATE	int null,
	foreign key (ID_SYS_USER_INSERT) references SYS_USER(ID_SYS_USER),
	foreign key (ID_SYS_USER_UPDATE) references SYS_USER(ID_SYS_USER),
	foreign key (ID_CONTACT_TYPE) references CONTACT_TYPE (ID_CONTACT_TYPE)
) engine = InnoDB;


create table LANGUAGE (
	ID_LANGUAGE				int not null primary key,
	LANGUAGE					char(2) not null,
	DESCRIPTION				nvarchar(50) not null,
	RECORD_STATE			char(1) not null
) engine = InnoDB;


insert into LANGUAGE values (1, 'en', 'english', 'A')
insert into LANGUAGE values (2, 'de', 'german', 'A')

create table LANGUAGE_TEXT (
	ID_LANGUAGE_TEXT		bigint not null auto_increment primary key,
	ID_LANGUAGE				int not null,
	LANGUAGE					char(2) not null,
	DESCRIPTION				nvarchar(50) not null,
	RECORD_STATE			char(1),
	foreign key (ID_LANGUAGE) references LANGUAGE(ID_LANGUAGE)
) engine = InnoDB;

insert into LANGUAGE_TEXT (ID_LANGUAGE, LANGUAGE, DESCRIPTION, RECORD_STATE) values (1, 'de', 'englisch', 'A')
insert into LANGUAGE_TEXT (ID_LANGUAGE, LANGUAGE, DESCRIPTION, RECORD_STATE) values (2, 'de', 'deutsch', 'A')

