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
		var user_id = iif(structKeyExists(_reqVar,'id'),_reqvar.id,0);
		
		VARIABLES.user = EntityLoad('site__user',user_id,true);
		/*
		writeDump(VARIABLES.user);
		writeOutput('#user_id#');
		abort;
		*/
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
		/*
		*/
		_preDOM.test = true;
		test = data2preDOM(
			init : _preDOM,
			data : entitytoQuery(VARIABLES.user),
			fields : VARIABLES.user.get_standardFields(),
			listFields : VARIABLES.user.get_listFields()
		);
		/*
		writeDump(var:entitytoQuery(VARIABLES.user),label:'user rs',expand:false);
		writeDump(var:VARIABLES.user.get_standardFields(),label:'user std fields',expand:false);
		writeDump(var:VARIABLES.user.get_listFields(),label:'user list fields',expand:false);
		writeDump(VARIABLES.user);
		writeDump(VARIABLES.user.get_standardFields());
		writeDump(VARIABLES.user.get_meta());
		writeDump(_preDOM);
		writeDump(test);
		abort;
		*/
		
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