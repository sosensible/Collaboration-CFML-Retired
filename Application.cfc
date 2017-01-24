<cfcomponent extends="_Application">
	<cfscript>
	dynORMPath = "/data"; // the goal here is if there is a site ID to embed it in the data class path
	this.name = "Appestry_1.0.c33";
	this.datasource = 'sosensible3';
	this.ormenabled = true;
	this.ormsettings = {
		autorebuild = false,
		cfclocation = ['/_site#dynORMPath#'],
		dbcreate = 'update'
	};
	
	REQUEST.__domain = ["beta.www.sosensible.com","betaskin.www.sosensible.com"];
	
	/* Agenda for MVP Collaboration Framework.
	 * . basic Site/Application API, convention based
	 * . data schema standard
	 * . authentication
	 * . user UI
	 * . admin UI
	 * . theme/skin
	 * . docs
	 * . training
	 */
	</cfscript>
	
	<cffunction name="onRequest" output="yes">
		<cfscript>
		SESSION['_skins'] = 'amelia,bootstrap,cerulean,cosmo,cyborg,journal,readable,shamrock,simplex,slate,spacelab,spruce,superhero,united';
		if(!structKeyExists(SESSION,"_skin")){ SESSION['_skin'] = "cerulean"; }
		// temp permission variable
		VARIABLES._allowURLSkin = true;
		if(listContainsNoCase(CGI.HTTP_HOST,"betaskin",".")){
			if(!structKeyExists(SESSION,"_demo")){
				SESSION["_demo"] = {};
				SESSION['_skin'] = "bootstrap";
			}
			if(structKeyExists(URL,"_skin") && VARIABLES._allowURLSkin){
				REQUEST._skin = createObject("component","share.objects.cfish.skin").init(URL._skin);
				SESSION._demo["skin"] = REQUEST._skin;
			} else if(structKeyExists(SESSION._demo,"skin")) {
				REQUEST._skin = SESSION._demo.skin;
			} else {
				REQUEST._skin = createObject("component","share.objects.cfish.skin").init(SESSION._skin);
			}
		}
		
		super.onRequest();
		</cfscript>
	</cffunction>
	
<!---	
	<cffunction name="onApplicationStart">
		<cfscript>
		REQUEST._progress = "application start";
		APPLICATION.__server = {
			platform = "ColdFusion",
			OS = SERVER.OS.Name,
			slash = "/"
		};
		if(structKeyExists(server,"railo")){ APPLICATION.__server.platform = "Railo"; }
		if(findNoCase("windows",APPLICATION.__server.OS)){ APPLICATION.__server.slash = "\"; }
		APPLICATION.__site = createObject("component","_site.object.site").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="onApplicationEnd"></cffunction>
	
	<cffunction name="onSessionStart"></cffunction>
	
	<cffunction name="onSessionEnd"></cffunction>

	<cffunction name="onRequestStart">
		<cfscript>
		APPLICATION.__api.site = createObject("component","_site.object.site").init();
		APPLICATION.__api.site.setRequestAPI();
		structAppend(form,url,false);
		REQUEST._content = createObject("component","share.objects.sos.content");
		</cfscript>
	</cffunction>
	
	<cffunction name="onCFCRequest"></cffunction>
	
	<cffunction name="onRequest" output="yes">
	<cftry>
	<cfoutput>
		<cfif REQUEST._meta.routeType EQ "managed">
			<cfsavecontent variable="REQUEST.__bodyContent"><cfinclude template='#REQUEST._meta.template#' /></cfsavecontent>
		<cfelse>
			<cfsavecontent variable="REQUEST.__bodyContent"><cfinclude template="/apps/main/index.cfm" /></cfsavecontent>
		</cfif>
		<cfcontent reset="yes" /><cfinclude template="/_site/layout/default.cfm" />
	</cfoutput>
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>
	</cffunction>

	<cffunction name="onRequestEnd">
		
	</cffunction>
	
	<cffunction name="onError">
		<cfdump var="#arguments#" label="onError Handler">
		<cfdump var="#request#" label="Request" expand="no">
		<cfabort>
	</cffunction>
	
	<cffunction name="xonAbort"></cffunction>
--->
</cfcomponent>