<cfcomponent extends="api">

	<cffunction name="init" access="public">
		<cfargument name="name">
		<cfargument name="classPath">
		<cfargument name="directory">
		<cfargument name="path">
		<cfscript>
		var slash = APPLICATION.__server.slash;
		
		VARIABLES['name'] = ARGUMENTS.name;
		VARIABLES['classPath'] = ARGUMENTS.classPath;
		VARIABLES['directory'] = ARGUMENTS.directory;
		VARIABLES['path'] = ARGUMENTS.path;
		
		this = super.init(
			target: "_app",
			classPath: VARIABLES.classPath,
			directory: VARIABLES.directory,
			path: VARIABLES.path
		);
		
		return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getMethodology" access="public">
		<cfreturn VARIABLES.methodology.name>
	</cffunction>
	
</cfcomponent>