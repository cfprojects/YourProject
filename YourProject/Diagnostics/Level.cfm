<cfif StructKeyExists(form,"Level")>
<cfelseif StructKeyExists(url,"Level")>
	<cfset form.Level=url.Level>
<cfelseif Application.Developing>
	<cfset form.Level=2>
<cfelse>
	<cfset form.Level=3>
</cfif>
<cfset form.Trace = 1>