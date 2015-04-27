<cfoutput>
<cfset Msg = request.Msg>
<cfset returnHome = False>
<cfif structKeyExists(form,"Cancel")>
	<cfset returnHome = True>
<cfelseif structKeyExists(form,"Save")>
	<cfset Msg = Application.dbo.Usr.Save(form)>
	<cfif Msg EQ "">
		<cfset returnHome = True>
	</cfif>
<cfelseif structKeyExists(form,"Delete")>
	<cfset Msg = Application.dbo.Usr.Delete(form)>
	<cfif Msg EQ "">
		<cfset returnHome = True>
	</cfif>
<cfelseif structKeyExists(url,"UsrID")>
	<cfset qryUsr = Application.dbo.Usr.WhereUsrID(url.UsrID)>
	<cfset form.UsrID = qryUsr.UsrID>
	<cfset form.j_Username = qryUsr.UsrName>
	<cfset form.j_Password = qryUsr.UsrPassword>
<cfelseif structKeyExists(url,"Create")>
	<cfset form.UsrID = 0>
	<cfset form.j_Username = "">
</cfif>
<cfif returnHome>
	<cflocation url="Usr.cfm" addtoken="false">
</cfif>
<cfinclude template="/YourProject/Inc/html.cfm">
<cfinclude template="/YourProject/Inc/head.cfm">
<title>Usr Table</title>
<cfinclude template="/YourProject/Inc/body.cfm">
<div id="msg">#Msg#&nbsp;</div>
<cfform name="myForm" preservedata="true">
	<label for="j_Username">User Name:</label>
	<cfinput name="j_Username">
	<label for="j_Password">Password:</label>
	<cfinput name="j_Password">
	<cfinput name="UsrID" type="hidden">
	<cfinput name="Usr_UsrID" type="hidden" value="#session.UsrID#">
	<div id="action">
		<cfif form.j_Username EQ "admin">
			<input name="Save" type="submit" value="Save" disabled="disabled">
			<input name="Delete" type="submit" value="Delete" disabled="disabled">
		<cfelse>
			<input name="Save" type="submit" value="Save">
			<input name="Delete" type="submit" value="Delete" title="Are you sure you want to delete this user?">
		</cfif>
		<input name="Cancel" type="submit" value="Cancel">
	</div>
</cfform>
<cfinclude template="/YourProject/Inc/Footer.cfm">
</cfoutput>