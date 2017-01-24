<cfcomponent hint="sosFactory Base Object Class">
	<cffunction name="onFactoryCreate">
		<cfscript>
		</cfscript>
	</cffunction>

	<cffunction name="init">
		<cfscript>
		writeDump("...fbo constructor called...");
		return this;
		</cfscript>
	</cffunction>

	<cffunction name="get_vlist" access="public" output="false">
		<cfreturn structKeyList(VARIABLES)>
	</cffunction>

	<cffunction name="get_tlist" access="public" output="false">
		<cfreturn structKeyList(THIS)>
	</cffunction>

	<cffunction name="get_tCheck" access="public" output="false">
		<cfargument name="checker" />
		<cfscript>
		var myList = structKeyList(this);
		var myFunc = get_metaFunctions();
		var myFind = listFindNoCase(myList,ARGUMENTS.checker);
		if(myFind && !listFindNoCase(myFunc,listGetAt(myList,myFind))){
			return true;
		} else {
			return false;
		}
		</cfscript>
	</cffunction>

	<cffunction name="get_vCheck" access="public" output="false">
		<cfargument name="checker" />
		<cfscript>
		var myList = structKeyList(variables);
		var myFunc = get_metaFunctions();
		var myFind = listFindNoCase(myList,ARGUMENTS.checker);
		if(myFind && !listFindNoCase(myFunc,listGetAt(myList,myFind))){
			return true;
		} else {
			return false;
		}
		</cfscript>
	</cffunction>

	<cffunction name="get_metaFunctions" output="false" access="private">
		<cfargument name="metaClass" default="#this#">
		<cfargument name="functionList" default="">
		<cfscript>
		var _functions = "";
		var _functionList = ARGUMENTS.functionList;
		var i = {};

		if(structKeyExists(ARGUMENTS.metaClass,"FUNCTIONS")){
			_functions = duplicate(ARGUMENTS.metaClass.FUNCTIONS);
			for(i.list=1;i.list<=arrayLen(_functions);i.list++){
				newFunc = _functions[i.list].name;
				if(!listFindNoCase(_functionList,newFunc)){
					_functionList = listAppend(_functionList,newFunc);
				}
			}
		}

		if(structKeyExists(ARGUMENTS.metaClass,"EXTENDS")){
			_functionList = get_metaFunctions(
				metaClass:	ARGUMENTS.metaClass.EXTENDS,
				functionList:	_functionList
			);
		}

		return _functionList;
		</cfscript>
	</cffunction>

	<cffunction name="_set_dio" access="public">
		<cfargument name="name">
		<cfargument name="object">
		<cfargument name="access" default="">
		<cfscript>
		var md = getMetadata(this);
		if(ARGUMENTS.access == "private"){
			VARIABLES[ARGUMENTS.name] = ARGUMENTS.object;
		} else {
			THIS[ARGUMENTS.name] = ARGUMENTS.object;
		}
		arrayAppend(REQUEST._log,{md=md.name,loc='_set_dio (#ARGUMENTS.access# - #ARGUMENTS.name#)'});
		</cfscript>
	</cffunction>
</cfcomponent>