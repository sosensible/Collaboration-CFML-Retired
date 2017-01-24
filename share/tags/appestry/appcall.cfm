<cftry><cfif THISTAG.executionMode EQ "start"><cfparam name="ATTRIBUTES.isBodyContent" default="false"/><cfscript>
if(structKeyExists(ATTRIBUTES,'reqvar')){
	VARIABLES.reqvar = ATTRIBUTES.reqvar;
} else if (structKeyExists(CALLER.VARIABLES,'reqvar')){
	VARIABLES.reqvar = CALLER.variables.reqvar;
} else {
	VARIABLES.reqvar = {};
}
VARIABLES._api.subapp = APPLICATION.__API.subapp[ATTRIBUTES.subapp];
VARIABLES._api.app = VARIABLES._api.subapp.getApp();
VARIABLES._api.site = APPLICATION.__api.site;
</cfscript></cfif><cfif THISTAG.executionMode EQ "end" OR !THISTAG.hasEndTag><cfscript>
</cfscript><cfoutput><cfinclude template="/_site/methodologies/_#VARIABLES._api.subapp.getApp().getMethodology()#.cfm"></cfoutput></cfif><cfcatch><!---<cfdump var="#VARIABLES.cfcatch#" label="APPCall Exception"><cfabort>---></cfcatch></cftry>