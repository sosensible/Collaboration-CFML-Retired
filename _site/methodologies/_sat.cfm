<cfoutput><cfif REQUEST._meta.routeType EQ "managed">
	<cfsavecontent variable="REQUEST.__bodyContent"><cfinclude template='#REQUEST._meta.template#' /></cfsavecontent>
<cfelse>
	<cfsavecontent variable="REQUEST.__bodyContent"><cfinclude template="/apps/main/index.cfm" /></cfsavecontent>
</cfif></cfoutput>