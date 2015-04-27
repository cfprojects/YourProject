<cfcomponent>
<cffunction name="Init">
	<cfargument name="form">
	<cfset Variables.Datasource = form.Datasource>
	<cfset Variables.PgmID = form.PgmID>
	<!--- Don't set Variables.Database because it would create a recursive function --->
	<cfreturn this>
</cffunction>

<cffunction name="WhereFuncName">
	<cfargument name="form">
	<cfset var local = {}>

	<cfquery name="local.qry" datasource="#Variables.Datasource#">
	DECLARE @FuncID Int=0
	SELECT @FuncID=FuncID FROM Log.Func
	WHERE Func_PgmID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Variables.PgmID#">
	AND FuncName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FuncName#">
	IF @FuncID = 0 BEGIN
		INSERT INTO Log.Func(Func_PgmID,FuncName,Func_FieldID) VALUES(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Variables.PgmID#">
			,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FuncName#">
			,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FieldID#">
		);
		SELECT @FuncID = SCOPE_IDENTITY()
	END
	SELECT *	FROM Log.Func
	WHERE FuncID=@FuncID
	</cfquery>
	<cfreturn local.qry>
</cffunction>

<cffunction name="CleanSlate">
	<cfquery datasource="#Variables.Datasource#">
	DELETE FROM Log.Func
	</cfquery>
</cffunction>
</cfcomponent>