-- use Tempdb
-- ALTER DATABASE YourProject SET ANSI_NULL_DEFAULT OFF;
-- use YourProject
-- EXEC sp_defaultdb @loginame='phillip', @defdb = 'YourProject'
set nocount on
set statistics time off
set statistics io off
SET ANSI_NULL_DFLT_ON OFF
SET ANSI_WARNINGS ON -- if null values appear in aggregate functions, such as SUM, AVG, MAX, MIN, STDEV, STDEVP, VAR, VARP, or COUNT, a warning message is generated.
SET ARITHABORT ON -- Terminates a query when an overflow or divide-by-zero error occurs during query execution.
--
-- Log every time a function is called
--
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'log.Error') AND type in (N'U'))
DROP TABLE log.Error
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'log.Trace') AND type in (N'U'))
DROP TABLE log.Trace
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'log.Func') AND type in (N'U'))
DROP TABLE log.Func
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'log.Field') AND type in (N'U'))
DROP TABLE log.Field
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'log.Pgm') AND type in (N'U'))
DROP TABLE log.Pgm
GO
--
-- dbo tables
--
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Ctrl') AND type in (N'U'))
DROP TABLE dbo.Ctrl
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Usr') AND type in (N'U'))
DROP TABLE dbo.Usr
GO

CREATE TABLE dbo.Usr(
UsrID Int Identity(10,1) CONSTRAINT UsrID Primary Key,
UsrName Varchar(128),
UsrPassword Varchar(128),
Usr_UsrID Int -- An unfortunate coincidence.  This is the user that last updated this user.
)
GO
CREATE UNIQUE INDEX UsrName ON Usr(UsrName)
INSERT INTO Usr(Usrname,UsrPassword,Usr_UsrID) VALUES('admin','admin',0)
GO
CREATE TABLE dbo.Ctrl(
CtrlID Int Identity(100,1) Constraint CtrlID Primary Key
,CtrlName Varchar(128)
,CtrlDesc Varchar(128)
,CtrlDate DateTime NULL
,CtrlInt Int
,Ctrl_UsrID Int
)
GO
ALTER TABLE dbo.Ctrl
	ADD CONSTRAINT CtrlDate Default getdate() FOR CtrlDate
ALTER TABLE dbo.Ctrl
	ADD CONSTRAINT CtrlInt Default 0 FOR CtrlInt
ALTER TABLE dbo.Ctrl
	ADD CONSTRAINT Ctrl_UsrID Foreign Key(Ctrl_UsrID) References dbo.Usr(UsrID)
GO
CREATE INDEX CtrlName ON Ctrl(CtrlName)
CREATE UNIQUE INDEX CtrlNameDesc ON Ctrl(CtrlName,CtrlDesc)
GO
DECLARE @UsrID Int
SELECT @UsrID=UsrID FROM Usr WHERE UsrName='admin'
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','Any',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','Application',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','Database',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','Expression',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','Lock',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','MissingInclude',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','Object',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','Security',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','Template',@UsrID)
INSERT INTO Ctrl(CtrlName,CtrlDesc,Ctrl_UsrID) VALUES('Exception Type','SearchEngine',@UsrID)
GO
-- CREATE SCHEMA Log
CREATE TABLE log.Error(
ErrorID Int Identity(-10,1) Constraint ErrorID Primary Key
,ErrorType Int
,ErrorMessage Varchar(Max)
,Detail Varchar(Max)
,SQLState Varchar(Max)
,SQLString Varchar(Max)
,QueryError Varchar(Max)
,WhereClause Varchar(Max)
,NativeErrorCode Int
,ErrNumber Int
,MissingFileName Varchar(Max)
,Lockname Varchar(Max)
,LockOperation Varchar(Max)
,ErrorCode Int default 0
,ExtendedInfo Varchar(Max) default ''
,TagContext Varchar(Max)
)
GO
CREATE TABLE log.Pgm(
PgmID Int Identity(10,1) Constraint PgmID Primary Key
,PgmName Varchar(128)
)
GO
INSERT INTO log.Pgm(PgmName) VALUES('')
GO
CREATE TABLE log.Field(
FieldID Int Identity(100,1) Constraint FieldID Primary Key
,FieldName Varchar(128)
)
GO
INSERT INTO log.Field(FieldName) VALUES('')
GO
CREATE TABLE log.Func(
FuncID Int Identity(1000,1) Constraint FuncID Primary Key
,Func_PgmID Int
,FuncName Varchar(128)
,Func_FieldID Int
,Logged Bit
,Rethrow Bit
,LogErrors Bit
)
GO
ALTER TABLE log.Func
	ADD CONSTRAINT Default_Func_PgmID default 10 FOR Func_PgmID;
