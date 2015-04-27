<cfinclude template="/YourProject/Inc/html.cfm">
<cfinclude template="/YourProject/Inc/head.cfm">
<title>Please Login</title>
<cfinclude template="/YourProject/Inc/body.cfm">
This sample application was written by Phillip Senn to showcase a few features.
<ul>
	<li>Security (you must login)</li>
	<li>CRUD (Create, Read, Update and Delete)</li>
	<li>Auditing (Every change that's made is logged)</li>
	<li>Tracing (Every function that's called is logged)</li>
	<li>Diagnostics (Every function written has a diagnostic)</li>
</ul>
<cfform preservedata="true">
	<label for="j_Username">Username:</label>
	<cfinput name="j_Username" value="admin">
	<label for="j_Password">Password:</label>
	<cfinput name="j_Password" value="admin">
	<label for="Login">&nbsp;</label>
	<input name="Login" type="submit" value="Login">
</cfform>
<cfinclude template="/YourProject/Inc/Footer.cfm">
