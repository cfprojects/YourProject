<cfinclude template="/YourProject/Inc/html.cfm">
<cfinclude template="/YourProject/Inc/head.cfm">
<title>Your Project</title>
<cfinclude template="/YourProject/Inc/body.cfm">
<ul>
	<li><a href="Diagnostics/Detail.cfm?ComponentName=Usr">Run Usr Diagnostic</a></li>
	<li><a href="Log/Trace.cfm">View the Trace Log table</a></li>
	<li><a href="Admin/Usr.cfm">Edit Usr table</a></li>
	<li><a href="Audit/Usr.cfm">View the Audit Usr table</a></li>
	<li><a href="Admin/CleanSlate.cfm">Clean Slate</a></li>
	<li><a href="Index.cfm?Logout">Logout</a></li>
</ul>
<cfinclude template="/YourProject/Inc/Footer.cfm">
