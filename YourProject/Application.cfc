<cfcomponent>
<cfset this.name = left("App_#hash(getCurrentTemplatePath())#",64)>
<cfinclude template="/Database/Datasource.cfm">
<cfset this.sessionManagement = true>
<cfset this.scriptProtect = "all">
<cfset this.rootPath = getDirectoryFromPath(getCurrentTemplatePath())>
<cfset this.customTagPaths = "#this.rootPath#Components">

<cfset this.mappings = {}>
<cfset structInsert(this.mappings, '/YourProject', this.rootPath)>

<cffunction name="onApplicationStart" returntype="boolean">
	<cfset var local = {}>

	<cfset Application.Developing = True>
	<cfset local.Datasource = this.Datasource>
	<cfset Variables.Pgm = CreateObject("component","Log.Pgm").Init(local)>
	<cfset local.PgmID = Variables.Pgm.WherePgmName("Application.cfc")>
	<cfset Variables.Database = CreateObject("component","Database").Init(local)>
	<cfset local.FuncName = "onApplicationStart">
	<cfset local.dbs = Variables.Database.Where(local)>

	<cfset Application.dbo = {}>
	<cfset Application.dbo.Usr = createObject("component","dbo.Usr").Init(local)>
	<cfset Application.Audit.Datasource = this.Datasource>
	<!--- Saving the datasource instead of putting everything in the Application scope --->
	<cfset Application.Log.Datasource = this.Datasource>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
	<cfreturn true>
</cffunction>

<cffunction name="onRequestStart" output="False">
	<cfargument name = "thePage" type="string" required="True"/>
	<cfset var local = {}>

	<cfif NOT structKeyExists(Variables,"Database")>
		<cfset onApplicationStart()>
	</cfif>
	<cfset local.FuncName = "onRequestStart">
	<cfset local.dbs = Variables.Database.Where(local)>
	<cfset request.Msg = "">
	<cfset onApplicationStart()>
	<cfif structKeyExists(url,"Logout")>
		<cfset structDelete(session,"Usr")>
	</cfif>
	<cfif structKeyExists(session,"Usr")>
	<cfelseif structKeyExists(form,"j_Username") AND structKeyExists(form,"j_Password")>
		<cfset local.qry = Application.dbo.Usr.Login(form)>
		<cfif isQuery(local.qry)>
			<cfif local.qry.Recordcount>
				<cfset session.Usr = local.qry>
				<cfset session.UsrID = session.Usr.UsrID>
			<cfelse>
				<cfset request.Msg = "Invalid Username/Password">
			</cfif>
		<cfelse>
			<cfset request.Msg = local.qry>
		</cfif>
	</cfif>
	<cfif NOT structKeyExists(session,"Usr")>
		<cfinclude template="Login/Index.cfm">
	</cfif>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
	<cfif NOT structKeyExists(session,"Usr")>
		<cfabort>
	</cfif>
</cffunction>

<cffunction name="onRequestEnd" returnType="void" output="false">
	<cfargument name="thePage" type="string" required="true">
	<cfset var local = {}>

	<cfset local.FuncName = "onRequestEnd">
	<cfset local.dbs = Variables.Database.Where(local)>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
</cffunction>

<cffunction name="onSessionEnd" returnType="void" output="false">
	<cfargument name="sessionScope" type="struct" required="true">
	<cfargument name="appScope" type="struct" required="false">
	<cfset var local = {}>

	<cfset local.FuncName = "onSessionEnd">
	<cfset local.dbs = Variables.Database.Where(local)>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
</cffunction>

<cffunction name="onApplicationEnd" returnType="void" output="false">
	<cfargument name="applicationScope" required="true">
	<cfset var local = {}>

	<cfset local.FuncName = "onApplicationEnd">
	<cfset local.dbs = Variables.Database.Where(local)>
	<cfset Variables.Database.Stop(local.dbs.TraceID)>
</cffunction>

</cfcomponent>
