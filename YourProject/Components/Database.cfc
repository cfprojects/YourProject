<cfcomponent output="false">
<cffunction name="Init">
	<cfargument name="form" hint="Datasource and PgmID">
	<cfset var local = {}>

	<cfset Variables.Datasource = form.Datasource>
	<cfset local.Datasource = Variables.Datasource>
	<cfset Variables.Log.Pgm = createObject("component","Log.Pgm").Init(local)>
	<cfset Variables.Log.Field = createObject("component","Log.Field").Init(local)>
	<cfset local.PgmID = form.PgmID>
	<cfset Variables.Log.Func = createObject("component","Log.Func").Init(local)>
	<cfset Variables.Log.Error = createObject("component","Log.Error").Init(local)>
	<cfset Variables.qryFunc = {}>
	<cfreturn this>
</cffunction>

<cffunction name="Where" hint="I return .Criteria, .rethrow, .logErrors, .TraceID">
	<cfargument name="form">
	<cfset var local = {}>

	<cfset local.result = {}>
	<cfset local.result.Criteria = "">
	<cfset local.result.rethrow = 1>
	<cfset local.result.TraceID = 0>
	<cfset local.result.LogErrors = 1>

	<cfif NOT StructKeyExists(form,"FieldName")>
		<!--- Just log which pgm --->
		<cfset local.FieldName = "">
		<cfset local.FieldValue = "0">
	<cfelseif NOT IsNumeric(form.FieldValue)>
		<!--- Not a number --->
		<cfset local.FieldName = form.FieldName>
		<cfset local.FieldValue = 0>
	<cfelse>
		<cfset local.FieldName = form.FieldName>
		<cfset local.FieldValue = form.FieldValue>
	</cfif>
	<cfset local.UsrID = 0>
	<cfif isDefined("session")>
		<cfif StructKeyExists(session,"UsrID")>
			<cfset local.UsrID = session.UsrID>
		</cfif>
	</cfif>
	<cfif StructKeyExists(Variables.qryFunc,form.FuncName)>
		<cfset local.qryFunc = Variables.qryFunc["#form.FuncName#"]>
	<cfelse>
		<cfset local.qryField = Variables.Log.Field.WhereFieldName(local.FieldName)>
		<cfset local.FieldID = local.qryField.FieldID>
		<cfset local.FuncName = form.FuncName>
		<cfset local.qryFunc = Variables.Log.Func.WhereFuncName(local)>
		<cfset Variables.qryFunc["#form.FuncName#"] = local.qryFunc> <!--- Keep a copy in cache --->
	</cfif>
	<cfif local.qryFunc.Logged>
		<cfset local.PgmName = GetBaseTemplatePath()>
		<cfset local.PgmName = Replace(local.PgmName,"C:\inetpub\wwwroot\YourProject\","")>
		<cfset local.PgmName = Replace(local.PgmName,"C:\Websites\181554Ky2\YourProject\","")>
		<cfset local.PgmID = Variables.Log.Pgm.WherePgmName(local.PgmName)>
		<!--- Don't put this in Trace.cfc because it would be a recursive call --->
		<cfquery name="local.qry" datasource="#Variables.Datasource#">
		INSERT INTO Log.Trace(Trace_UsrID,Trace_PgmID,Trace_FuncID,Trace_FK) VALUES(
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#local.UsrID#">
		,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.PgmID#">
		,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.qryFunc.FuncID#">
		,<cfqueryparam cfsqltype="cf_sql_integer" value="#local.FieldValue#">
		);
		SELECT * FROM Log.Trace
		WHERE TraceID=SCOPE_IDENTITY()
		</cfquery>
		<cfset local.result.TraceID = local.qry.TraceID> <!--- Used by the .Stop function --->
	</cfif>
	<cfset local.result.rethrow = local.qryFunc.rethrow> <!--- Used by the calling function --->
	<cfset local.result.LogErrors = local.qryFunc.LogErrors> <!--- Used in Database.CatchError --->
	<cfif NOT StructKeyExists(form,"FieldName")>
	<cfelseif IsNumeric(form.FieldValue)>
		<cfset local.result.Criteria = "WHERE #local.FieldName# = #local.FieldValue#">
	<cfelse>
		<cfoutput>Invalid Key: #local.FieldName# = #local.FieldValue#</cfoutput>
		<cfabort>
	</cfif>
	<cfreturn local.result>
</cffunction>

<cffunction name="Stop">
	<cfargument name="TraceID">
	<cfset var local = {}>

	<cfif arguments.TraceID>
		<cftry>
			<cfquery datasource="#Variables.Datasource#">
			UPDATE Log.Trace SET
			StopTime = getdate()
			WHERE TraceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TraceID#">
			</cfquery>
			<cfcatch>
				<cfset local.dbs = {}>
				<cfset local.dbs.LogError = 1>
				<cfset local.catch = cfcatch>
				<cfset CatchError(local)>
			</cfcatch>
		</cftry>
	</cfif>
</cffunction>

<cffunction name="Delete">
	<cfset var local = {}>

	<cfset local.FuncName = "Delete">
	<cfset local.FieldName = StructKeyList(arguments)>
	<cfset local.FieldValue = Evaluate("arguments.#local.PK#")>
	<cfset local.dbs = Where(local)>
	<cfset local.result = "">
	<cfset local.PK = StructKeyList(arguments)>
	<cfset local.ID = Evaluate("arguments.#local.PK#")>
	<cfset local.Tablename = LEFT(local.PK,Len(local.PK)-2)>
	<cfif IsNumeric(local.ID)>
		<cftry>
			<cfquery datasource="#Variables.Datasource#">
			DELETE FROM #local.Tablename#
			WHERE #local.PK# = #local.ID#
			</cfquery>
			<cfcatch>
				<cfset local.catch = cfcatch>
				<cfset local.result = CatchError(local)>
			</cfcatch>
		</cftry>
	<cfelse>
		<cfset local.result = "#local.ID# is not numeric">
	</cfif>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
	<cfreturn local.result>
</cffunction>

<cffunction name="CatchError" output="yes">
	<cfargument name="form" hint="Catch, dbs.LogErrors">
	<cfset var local = {}>

	<cfset local.result = form.Catch.Detail>
	<cfif FINDNOCASE("The DELETE statement conflicted with the REFERENCE constraint",local.result)>
		<cfset local.result = "There are records that depend on this entry.  They need to be deleted first.">
	<cfelseif local.result EQ "">
		<cfset local.result = arguments.Catch.Message>
	</cfif>
	<cfset local.result=Replace(local.result,'[Macromedia]','','ALL')>
	<cfset local.result=Replace(local.result,'[SQLServer JDBC Driver]','','ALL')>
	<cfset local.result=Replace(local.result,'[SQLServer]','','ALL')>
	<cfset local.result=Replace(local.result,"The cause of this output exception was that: coldfusion.runtime.","","ALL")>
	<cfset local.result=Replace(local.result,"Cast$DateStringConversionException: ","","ALL")>
	<cfif local.result EQ "">
		<cfset local.result = "An unknown error has occurred.">
	</cfif>
	<cfif form.dbs.LogErrors>
		<cfset Variables.Log.Error.Save(form.Catch)>
	</cfif>
	<cfreturn local.result>
</cffunction>

<cffunction name="CleanSlate">
	<cfset Variables.Log.Field.CleanSlate()>
	<cfset Variables.Log.Func.CleanSlate()>
	<cfset Variables.Log.Pgm.CleanSlate()>
	<cfset Variables.qryFunc = {}>
</cffunction>
</cfcomponent>