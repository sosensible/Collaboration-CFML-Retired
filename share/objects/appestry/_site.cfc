<cfcomponent extends="api">

	<cffunction name="init" access="public">
		<cfscript>
		VARIABLES['classPath'] = "";
		VARIABLES['directory'] =  expandPath("/");
		VARIABLES['path'] = "/";
		
		VARIABLES.this = super.init(
			target: "_site",
			classPath: VARIABLES.classPath,
			directory: VARIABLES.directory,
			path: VARIABLES.path
		);
		
		VARIABLES['objectClassPath'] = listAppend(VARIABLES.classPath,"_site.objects.",".");
		VARIABLES['dataClassPath'] = listAppend(VARIABLES.classPath,"_site.data.",".");
		
		initApps();
		
		return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="initApps">
		<cfscript>
		var platform = Application.__server.platform;
		var i = {};
		var slash = APPLICATION.__server.slash;
		var tmp = {};
		var appList = directoryList('#VARIABLES.directory#apps/');
		var o = {};
		
		if(lcase(platform) == "railo" ){
			for(i.app=1;i.app<=arrayLen(appList);i.app++){
				tmp.appName = listLast(appList[i.app],slash);
				
				o.app = this.addApp(
					name: tmp.appName,
					classPath: "apps.#tmp.appName#.",
					directory: expandPath("/apps") & "#slash##tmp.appName##slash#",
					path: "/apps/#tmp.appName#/",
					app: THIS.addApp
				);
				
				THIS.initSubApps(o.app);
				
			}
		} else if(lcase(platform) == "coldfusion") {
			// handle for ColdFusion
			for(i.app=1;i.app<=arrayLen(appList);i.app++){
				tmp.appName = listLast(appList[i.app],slash);
				
				o.app = this.addApp(
					name: tmp.appName,
					classPath: "apps.#tmp.appName#.",
					directory: expandPath("/apps") & "#slash##tmp.appName##slash#",
					path: "/apps/#tmp.appName#/"
				);
				
				// THIS.initSubApps(o.app);
				
			}
		}
		</cfscript>
	
	</cffunction>
	
	<cffunction name="addApp">
		<cfargument name="name">
		<cfargument name="classPath">
		<cfargument name="directory">
		<cfargument name="path">
		<cfscript>
		var o = {};
		
		o.app = createObject("component","apps.#ARGUMENTS.name#._app.object.app").init(
			name: ARGUMENTS.name,
			classPath: ARGUMENTS.classPath,
			directory: ARGUMENTS.directory,
			path: ARGUMENTS.path
		);
		APPLICATION.__api.app[ARGUMENTS.name] = o.app;
		
		this.addSubApp(
			name: "#o.app.getName()#_#o.app.getName()#",
			classPath: "#o.app.getClassPath()#",
			directory: "#o.app.getDirectory()#",
			path: "#o.app.getPath()#",
			app: o.app
		);
		
		return o.app;
		</cfscript>
	</cffunction>
	
	<cffunction name="removeApp">
		<cfset structDelete(APPLICATION.__app,ARGUMENTS.name)>
	</cffunction>
	
	<cffunction name="updateApp">
		<!--- TODO: Add to allow any persistant object details to remain. --->
	</cffunction>
	
	<cffunction name="initSubApps">
		<cfargument name="o_app">

		<cfscript>
		var platform = Application.__server.platform;
		var i = {};
		var slash = APPLICATION.__server.slash;
		var tmp = {};
		var o = { app = ARGUMENTS.o_app };
		var subAppList = directoryList(o.app.getDirectory(),false,"query");
		
		if(lcase(platform) == "railo" ){
			for(i.subapp=1;i.subapp<=subAppList.recordCount;i.subapp++){
				// tmp.subAppName = listLast(subAppList[i.subapp],slash);
				
				// dump(subAppList);abort;
				i.name = subAppList.name[i.subapp];
				i.type = subAppList.type[i.subapp];
				if(i.type == 'Dir' && left(i.name,1) != '_'){
					o.subDir = o.app.getDirectory() & i.name;
					i.checklist = directoryList(o.subDir,false,'name');
					if(arrayContains(i.checkList,"_subapp")){
						this.addSubApp(
							name: "#o.app.getName()#_#i.name#",
							classPath: "#o.app.getClassPath()##i.name#",
							directory: "#o.app.getDirectory()##i.name##slash#",
							path: "#o.app.getPath()##i.name#/",
							app: ARGUMENTS.o_app
						);
						
					}
					
				}
				
			}
		} else if(lcase(platform) == "coldfusion") {
			// handle for ColdFusion
			for(i.app=1;i.app<=arrayLen(appList);i.app++){
				tmp.appName = listLast(appList[i.app],slash);
				
				this.addSubApp(
					name: tmp.appName,
					classPath: "apps.#tmp.appName#",
					directory: expandPath("/apps") & "#slash##tmp.appName##slash#",
					path: "/apps/#tmp.appName#/",
					app: this.o_app
				);
				
			}
		}
		</cfscript>
	
	</cffunction>
	
	<cffunction name="addSubApp">
		<cfargument name="name">
		<cfargument name="classPath">
		<cfargument name="directory">
		<cfargument name="path">
		<cfargument name="app">
		<cfscript>
		var o = {};
		
		if(right(ARGUMENTS.classPath,1) != "."){ ARGUMENTS.classPath &= "."; }
		o.subapp = createObject("component","#ARGUMENTS.classPath#_subapp.object.subapp").init(
			name: ARGUMENTS.name,
			classPath: ARGUMENTS.classPath,
			directory: ARGUMENTS.directory,
			path: ARGUMENTS.path,
			app: ARGUMENTS.app
		);
		
		Application.__api.subapp[ARGUMENTS.name] = o.subapp;
		
		return o.subapp;
		</cfscript>
	</cffunction>
	
	<cffunction name="removeSubApp">
		<cfset structDelete(APPLICATION.__subapp,ARGUMENTS.name)>
	</cffunction>
	
	<cffunction name="updateSubApp">
		<!--- TODO: Add to allow any persistant object details to remain. --->
	</cffunction>
	
	<cffunction name="setRequestAPI">
		<cfscript>
		var $route = cgi.PATH_INFO;
		var $get = cgi.QUERY_STRING;
		var $script = cgi.SCRIPT_NAME;
		var tmp = {};
		
		REQUEST['_parse'] = 'route handler';
		REQUEST['_meta'] = {};
		REQUEST._meta['appname'] = "";
		REQUEST._meta['action'] = "index";
		REQUEST._meta['routeType'] = "undefined";
		REQUEST._progress = "request start";
		if(!structKeyExists(REQUEST,"_onRequestStart")){ REQUEST['_onRequestStart'] = "started"; }
		
		try{
			
			if(len($route)) {
				try{
					// logic for route paths
					REQUEST._meta['subappname'] = listFirst($route,"/");
					REQUEST._meta['appname'] = listFirst(REQUEST._meta.subappname,"_");
					REQUEST._meta['routeType'] = "routed";
					if(listLen($route,"/") GTE 2){
						REQUEST._meta['action'] = listGetAt($route,2,"/");	
					}
					REQUEST._meta['template'] = '/apps/#replace(REQUEST._meta.subappName,"_","/","ALL")#/#REQUEST._meta.action#.cfm';
				} catch(any e) {
					request['_parse'] = 'route handler parse issue';
					REQUEST._exception = e;
				}
			} else if(listFirst($script,"/") == "apps"){
				try{
					// logic for when site root is called
					
					REQUEST._meta['action'] = listLast($script,"/");
					REQUEST._meta['subappname'] = replace(listRest($script,"/"),"/","_","ALL");
					REQUEST._meta.subappname = left(REQUEST._meta.subappname,len(REQUEST._meta.subappname)-len(listLast(REQUEST._meta.action,"/"))-1);
					REQUEST._meta['action'] = listFirst(REQUEST._meta.action,".");
					REQUEST._meta['appname'] = listFirst(REQUEST._meta.subappname,"_");
					REQUEST._meta['routeType'] = "direct";
					REQUEST._meta['template'] = $script;
				} catch(any e) {
					REQUEST._meta['parse'] = 'route handler path issue';
				}
			} else if($script == "/index.cfm"){
				// logic for when site root is called
				REQUEST._meta['action'] = "index";
				REQUEST._meta['subappname'] = "main";
				REQUEST._meta['appname'] = "main";
				REQUEST._meta['routeType'] = "managed";
				REQUEST._meta['template'] = '/apps/#replace(REQUEST._meta.subappName,"_","/","ALL")#/#REQUEST._meta.action#.cfm';
			} else {
				REQUEST._meta['routeType'] = "undefined";
			}
			if(REQUEST._meta.appname == REQUEST._meta.subappname){ REQUEST._meta.subappname = "#REQUEST._meta.appname#_#REQUEST._meta.subappname#"; }
			
			
		} catch(any e) {
			REQUEST._note = "parse URL issue";
			request['_parse'] = 'failed';
			REQUEST.error = e;
		}
		
		REQUEST._progress = "request after var combo";
		
		// call to site objct to create request._appname & request._subappname
		try{
		REQUEST._api.site = APPLICATION.__api.site;
		REQUEST._progress = "REQUEST API site set.";
		} catch(any e) {
			SERVER._progress = "REQUEST API site assignment failed.";
			REQUEST['_onRequestStart'] = 'failed';
			REQUEST._exception = e;
		}
		
		try{
		REQUEST._api.app = APPLICATION.__api.app[REQUEST._meta.appname];
		REQUEST._progress = "REQUEST API app set.";
		} catch(any e) {
			REQUEST._progress = "REQUEST API app (#REQUEST._meta.appname#) assignment failed.";
			REQUEST['_onRequestStart'] = 'failed';
			REQUEST._exception = e;
			abort;
		}
		
		try{
		REQUEST._api.subapp = APPLICATION.__api.subapp[REQUEST._meta.subappname];
		REQUEST._progress = "REQUEST API subapp set.";
		} catch(any e) {
			REQUEST._progress = "REQUEST API app (#REQUEST._meta.subappname#) assignment failed.";
			REQUEST['_onRequestStart'] = 'failed';
			REQUEST._exception = e;
			abort;
		}
		/*
		if(REQUEST._onRequestStart == 'failed'){
			writeDump(var:REQUEST._exception,label:REQUEST._progress);
			abort;
		}
		*/
		</cfscript>
	</cffunction>
	
	<cffunction name="getDataClassPath">
		<cfreturn VARIABLES.dataClassPath>
	</cffunction>
	
</cfcomponent>