<!--- 1.5.0.2 (Build 16) --->
<!--- Last Updated: 2009-07-13 --->
<!--- Created by John Farrar 2007-10-10 --->
<!--- Information: sosapps.com --->
<cfcomponent displayname="Object Factory"
	hint="I manage creation of class instances factory style.">
	<cfset variables.sosFactoryVersion = "1.5.0.2">

	<!--- Constructor Methods:Start --->
	<cffunction name="init" access="public" returntype="factory" output="no" 
		displayName="constructor" hint="I instantiate and return this object.">
		<cfargument name="environment" type="string" required="no" default="">

		<cfscript>
		var me = 0;

		// This checks which mode the factory class is being executed.
		if(ListLast(getMetaData(this).name,".") EQ "factory"){
			// This will will return the enviroment version of the sosFactory
			me = CreateObject("component","factory_#arguments.environment#").init(environment:ARGUMENTS.environment);
		} else {
			me = this;
		}

		VARIABLES.environment = ARGUMENTS.environment;

		// set up storage locations for persisted objects
		initServer();
		if(isDefined("application")){
			initApplication();
		}
		if(isDefined("session")){
			initSession();
		}
		initRequest();

		setTranslators();

		return me;
		</cfscript>

		<!---
		<cfdump var="#me#" label="#request.test#"><cfabort>
		--->

	</cffunction>

	<cffunction name="initApplication" output="false"
		displayName="application structure constructor" 
		hint="I create the structure needed for application object persistance.">
		<cfscript>
		if(! structKeyExists(APPLICATION,"__objectWarehouse")){
			APPLICATION["__objectWarehouse"] = {};
		}
		</cfscript>
    </cffunction>

	<cffunction name="initRequest" output="false"
		displayName="request structure constructor" 
		hint="I create the structure needed for request object persistance.">
		<cfscript>
		if(! structKeyExists(REQUEST,"__objectWarehouse")){
			REQUEST["__objectWarehouse"] = {};
		}
		</cfscript>
    </cffunction>

	<cffunction name="initServer" output="false"
		displayName="server structure constructor" 
		hint="I create the structure needed for server object persistance.">
		<cfscript>
		if(! structKeyExists(SERVER,"__objectWarehouse")){
			SERVER["__objectWarehouse"] = {};
		}
		</cfscript>
    </cffunction>

	<cffunction name="initSession" output="false"
		displayName="session structure constructor" 
		hint="I create the structure needed for session object persistance.">
		<cfscript>
		if(isDefined("session") && !structKeyExists(SESSION,"__objectWarehouse")){
			SESSION["__objectWarehouse"] = {};
		}
		</cfscript>
    </cffunction>
	<!--- Constructor Methods:End --->

	<!--- Public Methods:Start --->
	<cffunction name="decorate" output="false"
		displayname="getReference" 
		hint="I get a reference to an object and create it if not yet instantiated.">
		<cfargument name="class" type="string"
			displayname="class" hint="I am the class to decorate." />
		<cfargument name="with" type="string"
			displayname="with" hint="I am the class that decorates." />
		<cfscript>
		// make sure storage locations for persisted objects exist
		initSession();
		initRequest();
		</cfscript>
	</cffunction>

	<cffunction name="getRef" output="false" access="public"
		displayname="getReference" 
		hint="I get a reference to an object and create it if not yet instantiated.">
		<cfargument name="class" type="string"
			displayname="class" hint="I am the class to instatiate." />
		<cfargument name="new" type="string" default="false"
			displayname="new instance" hint="When true I force a new instance of a class to be instantiated." />
		<cfscript>
		var strPersist = getScope(class:ARGUMENTS.class);
		var strPtr = ""; // this is a pointer to the scope structure for this object;
		// return structure to manage environment aliases and eliminate and/or translate to class paths
		var strTranslate = translateClass(class:strPersist.class);

		// make sure storage locations for persisted objects exist
		initSession();
		initRequest();

		switch(strPersist.scope){
			case 'server':
				strPtr = SERVER.__objectWarehouse;
				break;
			case 'application':
				strPtr = APPLICATION.__objectWarehouse;
				break;
			case 'session':
				strPtr = SESSION.__objectWarehouse;
				break;
			case 'request':
				strPtr = REQUEST.__objectWarehouse;
				break;
			default:
				// transient object
				strPtr = ARGUMENTS.transient;
		}
		if(! structKeyExists(strPtr,strTranslate) || ARGUMENTS.new){
			// return instantiate(ARGUMENTS.class);
		} else {
			return strPtr[strTranslate];
		}
		</cfscript>
	</cffunction>

	<cffunction name="setRef" output="false" access="public"
		displayname="getReference" 
		hint="I get a reference to an object and create it if not yet instantiated.">
		<cfscript>
		// make sure storage locations for persisted objects exist
		initSession();
		initRequest();
		</cfscript>
	</cffunction>

	<cffunction name="get_metaFunctions" output="false" access="private">
		<cfargument name="metaClass">
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

	<cffunction name="get_metaProperties" output="false" access="private">
		<cfargument name="metaClass">
		<cfargument name="properties" default="#arrayNew(1)#">
		<cfscript>
		var _properties = ARGUMENTS.properties;
		var listProperties = "";
		var i = {};
		var cntProp = 0;

		for(i.list=1;i.list<=arrayLen(_properties);i.list++){
			listProperties = listAppend(listProperties,_properties[i.list].dioname & "_@@@_" & _properties[i.list].dioclass);
		}

		if(structKeyExists(ARGUMENTS.metaClass,"PROPERTIES")){
			cntProp = arrayLen(ARGUMENTS.metaClass.PROPERTIES);
			for(i.prop=1;i.prop<=cntProp;i.prop++){
				i.property = ARGUMENTS.metaClass.PROPERTIES[i.prop];
				if(!listFind(listProperties, i.property.dioname & "_@@@_" & i.property.dioclass)){
					arrayAppend(_properties,duplicate(ARGUMENTS.metaClass.PROPERTIES[i.prop]));
				}
			}
		}

		if(structKeyExists(ARGUMENTS.metaClass,"EXTENDS")){
			_properties = get_metaProperties(
				metaClass:	ARGUMENTS.metaClass.EXTENDS,
				properties:	_properties
			);
		}

		return _properties;
		</cfscript>
	</cffunction>

	<cffunction name="instantiate" output="true"
		displayname="instatiate" hint="I instantiate an instance of a class object.">
		<cfargument name="class" type="string"
			displayname="class" hint="I am the class to instatiate." />
		<cfargument name="transient" type="struct" required="false" default="#structNew()#"
			displayname="transient" hint="I am the class to instatiate. This is mainly used for recursive creation of components." />
		<cfargument name="new" type="string" default="false"
			displayname="new instance" hint="When true I force a new instance of a class to be instantiated." />
		<cfargument name="ofcStruct" type="struct" default="#structNew()#"
			displayname="ofcStruct" hint="I am the structure for onFactoryCreate method call." />
		<cfscript>
		var instance = ""; // current instantiated object
		var createMode = false;
		var dio = []; // dependency injected objects array
		var i = 0; // i loop counter
		var ai = 0; // array item for dio loop
		var myDIO = ""; // a dependency object to inject into a method. 
		var myClass = translateClass(ARGUMENTS.class);
	//	var getInjectionObjects = injectionObjects(myClass);
		// return structure to manage scope persistance and eliminate alias from class
		var strPersist = getScope(class:ARGUMENTS.class);
		var strPtr = {}; // this is a pointer to the scope structure for this object;
		// return structure to manage environment aliases and eliminate and/or translate to class paths
		var strTranslate = translateClass(class:strPersist.class);
		var metaClass = "";
		var metaProperties = [];
		var metaFunctions = "";

		// make sure storage locations for persisted objects exist
		initSession();
		initRequest();

		switch(strPersist.scope){
			case 'server':
				strPtr[0] = SERVER.__objectWarehouse;
				break;
			case 'application':
				strPtr[0] = APPLICATION.__objectWarehouse;
				break;
			case 'session':
				strPtr[0] = SESSION.__objectWarehouse;
				break;
			case 'request':
				strPtr[0] = REQUEST.__objectWarehouse;
				break;
			default:
				// transient object
				strPtr[0] = ARGUMENTS.transient;
		}

		if(! structKeyExists(strPtr[0],strTranslate) || ARGUMENTS.new){
			strPtr[0][strTranslate] = createObject("component",strTranslate);
			createMode = true;
			arrayAppend(REQUEST._log,{loc='sosFactory.instatiate(#strTranslate#)',note='created'});
		}
		instance = strPtr[0][strTranslate];
		// get the metadata for requested class
		metaClass = getMetadata(instance);
		metaProperties = get_metaProperties(metaClass);
		metaFunctions = get_metaFunctions(metaClass);
		if(arrayLen(metaProperties)){
			for(i=1;i<=arrayLen(metaProperties);i++){
				if(metaProperties[i].type == "dio"){
					ai++;

					dio[ai] = structCopy(metaProperties[i]);
					strPersist = getScope(dio[ai].dioclass);
					strTranslate = translateClass(class:strPersist.class);
					arrayAppend(REQUEST._log,{loc='sosFactory.instatiate(#strPersist.scope#.#strTranslate#)',note='property #dio[ai].name#'});
					switch(strPersist.scope){
						case 'server':
							strPtr[ai] = SERVER.__objectWarehouse;
							break;
						case 'application':
							strPtr[ai] = APPLICATION.__objectWarehouse;
							break;
						case 'session':
							strPtr[ai] = SESSION.__objectWarehouse;
							break;
						case 'request':
							strPtr[ai] = REQUEST.__objectWarehouse;
							break;
						default:
							// transient object
							strPtr[ai] = ARGUMENTS.transient;
					}
					arrayAppend(REQUEST._log,{ow=structKeyList(APPLICATION.__objectWarehouse)});
					if(! structKeyExists(strPtr[ai],strTranslate)){
						strPtr[ai][strTranslate] = createObject("component",strTranslate);
						arrayAppend(REQUEST._log,{property_note='created #strPersist.scope# - #strTranslate# from property itteration'});
					}
					instance._set_dio(
						sequence:ai,
						name:dio[ai].dioname,
						object:strPtr[ai][strTranslate],
						access:dio[ai].dioaccess
					);
				}
			}
		}
		// this is to execute automated methods
		if(listFindNoCase(metaFunctions,"onFactoryCreate") AND createMode){
			if(structKeyExists(ARGUMENTS,"ofcArgs")){
				instance.onFactoryCreate(ofcArgs:ARGUMENTS.ofcArgs);
			} else {
				instance.onFactoryCreate();
			}
		}
		arrayAppend(REQUEST._log,{instance=getMetaData(instance)});
		return instance;
		</cfscript>
	</cffunction>

	<cffunction name="mixin" output="false"
		displayName="mixin" hint="I take the functions from one object and inject them into the other.">
		<cfargument name="source" hint="I am the source object to pull out the functions and structure." />
		<cfargument name="target" hint="I am the target object to inject in the functions and structure." />
		<cfscript>
		ARGUMENTS.target.__blender = __mixer;
		ARGUMENTS.target.__blender(ARGUMENTS.source);
		</cfscript>
	</cffunction>
	<!--- Public Methods:End --->

	<!--- Special Methods:Start --->
	<cffunction name="__blender">
		<cfargument name="mixObject"
			displayname="mixObject" hint="I object to mix in." />
		<cfscript>
		// Public variables should be avoided and focus mixin objects on just methods.
		structAppend(this,target);
        structAppend(variables,target);
		</cfscript>
	</cffunction>
	<!--- Special Methods:End --->

	<!--- Private Methods:Start --->
	<cffunction name="getScope"  output="false" access="private" 
		displayname="getScope" hint="I set the persistant scope translators for this environment.">
		<cfargument name="class" type="string"
			displayname="class" hint="I am the class to check the persistance scope on." />
		<cfscript>
		var alias = "@@APPLICATION@@,@@SESSION@@,@@REQUEST@@,@@SERVER@@";
		var aliasCount = listLen(alias);
		var scopes = "APPLICATION,SESSION,REQUEST,SERVER";
		var myResult = {
			persist = false,
			scope = "",
			class = ARGUMENTS.class
		};
		var i = 0;

		for(i=1;i<=aliasCount;i++){
			if(uCase(ListFirst(ARGUMENTS.class,".")) == listGetAt(alias,i)){
				myResult.scope = listGetAt(scopes,i);
				myResult.persist = true;
				myResult.class = listDeleteAt(ARGUMENTS.class,1,".");
				i=aliasCount;
			}
		}

		return myResult;
		</cfscript>
	</cffunction>

	<cffunction name="translateClass" output="false" access="public" 
		displayname="translateClass" 
		hint="I translate the a class path alias if found.">
		<cfargument name="class" required="true" type="string" 
			displayname="class" hint="I am the class path with a possible translation hinted alias." />
		<cfscript>
		var keys = structKeyList(VARIABLES.translate);
		var key = "";
		var position = 0;
		var i = 0;

		for(i=1;i<=listLen(keys);i++){
			key = listGetAt(keys,i);
			position = listFindNoCase(ARGUMENTS.class,key,".");
			if(position){
				ARGUMENTS.class = listSetAt(ARGUMENTS.class,position,VARIABLES.translate[key],".");
			}
		}

		return ARGUMENTS.class;
		</cfscript>
	</cffunction> 
	<!--- Private Methods:End --->

	<!--- Super Methods:Start --->
	<cffunction name="setTranslators" output="false"
		displayname="setTranslators" hint="I set the translators for this environment.">
		<cfscript>
		VARIABLES.translate = {};
		</cfscript>
	</cffunction>
	<!--- Super Methods:End --->

</cfcomponent>