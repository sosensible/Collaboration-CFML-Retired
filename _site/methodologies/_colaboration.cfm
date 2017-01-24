<cfimport prefix="co" taglib="/share/tags/collaboration/"><cfscript>
if( REQUEST._meta.routeType EQ "routed" ){
	VARIABLES._viewTemplate = REQUEST._meta.template;
} else if ( REQUEST._meta.routeType EQ "direct" ) {
	VARIABLES._viewTemplate = REQUEST._meta.template;
}
VARIABLES._viewTemplate = _api.subapp.getPath() & ATTRIBUTES.action & '.cfm';
</cfscript><co:collaborate coprocessorDirectory="#VARIABLES._api.subapp.getDirectory()##ATTRIBUTES.action#" coprocessorClassPath="#VARIABLES._api.subapp.getClassPath()##ATTRIBUTES.action#">
<cfoutput><cfif ATTRIBUTES.isBodyContent><cfsavecontent variable="REQUEST.__bodyContent"><cfinclude template='#VARIABLES._viewTemplate#' /></cfsavecontent><cfelse><cfinclude template='#VARIABLES._viewTemplate#' /></cfif></cfoutput></co:collaborate>