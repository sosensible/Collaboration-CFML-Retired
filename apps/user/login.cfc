<cfcomponent extends="share.objects.collaboration.coprocessor" output="false">

	<cffunction name="onPageStart" output="false" access="public" returntype="struct">

		<cfargument name="preDOM" default="#structNew()#">
		<cfargument name="reqvar" default="#structNew()#">
		<cfargument name="api" default="#structNew()#">
		
		<cfscript>
		var _preDOM = ARGUMENTS.preDom;
		var _api = ARGUMENTS.api;
		var _reqvar = ARGUMENTS.reqvar;
		
		SESSION.user.login(user_main:'admin',password:'build',label:'#now()#');
		
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
		var user = SESSION.user;
		
		
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
		var user = SESSION.user;
		
		_preDom.userName.value = user.get_name();
		_preDom.regLink.href = "#_api.subapp.getPath()#register.cfm";
		
		return _preDom;
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