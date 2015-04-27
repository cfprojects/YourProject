<cfoutput>
<cfset Variables.Trace = createObject("component","Log.Trace").Init(Application.Log)>
<cfset qryTrace = Variables.Trace.View1()>
<cfinclude template="/YourProject/Inc/html.cfm">
<cfinclude template="/YourProject/Inc/head.cfm">
<title>Audit Trace</title>
<cfinclude template="/YourProject/Inc/body.cfm">
<table class="border">
	<thead>
	<tr>
		<th>ID</th>
		<th>UsrName</th>
		<th>Program</th>
		<th>Component</th>
		<th>Function</th>
		<th>Start Time</th>
		<th>Stop Time</th>
		<th>Field</th>
		<th>ID</th>
	</tr>
	</thead>
	<tbody>
		<cfloop query="qryTrace">
			<tr>
				<td>#TraceID#</td>
				<td>#UsrName#</td>
				<td>#PgmName#</td>
				<td>#ComponentName#</td>
				<td>#FuncName#</td>
				<td>#StartTime#</td>
				<td>#StopTime#</td>
				<td>#FieldName#</td>
				<td>#Trace_FK#</td>
			</tr>
		</cfloop>
	</tbody>
</table>
<cfinclude template="/YourProject/Inc/Footer.cfm">
</cfoutput>