<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Diagnostic</title>
</head>

<body>
<cfinclude template="Level.cfm">
<cfset CreateObject("component","tdd.#url.ComponentName#").Run(form)>
<!---
<cfform preservedata="yes">
	<label for="Level">Level:</label>
	<select name="Level">
		<option value="2"<cfif form.Level EQ "2"> selected</cfif>>2-CRUD</option>
		<option value="3"<cfif form.Level EQ "3"> selected</cfif>>3-Read</option>
	</select>
	<label for="Submit" class="block"></label>
	<input name="Diagnose" type="submit" value="Diagnose!">
</cfform>
--->
</body>
</html>
</cfoutput>