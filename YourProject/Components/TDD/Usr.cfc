<cfcomponent>
<cfset Variables.TestReturnValue = CreateObject("component","TestReturnValue")>

<cffunction name="Run">
	<cfargument name="form">
	<cfset var local = {}>
	<cfset var Method = ArrayNew(1)>
	<cfset var Message = ArrayNew(1)>
	<cfset var Success = ArrayNew(1)>

	<cfset Method[1] = "Login">
	<cfset Method[2] = "WhereUsrID">
	<cfset Method[3] = "Insert">
	<cfset Method[4] = "Update">
	<cfset Method[5] = "Delete">
	<cfloop from="1" to="#ArrayLen(Method)#" index="local.Index">
		<cfset Message[local.Index] = "N/A">
		<cfset Success[local.Index] = "">
	</cfloop>

	<cfset local.j_Username = "admin">
	<cfset local.j_Password = "admin">
	<cfset local.qry = Application.dbo.Usr.Login(local)>
	<cfset Message[1] = Variables.TestReturnValue.qryMsg(local.qry)>
	<cfset Success[1] = Variables.TestReturnValue.IsQry(local.qry)>
	<cfset local.Usr_UsrID = local.qry.UsrID> <!--- The person that last updated this row --->

	<cfset local.qry = Application.dbo.Usr.WhereUsrID(local.qry.UsrID)>
	<cfset Message[2] = Variables.TestReturnValue.qryMsg(local.qry)>
	<cfset Success[2] = Variables.TestReturnValue.IsQry(local.qry)>

	<cfif form.Level LE 2>
		<cfset local.UsrID = 0>
		<cfset local.j_UserName = "John Doe">
		<cfset local.j_Password = "monkey">
		<cfset Message[3] = Application.dbo.Usr.Save(local)>
		<cfset Success[3] = Variables.TestReturnValue.isEmpty(Message[2])>

		<cfset local.j_UserName = "Harold Schlecklemeyer">
		<cfset Message[4] = Application.dbo.Usr.Save(local)>
		<cfset Success[4] = Variables.TestReturnValue.isEmpty(Message[3])>

		<cfset Message[5] = Application.dbo.Usr.Delete(local)>
		<cfset Success[5] = Variables.TestReturnValue.isEmpty(Message[4])>
	</cfif>
	<cfset local.result.Methods = ArrayLen(Method)>
	<cfset local.result.Index = arraylen(Message)>
	<cfset local.result.Errors = arraylen(Success) - arraySum(Success)>
	<cfset local.result.Name = "Usr">

	<cfoutput>
	<cfif form.Trace>
		<table class="border">
			<thead>
				<tr>
					<th>Method</th>
					<th>Success</th>
					<th>Message</th>
				</tr>
			</thead>
			<tbody>
			<cfloop from="1" to="#local.result.Methods#" index="local.I">
				<tr>
					<td>#Method[local.I]#</td>
					<td class="num">#Success[local.I]#</td>
					<td>#Message[local.I]#</td>
				</tr>
			</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<td>Total Methods</td>
					<td class="num">#local.result.Methods#</td>
					<td>&nbsp;</td>
				</tr>
				<tr<cfif local.Result.Errors> class="err"</cfif>>
					<td>Total Errors</td>
					<td class="num">#local.Result.Errors#</td>
					<td>&nbsp;</td>
				</tr>
			</tfoot>
		</table>
	</cfif>
	</cfoutput>


	<cfreturn local.result>
</cffunction>
</cfcomponent>