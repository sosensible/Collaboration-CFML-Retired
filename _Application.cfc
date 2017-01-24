<cfcomponent>
	<cfimport prefix="APPestry" taglib="/share/tags/appestry/" />
	<cfimport prefix="cfish" taglib="/share/tags/cfish/">
	
	<cffunction name="onApplicationStart">
		<cfscript>
		/* TODO *
			* When data connection fails on startup DO NOT create APPLICATION or system will not start correctly.
		*/
		REQUEST._progress = "application start";
		APPLICATION.__server = {
			platform = "ColdFusion",
			OS = SERVER.OS.Name,
			slash = "/"
		};
		if(structKeyExists(server,"railo")){ APPLICATION.__server.platform = "Railo"; }
		if(findNoCase("windows",APPLICATION.__server.OS)){ APPLICATION.__server.slash = "\"; }
		APPLICATION['__api'] = {};
		APPLICATION.__api['site'] = {};
		APPLICATION.__api['app'] = {};
		APPLICATION.__api['subapp'] = {};
		APPLICATION.__api['multiSite'] = false;
		APPLICATION.__api.site = createObject("component","_site.object.site").init();
		APPLICATION.__framework = "appestry";
		</cfscript>
		<cfparam name="REQUEST.__domains" default="#CGI.HTTP_HOST#" />
	</cffunction>
	
	<cffunction name="onSessionStart">
		<cfscript>
		session.user = createObject("component","share.objects.appestry.user").init(site:APPLICATION.__api.site);
		</cfscript>
	</cffunction>
	
	<cffunction name="_onAppStart">
		<cfscript>
		// hit counter and such
		</cfscript>
	</cffunction>
	
	<cffunction name="_onAppEnd">
	
	</cffunction>

	<cffunction name="onRequestStart">
		<cfscript>
		// APPLICATION.__api.site = createObject("component","_site.object.site").init();
		APPLICATION.__api.site.setRequestAPI();
		if(!len(REQUEST._meta.action) || left(REQUEST._meta.action,1) == "_"){ abort; }
		structAppend(form,url,false);
		REQUEST._content = createObject("component","share.objects.sos.content");
		</cfscript>
	</cffunction>
	
	<cffunction name="onCFCRequest"></cffunction>
	
	<cffunction name="onRequest" output="yes">
		<cftry>
		<cfscript>
		// session temp logic
		// session.user = createObject("component","share.objects.appestry.user").init(site:APPLICATION.__api.site);
		
		REQUEST._content = createObject("component","share.objects.sos.content");
		
		// possibles: bootstrap, ??
		// (http://bootswatch.com/) amelia,cerulean,cosmo,cyborg,journal,readable,shamrock,simplex,slate,spacelab,spruce,superhero,united
		// 
		// ## widgets // http://bootsnipp.com/
		if(!structKeyExists(SESSION,"_skins")){ SESSION['_skins'] = 'bootstrap'; }
		if(!structKeyExists(SESSION,"_skin")){ SESSION['_skin'] = "bootstrap"; }
		if(!structKeyExists(REQUEST,"_skin")){ REQUEST._skin = createObject("component","share.objects.cfish.skin").init(SESSION._skin); }
		</cfscript>
		<cfset THIS._onAppStart()>
		<cfoutput><appestry:appcall subapp="#REQUEST._meta.subappname#" action="#REQUEST._meta.action#" reqvar="#form#" isBodyContent="true" /></cfoutput>
		<cfset THIS._onAppEnd()>
		<cfcatch>
			<!---<cfdump var="#VARIABLES.cfcatch#">--->
		</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="onRequestEnd">1
		<cfinclude template="/apps/#REQUEST._meta.appname#/_app/layout/default.cfm">2
		<cfinclude template="/_site/layout/default.cfm">3
	</cffunction>
	
	<cffunction name="onApplicationEnd"></cffunction>
	
	<cffunction name="onSessionEnd"></cffunction>
	
	<cffunction name="onError">
		<!---
		<cfdump var="#URL#" label="URL" expand="no">
		<cfdump var="#arguments#" label="onError Handler">
		<cfdump var="#request#" label="Request" expand="no">
		--->
		<cfabort>
	</cffunction>
	
</cfcomponent>