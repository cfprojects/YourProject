<cfcomponent>
<cffunction name="IsQry">
	<cfargument name="Qry">
	<cfset var local = {}>

	<cfif isQuery(arguments.qry)>
		<cfset local.result = 1>
	<cfelse>
		<cfset local.result = 0>
	</cfif>
	<cfreturn local.result>
</cffunction>

<cffunction name="qryMsg">
	<cfargument name="Qry">
	<cfset var local = {}>

	<cfif isQuery(arguments.Qry)>
		<cfset local.result = "">
	<cfelse>
		<cfset local.result = arguments.Qry>
	</cfif>
	<cfreturn local.result>
</cffunction>

<cffunction name="isEmpty">
	<cfargument name="Msg">
	<cfset var local = {}>

	<cfif arguments.Msg EQ "">
		<cfset local.result = 1>
	<cfelse>
		<cfset local.result = 0>
	</cfif>
	<cfreturn local.result>
</cffunction>
</cfcomponent>