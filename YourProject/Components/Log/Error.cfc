<cfcomponent>
<cffunction name="Init">
	<cfargument name="form">
	<cfset Variables.Datasource = form.Datasource>
	<!--- Don't set Variables.Database because it would create a recursive function --->
	<cfreturn this>
</cffunction>

<cffunction name="Save">
	<cfargument name="form">
	<cfset var local = {}>

	<cfdump var="#form#">
	<cfabort>
	<cfquery datasource="#Variables.Datasource#">

	</cfquery>
</cffunction>

<cffunction name="CleanSlate">
	<cfquery datasource="#Variables.Datasource#">
	DELETE FROM Log.Error
	</cfquery>
</cffunction>
</cfcomponent>