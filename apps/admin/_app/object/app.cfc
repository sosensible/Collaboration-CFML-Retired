<cfcomponent extends="share.objects.appestry.app">

	<cffunction name="init" access="public">
		<cfargument name="name">
		<cfargument name="classPath">
		<cfargument name="directory">
		<cfargument name="path">
		<cfscript>
		VARIABLES['methodology'] = {
			name = 'colaboration',
			minversion = 3
		};
		
		return super.init(
			name:ARGUMENTS.name,
			classPath:ARGUMENTS.classPath,
			directory:ARGUMENTS.directory,
			path:ARGUMENTS.path
		);
		</cfscript>
	</cffunction>

</cfcomponent>