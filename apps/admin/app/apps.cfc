<cfcomponent extends="share.objects.collaboration.coprocessor" output="false">

	<cffunction name="onRemoteStart" 
		description="I am called when " 
		displayname="onRemoteStart"
		 output="false" access="private" returntype="void">

		<cfscript>
		VARIABLES._API = REQUEST._API;
		VARIABLES.attributes = REQUEST.attributes;
		</cfscript>
		<cfsetting showdebugoutput="false">
	</cffunction>

	<cffunction name="onPageStart" output="false" access="public" returntype="struct">
		<cfargument name="preDom" default="#structNew()#">
		<cfargument name="api" default="#structNew()#">

		<cfargument name="preDOM" default="#structNew()#">
		<cfargument name="reqvar" default="#structNew()#">
		<cfargument name="api" default="#structNew()#">
		
		<cfscript>
		var _preDOM = ARGUMENTS.preDom;
		var _api = ARGUMENTS.api;
		var _reqvar = ARGUMENTS.reqvar;
		
		return _preDOM;
		</cfscript>

	</cffunction>

	<cffunction name="onFirstCall" 
		description="I am called whenever the collaborate tag is first initiated" 
		displayname="onFirstCall"
		 output="false" access="public" returntype="struct">

		<cfargument name="preDOM" default="#structNew()#">
		<cfargument name="reqvar" default="#structNew()#">
		<cfargument name="api" default="#structNew()#">
		
		<cfscript>
		var _preDOM = ARGUMENTS.preDom;
		var _api = ARGUMENTS.api;
		var _reqvar = ARGUMENTS.reqvar;
		
		return _preDOM;
		</cfscript>

	</cffunction>

	<cffunction name="onPostBack" 
		description="I am called whenever a form postback happens." 
		displayname="onPostBack"
		 output="false" access="public" returntype="struct">

		<cfargument name="preDOM" default="#structNew()#">
		<cfargument name="reqvar" default="#structNew()#">
		<cfargument name="api" default="#structNew()#">
		
		<cfscript>
		var _preDOM = ARGUMENTS.preDom;
		var _api = ARGUMENTS.api;
		var _reqvar = ARGUMENTS.reqvar;
		
		return _preDOM;
		</cfscript>

	</cffunction>

	<cffunction name="beforeViewCall" 
		description="I am the last of the collaborate callbacks to get called." 
		displayname="onPostBack"
		 output="false" access="public" returntype="struct">

		<cfargument name="preDOM" default="#structNew()#">
		<cfargument name="reqvar" default="#structNew()#">
		<cfargument name="api" default="#structNew()#">
		
		<cfscript>
		var _preDOM = ARGUMENTS.preDom;
		var _api = ARGUMENTS.api;
		var _reqvar = ARGUMENTS.reqvar;
		var apps = structKeyList(APPLICATION.__api.app);
		
		_preDOM.appList = {
			data = listSort(apps,'text'),
			link = "#_api.subapp.getPath()#app.cfm?app=",
			linkField = "value"
		};
		
		return _preDOM;
		</cfscript>

	</cffunction>

	<cffunction name="onPageEnd" output="false" access="public" returntype="void">

		<cfargument name="preDOM" default="#structNew()#">
		<cfargument name="reqvar" default="#structNew()#">
		<cfargument name="api" default="#structNew()#">
		
		<cfscript>
		var _preDOM = ARGUMENTS.preDom;
		var _api = ARGUMENTS.api;
		var _reqvar = ARGUMENTS.reqvar;
		</cfscript>

	</cffunction>
	
	<!--- custom methods--->
	
	<!--- AJAX methods--->

</cfcomponent>