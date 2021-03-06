<cfcomponent>
<cffunction name="Init">
	<cfargument name="form">
	<cfset var local = {}>

	<cfset Variables.Datasource = form.Datasource>
	<cfset local.Datasource = form.Datasource>
	<cfset local.Pgm = CreateObject("component","Log.Pgm").Init(local)>
	<cfset local.ComponentName = listLast(getCurrentTemplatePath(),"\")>
	<cfset local.PgmID = local.Pgm.WherePgmName(local.ComponentName)>
	<cfset Variables.Database = CreateObject("component","Database").Init(local)>
	<cfset local.FuncName = "Init">
	<cfset local.dbs = Variables.Database.Where(local)>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
	<cfreturn this>
</cffunction>

<cffunction name="View1">
	<cfset var local = {}>

	<cfset local.FuncName = "View1">
	<cfset local.dbs = Variables.Database.Where(local)>
	<cftry>
		<cfquery name="local.qry" datasource="#Variables.Datasource#">
		SELECT *
		FROM Log.TraceView
		#local.dbs.Criteria#
		ORDER BY TraceID DESC
		</cfquery>
		<cfcatch>
			<cfif local.dbs.rethrow>
				<cfrethrow>
			<cfelse>
				<cfset local.catch = cfcatch>
				<cfset local.qry = Variables.Database.CatchError(local)>
			</cfif>
		</cfcatch>
	</cftry>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
	<cfreturn local.qry>
</cffunction>

<cffunction name="CleanSlate">
	<cfset var local = {}>

	<cfset local.FuncName = "CleanSlate">
	<cfset local.dbs = Variables.Database.Where(local)>
	<cftry>
		<cfquery name="local.qry" datasource="#Variables.Datasource#">
		DELETE FROM log.Trace
		</cfquery>
		<cfcatch>
			<cfif local.dbs.rethrow>
				<cfrethrow>
			<cfelse>
				<cfset local.catch = cfcatch>
				<cfset local.qry = Variables.Database.CatchError(local)>
			</cfif>
		</cfcatch>
	</cftry>
	<cfset Variables.Database.CleanSlate()>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
</cffunction>
</cfcomponent>