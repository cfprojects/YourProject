<cfoutput>
<cfset qryUsr = Application.dbo.Usr.WhereUsrID()>
<cfinclude template="/YourProject/Inc/html.cfm">
<cfinclude template="/YourProject/Inc/head.cfm">
<title>Usr Table</title>
<cfinclude template="/YourProject/Inc/body.cfm">
<cfinclude template="/YourProject/Inc/nav.cfm">
<table class="border">
	<thead>
	<tr>
		<th>Action</th>
		<th>User Name</th>
	</tr>
	</thead>
	<tbody>
		<cfloop query="qryUsr">
			<tr>
				<td><a href="UsrEdit.cfm?UsrID=#UsrID#">Edit<a></td>
				<td>#UsrName#</td>
			</tr>
		</cfloop>
		<tr>
			<td><a href="UsrEdit.cfm?Create">Add</a></td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>
<cfinclude template="/YourProject/Inc/Footer.cfm">
</cfoutput>