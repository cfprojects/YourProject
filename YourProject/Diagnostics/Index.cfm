<cfoutput>
<cfif StructKeyExists(form,"Level")>
<cfelseif StructKeyExists(url,"Level")>
	<cfset form.Level=url.Level>
<cfelseif Application.Developing>
	<cfset form.Level=2>
<cfelse>
	<cfset form.Level=3>
</cfif>
<cfset form.Trace = 1>
<cfinclude template="/YourProject/Inc/html.cfm">
<cfinclude template="/YourProject/Inc/head.cfm">
<title>Diagnostics</title>
<cfinclude template="/YourProject/Inc/body.cfm">
<cfset form.Trace = 0>
<cfset TotalErrors = 0>
<cfset TotalIndex = 0>
<cfset TotalMethods = 0>
<cfset TotalRemaining = 0>
<cfset result = ArrayNew(1)>
<cfset result[01] = CreateObject("component","Components.Diagnostics.Usr").Init(form)>
<cfloop from="1" to="#ArrayLen(result)#" index="I">
	<cfset TotalErrors = TotalErrors + result[I].Errors>
	<cfset TotalIndex = TotalIndex + result[I].Index - 1>
	<cfset TotalMethods = TotalMethods + result[I].Methods>
	<cfset TotalRemaining = TotalRemaining + result[I].Methods - result[I].Index + 1>
</cfloop>
<table class="border">
	<thead>
		<tr>
			<th>Table</th>
			<th>Errors</th>
			<th>Methods<br>Executed</th>
			<th>Methods<br>Available</th>
			<th>Remaining</th>
		</tr>
	</thead>
	<tbody>
		<cfloop from="1" to="#ArrayLen(result)#" index="I">
			<cfif structKeyExists(result[I],"href")>
				<cfset href=result[I].href>
			<cfelse>
				<cfset href="Diagnostic.cfm?ComponentName=#result[I].Name#">
			</cfif>
			<tr<cfif result[I].Errors> class="err"</cfif>>
				<td><a href="#href#">#result[I].Name#</a></td>
				<td class="num">#result[I].Errors#</td>
				<td class="num">#result[I].Index-1#</td>
				<td class="num">#result[I].Methods#</td>
				<td class="num">#result[I].Methods - (result[I].Index - 1)#</td>
			</tr>
		</cfloop>
	</tbody>
	<tfoot>
		<tr>
			<td>Total Errors</td>
			<td class="num">#TotalErrors#</td>
			<td class="num">#TotalIndex#</td>
			<td class="num">#TotalMethods#</td>
			<td class="num">#TotalRemaining#</td>
		</tr>
	</tfoot>
</table>
<cfform preservedata="yes">
<label for="Level">Level:</label>
	<select name="Level">
		<option value="2"<cfif form.Level EQ "2"> selected</cfif>>2-CRUD</option>
		<option value="3"<cfif form.Level EQ "3"> selected</cfif>>3-Read</option>
	</select>
	<label for="Submit" class="block"></label>
	<input name="Diagnose" type="submit" value="Diagnose!">
</cfform>
<cfinclude template="/YourProject/Inc/Footer.cfm">
</cfoutput>