ALTER TABLE log.Func
	ADD CONSTRAINT Default_Func_FieldID default 100 FOR Func_FieldID;
ALTER TABLE log.Func
	ADD CONSTRAINT Logged default 1 FOR Logged;
ALTER TABLE log.Func
	ADD CONSTRAINT Rethrow default 0 FOR Rethrow;
ALTER TABLE log.Func
	ADD CONSTRAINT LogErrors default 1 FOR LogErrors;
	
ALTER TABLE log.Func
	ADD CONSTRAINT Func_PgmID foreign key(Func_PgmID) references log.Pgm(PgmID);
ALTER TABLE log.Func
	ADD CONSTRAINT Func_FieldID foreign key(Func_FieldID) references log.Field(FieldID);
	
INSERT INTO log.Func(FuncName) VALUES('')
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'log.FuncView'))
DROP VIEW log.FuncView
GO
CREATE VIEW log.FuncView AS
SELECT Func.* 
,PgmName AS ComponentName
,Field.*
FROM Log.Func
JOIN Log.Pgm
ON Func_PgmID=PgmID
JOIN Log.Field
ON Func_FieldID = FieldID
GO

CREATE TABLE log.Trace(
TraceID Int Identity(10000,1) Constraint TraceID Primary Key
,Trace_UsrID Int
,Trace_PgmID Int
,Trace_FuncID Int
,StartTime DateTime
,StopTime Datetime null
,Trace_FK Int -- Foreign Key to the table referenced in PgmName.
-- Log_FormID Int default 0
)
GO
ALTER TABLE log.Trace
	ADD CONSTRAINT Default_UsrID default 0 FOR Trace_UsrID;
ALTER TABLE log.Trace
	ADD CONSTRAINT Default_FuncID default 0 FOR Trace_FuncID;
ALTER TABLE log.Trace
	ADD CONSTRAINT Default_StartTime default getdate() FOR StartTime;
ALTER TABLE log.Trace
	ADD CONSTRAINT Default_FK default 0 FOR Trace_FK;


ALTER TABLE log.Trace
	ADD CONSTRAINT Trace_FuncID foreign key(Trace_FuncID) references log.Func(FuncID)
ALTER TABLE log.Trace
	ADD CONSTRAINT Trace_PgmID foreign key(Trace_PgmID) references log.Pgm(PgmID)
GO
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'log.TraceView'))
DROP VIEW log.TraceView
GO
CREATE VIEW log.TraceView AS
SELECT Trace.* 
,Pgm.*
,FuncView.*
,Usr.*
FROM log.Trace
LEFT JOIN Log.Pgm
ON Trace_PgmID = PgmID
JOIN log.FuncView
ON Trace_FuncID=FuncID
LEFT JOIN dbo.Usr
ON Trace_UsrID = UsrID
GO
--
-- Audit every time a row is changed
--
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Audit.AuditType') AND type in (N'U'))
DROP TABLE Audit.AuditType
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Audit.Usr') AND type in (N'U'))
DROP TABLE Audit.Usr
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'Audit.UsrView'))
DROP View Audit.UsrView
--IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Audit')
--DROP SCHEMA Audit
GO
--CREATE SCHEMA Audit AUTHORIZATION dbo
GO
CREATE TABLE Audit.AuditType(
AuditTypeID Int Identity(1,1) Constraint AuditTypeID Primary Key
,AuditTypeName Varchar(128)
,AuditTypeDesc Varchar(128)
,AuditTypeSort Int default 0
)
GO
INSERT INTO Audit.AuditType(AuditTypeName,AuditTypeSort,AuditTypeDesc) VALUES('Insert',1,'Insert')
INSERT INTO Audit.AuditType(AuditTypeName,AuditTypeSort,AuditTypeDesc) VALUES('Change',2,'Old Value')
INSERT INTO Audit.AuditType(AuditTypeName,AuditTypeSort,AuditTypeDesc) VALUES('New Value',3,'New Value')
INSERT INTO Audit.AuditType(AuditTypeName,AuditTypeSort,AuditTypeDesc) VALUES('Delete',4,'Delete')
GO

