<cfoutput>
<cfset objUsr = createObject("component","Audit.Usr").Init(Application.Audit)>
<cfset qryUsr = objUsr.View1()>
<cfinclude template="/YourProject/Inc/html.cfm">
<cfinclude template="/YourProject/Inc/head.cfm">
<title>Audit Usr</title>
<cfinclude template="/YourProject/Inc/body.cfm">
If the diagnostic has been run, then you can see that John Doe was added,
then changed his name to Harold Schlecklemeyer and finally, was deleted.
<table>
	<thead>
	<tr>
		<th>UsrID</th>
		<th>UsrName</th>
		<th>Updated by</th>
		<th>Date</th>
		<th>Audit Code</th>
	</tr>
	</thead>
	<tbody>
		<cfloop query="qryUsr">
			<tr>
				<td>#UsrID#</td>
				<td>#UsrName#</td>
				<td>#UpdatedByUsrName#</td>
				<td>#AuditUsrDate#</td>
				<td>#AuditTypeDesc#</td>
			</tr>
		</cfloop>
	</tbody>
</table>
This information is tracked automatically by the database using triggers:
<pre>
CREATE Trigger AuditInsert_Usr ON dbo.Usr AFTER Insert
NOT FOR REPLICATION AS
INSERT INTO Audit.Usr(AuditUsr_AuditTypeID,
UsrID,UsrName,UsrPassword,Usr_UsrID)
SELECT 1,
UsrID,UsrName,UsrPassword,Usr_UsrID
FROM Inserted
GO
</pre>
<pre>
CREATE Trigger AuditDelete_Usr ON dbo.Usr AFTER Delete
NOT FOR REPLICATION AS
INSERT INTO Audit.Usr(AuditUsr_AuditTypeID,
UsrID,UsrName,UsrPassword,Usr_UsrID)
SELECT 4,
UsrID,UsrName,UsrPassword,Usr_UsrID
FROM Deleted
GO
</pre>
The code for the update is little bit more complicated because we only want to audit a change if
a field was actually changed.<br />
To do so, I compare the Inserted table vs. the Deleted table to see if any of the fields are not equal.
<pre>
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
</pre>
<cfinclude template="/YourProject/Inc/Footer.cfm">
</cfoutput>