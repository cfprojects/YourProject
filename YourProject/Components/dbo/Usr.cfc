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

<cffunction name="WhereUsrID">
	<cfargument name="UsrID">
	<cfset var local = {}>

	<cfset local.FuncName = "WhereUsrID">
	<cfif structKeyExists(arguments,"UsrID")>
		<cfset local.FieldName = "UsrID">
		<cfset local.FieldValue = arguments.UsrID>
	</cfif>
	<cfset local.dbs = Variables.Database.Where(local)>
	<cftry>
		<cfquery name="local.qry" datasource="#Variables.Datasource#">
		SELECT * FROM Usr
		#local.dbs.Criteria#
		ORDER BY UsrName
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

<cffunction name="Login">
	<cfargument name="form">
	<cfset var local = {}>

	<cfset local.FuncName = "Login">
	<cfset local.dbs = Variables.Database.Where(local)>
	<cftry>
		<cfquery name="local.qry" datasource="#Variables.Datasource#">
		SELECT * FROM Usrx
		WHERE UsrName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.j_Username#">
		AND UsrPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.j_Password#">
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

<cffunction name="Save">
	<cfargument name="form">
	<cfset var local = {}>

	<cfset local.FuncName = "Save">
	<cfset local.FieldName = "UsrID">
	<cfset local.FieldValue= form.UsrID>
	<cfset local.dbs = Variables.Database.Where(local)>
	<cfset local.result = "">
	<cfif form.UsrID>
		<cftry>
			<cfquery name="local.qry" datasource="#Variables.Datasource#">
			UPDATE Usr SET
			 UsrName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.j_Username#">
			,UsrPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.j_Password#">
			,Usr_UsrID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Usr_UsrID#">
			WHERE UsrID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.UsrID#">
			</cfquery>
			<cfcatch>
				<cfif local.dbs.rethrow>
					<cfrethrow>
				<cfelse>
					<cfset local.catch = cfcatch>
					<cfset local.result = Variables.Database.CatchError(local)>
				</cfif>
			</cfcatch>
		</cftry>
	<cfelse>
		<cftry>
			<cfquery name="local.qry" datasource="#Variables.Datasource#">
			INSERT INTO Usr(UsrName,UsrPassword,Usr_UsrID) VALUES(
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.j_Username#">
			,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.j_Password#">
			,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Usr_UsrID#">
			);
			SELECT * FROM Usr
			WHERE UsrID = Scope_Identity()
			</cfquery>
			<!--- Todo: return in local.result --->
			<cfset form.UsrID = local.qry.UsrID>
			<cfcatch>
				<cfif local.dbs.rethrow>
					<cfrethrow>
				<cfelse>
					<cfset local.catch = cfcatch>
					<cfset local.result = Variables.Database.CatchError(local)>
				</cfif>
			</cfcatch>
		</cftry>
	</cfif>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
	<cfreturn local.result>
</cffunction>

<cffunction name="Delete">
	<cfargument name="form">
	<cfset var local = {}>

	<cfset local.FuncName = "Delete">
	<cfset local.FieldName = "UsrID">
	<cfset local.FieldValue= form.UsrID>
	<cfset local.dbs = Variables.Database.Where(local)>
	<cfset local.result = "">
	<cftry>
		<cfquery datasource="#Variables.Datasource#">
		DELETE Usr
		WHERE UsrID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.UsrID#">
		</cfquery>
		<cfcatch>
			<cfif local.dbs.rethrow>
				<cfrethrow>
			<cfelse>
				<cfset local.catch = cfcatch>
				<cfset local.result = Variables.Database.CatchError(local)>
			</cfif>
		</cfcatch>
	</cftry>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
	<cfreturn local.result>
</cffunction>

<cffunction name="CleanSlate">
	<cfquery name="local.qry" datasource="#Variables.Datasource#">
	DELETE FROM Usr
	WHERE UsrName <> 'admin'
	</cfquery>
</cffunction>
</cfcomponent>