CREATE TABLE Audit.Usr(
AuditUsrID Int Identity(-2147483648,1) Primary Key NONCLUSTERED
,UsrID Int
,UsrName Varchar(128)
,UsrPassword Varchar(128)
,Usr_UsrID Int default 0 -- This is the user that last updated this row.
,AuditUsrDate DateTime default getdate()
,AuditUsr_AuditTypeID Int
)
GO
CREATE CLUSTERED INDEX UsrID ON Audit.Usr(UsrID)
CREATE INDEX Usr_UsrID ON Audit.Usr(Usr_UsrID)
GO
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'dbo.AuditInsert_Usr'))
DROP TRIGGER dbo.AuditInsert_Usr
GO
CREATE Trigger AuditInsert_Usr ON dbo.Usr AFTER Insert
NOT FOR REPLICATION AS
INSERT INTO Audit.Usr(AuditUsr_AuditTypeID,
UsrID,UsrName,UsrPassword,Usr_UsrID)
SELECT 1,
UsrID,UsrName,UsrPassword,Usr_UsrID
FROM Inserted
GO

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'dbo.AuditUpdate_Usr'))
DROP TRIGGER dbo.AuditUpdate_Usr
GO
CREATE Trigger AuditUpdate_Usr ON dbo.Usr AFTER Update
NOT FOR REPLICATION AS
INSERT INTO Audit.Usr(AuditUsr_AuditTypeID,
UsrID,UsrName,UsrPassword,Usr_UsrID)
SELECT 2,
Deleted.UsrID,Deleted.UsrName,Deleted.UsrPassword,Deleted.Usr_UsrID
FROM Inserted
JOIN Deleted
ON Inserted.UsrID = Deleted.UsrID
WHERE Inserted.UsrName  <> Deleted.UsrName
OR Inserted.UsrPassword <> Deleted.UsrPassword
OR Inserted.Usr_UsrID   <> Deleted.Usr_UsrID;
INSERT INTO Audit.Usr(AuditUsr_AuditTypeID,
UsrID,UsrName,UsrPassword,Usr_UsrID)
SELECT 3,
Inserted.UsrID,Inserted.UsrName,Inserted.UsrPassword,Inserted.Usr_UsrID
FROM Inserted
JOIN Deleted
ON Inserted.UsrID = Deleted.UsrID
WHERE Inserted.UsrName  <> Deleted.UsrName
OR Inserted.UsrPassword <> Deleted.UsrPassword
OR Inserted.Usr_UsrID   <> Deleted.Usr_UsrID;
GO

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'dbo.AuditDelete_Usr'))
DROP TRIGGER dbo.AuditDelete_Usr
GO
CREATE Trigger AuditDelete_Usr ON dbo.Usr AFTER Delete
NOT FOR REPLICATION AS
INSERT INTO Audit.Usr(AuditUsr_AuditTypeID,
UsrID,UsrName,UsrPassword,Usr_UsrID)
SELECT 4,
UsrID,UsrName,UsrPassword,Usr_UsrID
FROM Deleted
GO
CREATE VIEW Audit.UsrView AS
SELECT Audit.Usr.*
,AuditType.*
,UpdatedBy.UsrName AS UpdatedByUsrName
FROM Audit.Usr
JOIN dbo.Usr UpdatedBy
ON Audit.Usr.Usr_UsrID = UpdatedBy.UsrID
JOIN Audit.AuditType
ON AuditUsr_AuditTypeID = AuditTypeID
GO
--DECLARE @UsrID Int
--SELECT @UsrID=UsrID FROM Usr WHERE UsrName='admin'
--INSERT INTO Usr(Usrname,UsrPassword,Usr_UsrID) VALUES('John Doe','password',@UsrID)
--UPDATE Usr SET UsrName='Harold Schlecklemeyer' WHERE UsrName='John Doe'
--DELETE Usr WHERE UsrName='Harold Schlecklemeyer'
GO
SELECT * FROM Log.Pgm
SELECT * FROM Log.Field
SELECT * FROM Log.FuncView
SELECT * FROM Log.TraceView
SELECT * FROM dbo.Ctrl
SELECT * FROM dbo.Usr
SELECT * FROM Audit.UsrView
