<cfset Application.dbo.Usr.CleanSlate()>
<cfset Variables.Audit.Usr = createObject("component","Audit.Usr").Init(Application.Audit)>
<cfset Variables.Audit.Usr.CleanSlate()>
<cfset Variables.Log.Trace = createObject("component","Log.Trace").Init(Application.Log)>
<cfset Variables.Log.Trace.CleanSlate()>
<cfset Variables.dbo.Database = createObject("component","Database").Init(Application.Audit)>
<cfset Variables.dbo.Database.CleanSlate()>
Done!