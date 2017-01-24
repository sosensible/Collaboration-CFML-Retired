<cfcomponent>

	<cffunction name="init" access="public">
		<cfargument name="target">
		<cfscript>
		var slash = APPLICATION.__server.slash;
		// local.target = ARGUMENTS.target;
		
		VARIABLES['client'] = {};
		VARIABLES.client['script'] = {};
		VARIABLES.client.script['directory'] = "#ARGUMENTS.directory##ARGUMENTS.target##slash#script#slash#";
		VARIABLES.client.script['path'] = "/#ARGUMENTS.target#/script/";
		VARIABLES.client['style'] = {};
		VARIABLES.client.style['directory'] = "#ARGUMENTS.directory##ARGUMENTS.target##slash#style#slash#";
		VARIABLES.client.style['path'] = "/#ARGUMENTS.target#/style/";
		VARIABLES.client['media'] = {};
		VARIABLES.client.media['directory'] = "#ARGUMENTS.directory##ARGUMENTS.target##slash#media#slash#";
		VARIABLES.client.media['path'] =  "/#ARGUMENTS.target#/media/";
		VARIABLES.client['service'] = {};
		VARIABLES.client.service['path'] = "/#ARGUMENTS.target#/service/";
		VARIABLES['data'] = {};
		VARIABLES.data['directory'] = "#ARGUMENTS.directory##ARGUMENTS.target##slash#data#slash#";
		VARIABLES.data['path'] = "/#ARGUMENTS.target#/data/";
		VARIABLES['include'] = {};
		VARIABLES.include['directory'] = "#ARGUMENTS.directory##ARGUMENTS.target##slash#include#slash#";
		VARIABLES.include['path'] = "#ARGUMENTS.path##ARGUMENTS.target#/include/";
		VARIABLES['layout'] = {};
		VARIABLES.layout['path'] = "/#ARGUMENTS.target#/layout/";
		VARIABLES['model'] = {};
		VARIABLES.model['classPath'] = "#ARGUMENTS.classPath##ARGUMENTS.target#.model.";
		VARIABLES['module'] = {};
		VARIABLES.module['path'] = "#ARGUMENTS.path##ARGUMENTS.target#/module/";
		VARIABLES['object'] = {};
		VARIABLES.object['classPath'] = "#ARGUMENTS.classPath##ARGUMENTS.target#.object.";
		
		return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getName">
		<cfreturn VARIABLES.name>
	</cffunction>
	
	<cffunction name="getClassPath">
		<cfreturn VARIABLES.classPath>
	</cffunction>
	
	<cffunction name="getDirectory">
		<cfreturn VARIABLES.directory>
	</cffunction>
	
	<cffunction name="getLayoutPath">
		<cfreturn VARIABLES.layoutPath>
	</cffunction>
	
	<cffunction name="getMetadata">
		<cfreturn duplicate(VARIABLES)>
	</cffunction>
	
	<cffunction name="getMediaDirectory">
		<cfreturn VARIABLES.mediaDirectory>
	</cffunction>
	
	<cffunction name="getMediaPath">
		<cfreturn VARIABLES.mediaPath>
	</cffunction>
	
	<cffunction name="getModelClassPath">
		<cfreturn VARIABLES.modelClassPath>
	</cffunction>
	
	<cffunction name="getModulePath">
		<cfreturn VARIABLES.modulePath>
	</cffunction>
	
	<cffunction name="getObjectClassPath">
		<cfreturn VARIABLES.objectClassPath>
	</cffunction>
	
	<cffunction name="getPath">
		<cfreturn VARIABLES.path>
	</cffunction>
	
	<cffunction name="getScriptDirectory">
		<cfreturn VARIABLES.scriptDirectory>
	</cffunction>
	
	<cffunction name="getScriptPath">
		<cfreturn VARIABLES.scriptPath>
	</cffunction>
	
	<cffunction name="getServicePath">
		<cfreturn VARIABLES.servicePath>
	</cffunction>
	
	<cffunction name="getStyleDirectory">
		<cfreturn VARIABLES.styleDirectory>
	</cffunction>
	
	<cffunction name="getStylePath">
		<cfreturn VARIABLES.stylePath>
	</cffunction>
	
</cfcomponent>