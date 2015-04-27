<cfcomponent>
<cffunction name="Init">
	<cfargument name="form">
	<cfset Variables.Datasource = form.Datasource>
	<!--- Don't set Variables.Database because it would create a recursive function --->
	<cfreturn this>
</cffunction>

<cffunction name="WhereFieldName">
	<cfargument name="FieldName">
	<cfset var local = {}>

	<cfset local.result = {}>
	<cfquery name="local.qry" datasource="#Variables.Datasource#">
	DECLARE @FieldID Int=0
	SELECT @FieldID=FieldID FROM Log.Field
	WHERE FieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FieldName#">
	IF @FieldID = 0 BEGIN
		INSERT INTO Log.Field(FieldName) VALUES(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FieldName#">
		);
		SELECT @FieldID = SCOPE_IDENTITY()
	END
	SELECT * FROM Log.Field
	WHERE FieldID = @FieldID
	</cfquery>
	<cfreturn local.qry>
</cffunction>

<cffunction name="CleanSlate">
	<cfquery datasource="#Variables.Datasource#">
	DELETE FROM Log.Field
	</cfquery>
</cffunction>
</cfcomponent>