<cfcomponent displayname="sosRoutes" hint="I manage conversion of request URL path to routing variables.">
	<cffunction name="init" access="public" returntype="string">
		<cfscript>
		return this;
		</cfscript>
	</cffunction>

	<cffunction name="getRoute" output="false">
		<cfscript>
		var tmp = {
				route = [],
				cfg = {
					app = {},
					bundle = {}
				},
				__bundle = "main",
				__app = "main",
				path = "main/",
				__controller = "index"
		};
		tmp.pi = cgi.PATH_INFO;
		switch (cgi.PATH_INFO){
			case "/": {
				break;
			}
			case "/index.cfm": {
				break;
			}
			default: {
				tmp.route = listToArray(cgi.PATH_INFO,"/",true);
				tmp.r = duplicate(tmp.route);
				arrayDeleteAt(tmp.route,1);
				// *** set specified bundle/app selections ***
				if(arrayLen(tmp.route)){
					if(len(tmp.route[1])){
						tmp.__app = listFirst(tmp.route[1],"_");	
						if(listLen(tmp.route[1],"_")>1){
							tmp.__subapp = listRest(tmp.route[1],"_");
						} else {
							tmp.__subapp = tmp.__app;
						}
						arrayDeleteAt(tmp.route,1);
					}
				}
				// *** set specified controller ***
				if(arrayLen(tmp.route)){
					if(len(tmp.route[1])){
						tmp.__controller = tmp.route[1];
					}
					arrayDeleteAt(tmp.route,1);
				}
				break;
			}
		}

		// *** calculate bundle/app path ***
		tmp.cfg.app.path = "#tmp.__app#/";
		if(tmp.__subapp == tmp.__subapp){
			tmp.cfg.subapp.path = "#tmp.__app#/";
		} else {
			tmp.cfg.subapp.path = "#tmp.__app#/app/#replace(tmp.__subapp,'_','/app/',"ALL")#/";
		}

		request.__cfg.app.path = "/apps/#tmp.cfg.app.path#";
		request.__cfg.subapp.path = "/apps/#tmp.cfg.subapp.path#";
		request.__controller = "#tmp.__controller#";
		request.__app = "#tmp.__app#";
		request.__subapp = "#tmp.__subapp#";

		/*
		writeDump(tmp);
		writeDump(request);
		abort;
		*/
		</cfscript>
	</cffunction>

</cfcomponent>