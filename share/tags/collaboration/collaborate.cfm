<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="attributes.coprocessorDirectory" default=""><!---  --->
		<cfparam name="attributes.coprocessorClassPath" default=""><!---  --->
		<cfparam name="attributes.framework" default="collaboration">
		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset VARIABLES.root=caller>
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All collaboration tags require an end tag." errorcode="sos.tag.attributes">
		</cfif>
		<cfif attributes.coProcessorDirectory NEQ '' AND attributes.coProcessorClassPath EQ ''>
			<cfthrow message="If you specify the coProcessorDirectory, you must also specify a coprocessorClassPath attribute">
		</cfif>
		<cfif attributes.coProcessorClassPath NEQ '' AND attributes.coProcessorDirectory EQ ''>
			<cfthrow message="If you specify the coProcessorClassPath, you must also specify a coprocessorDirectory attribute">
		</cfif>
		<cfscript>
		if(attributes.coprocessorDirectory EQ '' OR attributes.coprocessorClassPath EQ ''){
			if(isDefined("root._app.root.directory") OR isDefined("root._app.root.classPath")) {
				attributes.coprocessorDirectory = VARIABLES.root._app.root.directory & VARIABLES.root.attributes.controller;
				attributes.coprocessorClassPath = VARIABLES.root._app.root.classPath & VARIABLES.root.attributes.controller;
			} else {
				thisRequest.server.root.directory = left(cgi.PATH_TRANSLATED,len(cgi.PATH_TRANSLATED)-len(cgi.SCRIPT_NAME)+1);
				thisRequest.server.root.slash = right(thisRequest.server.root.directory,1);
				thisRequest.current.root.directory = getDirectoryFromPath(getBaseTemplatePath());
				thisRequest.current.root.path = replace(right(getDirectoryFromPath(getBaseTemplatePath()),len(getDirectoryFromPath(getBaseTemplatePath()))-len(thisRequest.server.root.directory)+1),"\","/","ALL");
				thisRequest.current.root.classPath = replace(mid(thisRequest.current.root.path,2,len(thisRequest.current.root.path)-1),"/",".","ALL");
				thisRequest.current.root.controller = getFileFromPath(getBaseTemplatePath());
				thisRequest.current.root.controller = left(thisRequest.current.root.controller,len(thisRequest.current.root.controller)-4);
				attributes.coProcessorDirectory = thisRequest.current.root.directory & thisRequest.current.root.controller;
				attributes.coProcessorClassPath = thisRequest.current.root.classPath & thisRequest.current.root.controller;
			}
		} else {
			thisRequest.server.root.directory = left(cgi.PATH_TRANSLATED,len(cgi.PATH_TRANSLATED)-len(cgi.SCRIPT_NAME)+1);
			thisRequest.server.root.slash = right(thisRequest.server.root.directory,1);
			thisRequest.current.root.directory = getDirectoryFromPath(thisRequest.server.root.slash & replace(attributes.coProcessorClassPath,".",thisRequest.server.root.slash,"all"));
			thisRequest.current.root.path = replace(right(getDirectoryFromPath(getBaseTemplatePath()),len(getDirectoryFromPath("/" & replace(attributes.coProcessorDirectory,"\","/","all")))-len(thisRequest.server.root.directory)+1),"\","/","ALL");
			thisRequest.current.root.classPath = replace(mid(thisRequest.current.root.path,2,len(thisRequest.current.root.path)-1),"/",".","ALL");
			thisRequest.current.root.controller = getFileFromPath("/" & replace(attributes.coProcessorClassPath,".","/","all"));
			thisRequest.current.root.controller = left(thisRequest.current.root.controller,len(thisRequest.current.root.controller));
		}

		thisRequest.current.root.coProcessorDirectoryPath = getDirectoryFromPath(attributes.coProcessorDirectory);
		thisRequest.current.root.coProcessorDirectory = attributes.coProcessorDirectory & ".cfc";
		thisRequest.current.root.coProcessorClassPath = attributes.coProcessorClassPath;
		thisRequest.server.shareDirectory = left(getDirectoryFromPath(getCurrentTemplatePath()),len(getDirectoryFromPath(getCurrentTemplatePath()))-10);
		/*
		thisRequest.server.sharePath = replace(right(thisRequest.server.shareDirectory,len(thisRequest.server.shareDirectory) - len(thisRequest.server.root.directory) + 2),"\","/","all");
		thisRequest.server.shareClassPath = right(replace(thisRequest.server.sharePath,"/",".","all"),len(thisRequest.server.sharePath) - 1);
		*/
		thisRequest.server.sharePath = "/share/";
		thisRequest.server.shareClassPath = "share.";

		if(! structKeyExists(root,"_API")){
			VARIABLES.root._API = structNew();
		}
		 if(! structKeyExists(VARIABLES.root,"_preDom") || _isFunction('VARIABLES.root._preDom')){
		   VARIABLES.root._preDom = structNew();
		  }
		/* basically this was a longhand way of testing for _postback,
		*** it is outside the scope of what Collaboration needs to do,
		*** so it has be removed and left to external framework
		*/
		if(structKeyExists(APPLICATION,"__framework")){ ATTRIBUTES.framework = APPLICATION.__framework; }
		// makes sure Collaboration is ready for no API
		VARIABLES._api = {};
		// make sure Collaboration is ready for no request variables passed
		VARIABLES.reqvar = {};
		// handlers to run only if collaboration framework
		if(ATTRIBUTES.framework == "collaboration"){
			// makes sure Collaboration is ready for no attributes
			if(structKeyExists(VARIABLES.root,"attributes")){
				VARIABLES.root._preDom.attributes = VARIABLES.root.attributes;
			} else {
				VARIABLES.root._preDom.attributes = {};
				structAppend(VARIABLES.root._preDom.attributes,form);
				structAppend(VARIABLES.root._preDom.attributes,url);
			}
		} else {
			if(!structKeyExists(VARIABLES.root._preDom,'attributes')){
				VARIABLES.root._preDom.attributes = {};
			}
		}
		</cfscript>
		<cfif structKeyExists(APPLICATION,"__framework")>
			<cfinclude template="/share/tags/collaboration/framework/_#APPLICATION.__framework#.cfm" />
		</cfif>
		<cfscript>
		if (NOT structKeyExists(VARIABLES.root,"collaborate")) {
			if(fileExists(thisRequest.current.root.coprocessorDirectory)){
				VARIABLES.root.collaborate = createObject("component","#thisRequest.current.root.coprocessorClassPath#");
			} else {
				VARIABLES.root.collaborate = createObject("component","#thisRequest.server.shareClassPath#objects.collaboration.coprocessor");
			}
			// makes sure Collaboration has content object
			if(structKeyExists(REQUEST,"_content")){
				content = REQUEST._content;
			} else {
				content = createObject("component","#thisRequest.server.shareClassPath#objects.sos.content");
			}
			VARIABLES.root.collaborate.init(
				configuration:thisRequest,
				contentObj:content,
				api: VARIABLES._API,
				attributes: VARIABLES.root._preDom.attributes
			);
		}
		attributes.thisRequest = thisRequest;

		VARIABLES.root._preDom = VARIABLES.root.collaborate.onPageStart(
			preDOM:VARIABLES.root._preDom,
			reqvar:VARIABLES.reqvar,
			api:VARIABLES._api
		);
		if((structKeyExists(VARIABLES.root,"attributes") && structKeyExists(VARIABLES.root.attributes,"_postBack")) ||
			structKeyExists(form,"_postBack") ||
			structKeyExists(url,"_postBack") )
		{
			VARIABLES.root._preDom = VARIABLES.root.collaborate.onPostBack(
				preDOM:VARIABLES.root._preDom,
				reqvar:VARIABLES.reqvar,
				api:VARIABLES._api
			);
		} else {
			VARIABLES.root._preDom = VARIABLES.root.collaborate.onFirstCall(
				preDOM:VARIABLES.root._preDom,
				reqvar:VARIABLES.reqvar,
				api:VARIABLES._api
			);
		}
		VARIABLES.root._preDom = VARIABLES.root.collaborate.beforeViewCall(
			preDOM:VARIABLES.root._preDom,
			reqvar:VARIABLES.reqvar,
			api:VARIABLES._api
		);
		</cfscript>
		</cfcase><cfcase value="end">
		<cfscript>
		VARIABLES.root.collaborate.onPageEnd(
			preDOM:VARIABLES.root._preDom,
			reqvar:VARIABLES.reqvar,
			api:VARIABLES._api
		);
		// VARIABLES.root.collaborate.content.getHeadContent();
		</cfscript>
		</cfcase>
</cfswitch>
<cfsetting enablecfoutputonly="false">
<cffunction name="_isFunction">
    <cfargument name="str">
    <cfscript>
    if(ListFindNoCase(StructKeyList(GetFunctionList()),ARGUMENTS.str)) return 1;
    if(IsDefined(ARGUMENTS.str) AND Evaluate("IsCustomFunction(#ARGUMENTS.str#)")) return 1;
    return 0;
    </cfscript>
</cffunction>