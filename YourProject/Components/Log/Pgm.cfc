<cfcomponent>
<cffunction name="Init">
	<cfargument name="form">
	<cfset Variables.Datasource = form.Datasource>
	<cfset Variables.Pgm = {}>
	<cfreturn this>
</cffunction>

<cffunction name="WherePgmName">
	<cfargument name="PgmName">
	<cfset var local = {}>

	<cfif structKeyExists(Variables.Pgm,arguments.PgmName)>
	<cfelse>
		<cfquery name="local.qry" datasource="#Variables.Datasource#">
		IF EXISTS(
			SELECT * FROM Log.Pgm
			WHERE PgmName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PgmName#">)
			SELECT * FROM Log.Pgm
			WHERE PgmName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PgmName#">
		ELSE BEGIN
			INSERT INTO Log.Pgm(PgmName) VALUES(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PgmName#">
			)
			SELECT * FROM Log.Pgm
			WHERE PgmID = SCOPE_IDENTITY()
		END
		</cfquery>
		<cfset Variables.Pgm[arguments.PgmName] = local.qry.PgmID>
	</cfif>
	<cfreturn Variables.Pgm[arguments.PgmName]>
</cffunction>

<cffunction name="CleanSlate">
	<cfquery datasource="#Variables.Datasource#">
	DELETE FROM Log.Pgm
	</cfquery>
</cffunction>
</cfcomponent>