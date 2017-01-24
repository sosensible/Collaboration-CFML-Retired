<cfcomponent name="_coprocessor" output="false">
	<cfparam name="REQUEST._remote" default="false">
	<cfscript>
	if(REQUEST._remote){
		onRemoteStart();
	}
	</cfscript>
	<cffunction name="init" access="public" output="false">
		<cfargument name="configuration" required="true">
		<cfargument name="contentObj" default="#REQUEST._content#">
		<cfargument name="api" default="#structNew()#">
		<cfargument name="attributes" default="#structNew()#">
		<cfscript>
		var coProcessorObj = '';
		var currRoot = arguments.configuration.current.root;
		var dirSlash = "/";
		var except = {};
		
		VARIABLES._api = ARGUMENTS.api;
		VARIABLES.attributes = ARGUMENTS.attributes;
		// Set up the configuration variables that the tags will need
		VARIABLES.config = structNew();
		VARIABLES.config.action = listLast(currRoot.coProcessorClassPath,".");
		if(!structKeyExists(request,"log")){ request.log = []; }
		try{
			if(!structKeyExists(ARGUMENTS,'configuration')){ 
				arrayAppend(request.log,'ARGUMENTS.configuration'); 
			} else if(!structKeyExists(ARGUMENTS.configuration,'current')){
				arrayAppend(request.log,'ARGUMENTS.configuration.current');
			} else if(!structKeyExists(ARGUMENTS.configuration.current,'root')){
				arrayAppend(request.log,'ARGUMENTS.configuration.current.root');
			} else if(!structKeyExists(ARGUMENTS.configuration.current.root,'slash')){
				arrayAppend(request.log,'ARGUMENTS.configuration.current.root.slash');
			}
			if(!structKeyExists(arguments.configuration.current.root,'slash')){ 
				arrayAppend(request.log,'arguments.configuration.current.root missing'); 
			} else {
				arrayAppend(request.log,'arguments.configuration.current.root found');
			}
			VARIABLES.config.slash = arguments.configuration.current.root.slash;
			arrayAppend(request.log,"current value is #VARIABLES.config.slash#");
		} catch(any except){ 
			VARIABLES.config.slash = arguments.configuration.server.root.slash;
			arrayAppend(request.log,"server");
		}
		VARIABLES.config.actionPath = replace(listDeleteAt(currRoot.coProcessorClassPath,listLen(currRoot.coProcessorClassPath,"."),"."),".","/","ALL");
		VARIABLES.config.actionPath = "/" & replace(VARIABLES.config.actionPath,"\","/","ALL") & "/";
		VARIABLES.config.coClassPath = currRoot.coProcessorClassPath;
		VARIABLES.config.classPath = arguments.configuration.server.shareClasspath;
		VARIABLES.config.sharePath = arguments.configuration.server.sharePath;
		VARIABLES.config.directory = currRoot.coprocessordirectory;
		// VARIABLES.config.directoryPath = currRoot.coprocessordirectoryPath;
		VARIABLES.config.webService = "/" & replace(currRoot.coProcessorClassPath,".","/","all") & ".cfc";
		this.content = arguments.contentObj;
		//Create the coProcessor object
		/*
		try {
			coProcessorObj = createObject("component","#currRoot.coProcessorClassPath#");
			return coProcessorObj;
		} catch (any err) {
			return this;
			// coProcessorObj = createObject("component","share.objects.co.co");
		}
		// Mixin the coProcessor
		structAppend(this,coProcessorObj);
		structAppend(variables,coProcessorObj);
		*/
		return this;
		</cfscript>
	</cffunction>

	<cffunction name="createAttributeList" output="false" access="public" returntype="String">
		<cfargument name="attributes">
		<cfargument name="standardattributes">
		<cfargument name="rootStruct">
		<cfscript>
		var attributeStruct = arguments.attributes;
		var _attributes = arguments.attributes;
		var attributeList = '';
		var iStructKey = '';
		var root = arguments.rootStruct;
		for (iStructKey in _attributes) {
			if (NOT listFindNoCase(arguments.standardAttributes,iStructKey) AND isSimpleValue(_attributes[iStructKey]) AND ((len(iStructKey) GTE 2)  AND (left(iStructKey,1) NEQ "__"))) {
				attributeList = attributeList & ' ' & iStructKey & '="#_attributes[iStructKey]#"';
			}
		}
		return attributeList;
		</cfscript>
	</cffunction>

	<cffunction name="createPageState" output="false" access="public">

	</cffunction>

	<cffunction name="checkAuthorization" displayname="Is Authorized" hint="This checks against the current user's roles for authorization." access="public" returntype="boolean" output="false">
		<cfargument name="roles" required="no" default="">
		<cfargument name="permissions" required="no" default="">
		<cfargument name="app" required="no" default="">

		<!--- isAuthorized body --->
		<cfscript>
		var myReturn = structNew();
		var iSet = "";
		var iRoles = "";
		var checkAll = FALSE;
		var checkSet = TRUE;
		var permission = "";
		</cfscript>

		<cfif isSimplevalue(ARGUMENTS.permissions)>
			<cfloop index="iSet" list="#ARGUMENTS.roles#" delimiters="|">
				<cfset checkSet = TRUE>
				<cfloop index="iRole" list="#iSet#">
					<cfif find("__",iRole)>
						<cfset permission = iRole>
					<cfelse>
						<cfif len(ARGUMENTS.app)>
							<cfset permission = "#ARGUMENTS.app#__#iRole#">
						<cfelse>
							<cfset permission = "#iRole#">
						</cfif>
					</cfif>
					<cfif not listfindnocase(ARGUMENTS.permissions,permission)>
						<cfset checkSet = FALSE>
					</cfif>
				</cfloop>
				<cfif checkSet>
					<cfset checkAll = TRUE>
				</cfif>
			</cfloop>
		<cfelseif isObject(ARGUMENTS.permissions)>
			<cfReturn ARGUMENTS.permissions.isAuthorized(roles:ARGUMENTS.roles, bundle:ARGUMENTS.bundle)>
		</cfif>

		<cfscript>
		if(len(arguments.roles) EQ 0) {
			return true;
		} else {
			return checkAll;
		}
		</cfscript>
	</cffunction>
	<cffunction name="get_webService" output="false" access="public">
		<cfscript>
		return VARIABLES.config.webService & "?wsdl";
		</cfscript>
	</cffunction>

	<cffunction name="get_directory" output="false" access="public">
		<cfscript>
		return VARIABLES.config.directory;
		</cfscript>
	</cffunction>

	<cffunction name="get_directoryPath" output="false" access="public">
		<cfscript>
		/* TODO: Make this determine if a file is on path and return a clean path string. */
		return VARIABLES.config.directory;
		</cfscript>
	</cffunction>

	<cffunction name="get_actionPath" output="false" access="public">
		<cfscript>
		return VARIABLES.config.actionPath;
		</cfscript>
	</cffunction>

	<cffunction name="get_ajaxService" output="false" access="public">
		<cfargument name="method" default="">
		<cfscript>
		if(len(arguments.method)){
			return VARIABLES.config.webService & "?method=#ARGUMENTS.method#";
		} else {
			return VARIABLES.config.webService;
		}
		</cfscript>
	</cffunction>

	<cffunction name="fieldParam" output="false">
		<cfargument name="initAttribs">
		<cfargument name="tagName">
		<cfargument name="value">
		<cfscript>
			returnValue = arguments.value;
			if (structKeyExists(arguments.initAttribs,arguments.tagName)) {
				returnValue = arguments.initAttribs[arguments.tagName];
			}
			return returnValue;
		</cfscript>
	</cffunction>

	<cffunction name="get_sharePath" access="public" output="false">
		<cfreturn variables.config.sharePath>
	</cffunction>

	<cffunction name="get_shareClassPath" access="public" output="false">
		<cfreturn variables.config.classPath>
	</cffunction>


	<cffunction name="mergeAttributes" output="false" access="public" returntype="struct">
		<cfargument name="attributes">
		<cfargument name="rootStruct">
		<cfscript>
		var attributeStruct = arguments.attributes;
		var _attributes = arguments.attributes;
		var iStructKey = '';
		var root = arguments.rootStruct;
		/* for (iStructKey in _attributes) {
			if (structKeyExists(root,"_preDom")
				AND _attributes.id NEQ ''
				AND structKeyExists(root._preDom,_attributes.id)
				AND structKeyExists(root._preDom["#_attributes.id#"],iStructKey)) {
				attributeStruct["#iStructKey#"] = root._preDom["#_attributes.id#"]["#iStructKey#"];
			}
		} */
		if (structKeyExists(root,"_preDom") AND structKeyExists(root._preDom,_attributes.id)) {
			for (iStructKey IN root._preDom[_attributes.id]) {
				try{
					_attributes[iStructKey] = root._preDom[_attributes.id][iStructKey];
				} catch(any e){
					if(findNoCase(iStructKey,e.message) && findNoCase("undefined",e.message)){
						_attributes[iStructKey] = "";
					} else {
						// not sure what to do here
						_throw(
							message:e.message,
							detail:e.detail,
							errorcode:e.errorcode,
							type:e.type
						);
					}
				}
			}
		}
		return _attributes;
		</cfscript>
	</cffunction>

	<cffunction name="purgeAttributes" output="false" access="public">
		<cfargument name="attr">
		<cfargument name="purgeList">
		<cfscript>
		var ATTRIBUTES = ARGUMENTS.attr;
		var i = {};
		var key = "";

		for(i.key=1;i.key<=listLen(ARGUMENTS.purgeList);i.key++){
			key = listGetAt(ARGUMENTS.purgeList,i.key);
			if(structKeyExists(ATTRIBUTES,key) && len(trim(ATTRIBUTES[key])) == 0){
				structDelete(ATTRIBUTES,key);
			}
		}
		</cfscript>
	</cffunction>

	<cffunction name="mixin" access="public">
		<cfargument name="mixinCode" required="true">
		<cfset structAppend(this,arguments.mixinCode)>
		<cfset structAppend(variables,arguments.mixinCode)>
		<cfset arguments.mixinCode.inject(this)>
	</cffunction>

	<cffunction name="_location" output="false" access="public">
		<cfargument name="url" required="true">
		<cfargument name="addtoken" default="false">
		<cfargument name="type" default="cf">
		<cfargument name="typeTarget" default="">

		<cfscript>
		var locationScript = "";
		var myContent = "";

		if(arguments.type EQ "cfajax"){
			if(NOT structKeyExists(arguments,"typeTarget"))
				_throw(
					message:"Missing type target argument",
					detail:"When using _location() with type of 'cfajax' it must have a declared argument for typeTarget. This tells which AJAX dom element ID to target the content towards."
				);
			_htmlHead('
				<script type="text/javascript">
				ColdFusion.navigate("#arguments.url#", "#arguments.typeTarget#");
				</script>
			');
			_abort();
		} else if(arguments.type EQ "js") {
			_htmlHead('
				<script type="text/javascript">
				document.location.href = "#arguments.url#";
				</script>
			');
			_abort();
		}
		</cfscript>
		<cflocation url="#arguments.url#" addtoken="#arguments.addtoken#">
		<cfabort> 
	</cffunction>

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

	<cffunction name="updatePageState" output="false" access="public">

	</cffunction>

	<cffunction name="initFields" access="public" output="false">
		<cfargument name="init">
		<cfargument name="fields">

		<cfscript>
		var _preDom = ARGUMENTS.init;
		var _fields = ARGUMENTS.fields;
		var curField = '';
		var i = 1;

		for(i=1; i<= listLen(_fields); i++) {
			curField = listGetAt(_fields,i);
			if (!structKeyExists(_preDom,curField)) {
				_preDom[curField] = '';
			}
		}
		</cfscript>
	</cffunction>

	<cffunction name="paramDomElement" access="public" output="false">
		<cfargument name="init" required="true">
		<cfargument name="field" required="true">
		<cfargument name="listFields" default="">
		<cfargument name="default" default="">
		<cfargument name="condition" default="true">

		<cfscript>
		var _preDom = ARGUMENTS.init;
		var myKey = "value";
		var tmp="";

		if(!structKeyExists(_preDom,ARGUMENTS.field)){
			_preDom[ARGUMENTS.field] = {};
		}
		if(listFindNoCase(ARGUMENTS.listFields,ARGUMENTS.field)){
			myKey = "selected";
		}
		if(!structKeyExists(_preDom[ARGUMENTS.field],myKey)){
			_preDom[ARGUMENTS.field][myKey] = "";
		}
		tmp = _preDom[ARGUMENTS.field][myKey];
		if(ARGUMENTS.condition && !len(tmp)){
			_preDom[ARGUMENTS.field][myKey] = ARGUMENTS.default;
		}
		</cfscript>
	</cffunction>

	<cffunction name="data2preDom" access="public" output="false">
        <cfargument name="init">
        <cfargument name="data">
        <cfargument name="fields">
        <cfargument name="listFields" default="">
		<cfargument name="prefix" default="">
		<cfargument name="alias" default="">
       
        <cfscript>
        var _preDom = ARGUMENTS.init;
        var i = 0;
        var field = "";
       
		if(isQuery(ARGUMENTS.data)){
			if(ARGUMENTS.data.recordCount){
				for(i=1;i<=listLen(ARGUMENTS.fields);i++){
					field = listGetAt(ARGUMENTS.fields,i);
					if(! structKeyExists(_preDom,ARGUMENTS.prefix & field) OR !isStruct(_preDom[ARGUMENTS.prefix & field]))
						_preDom[ARGUMENTS.prefix & field] = structNew();
					_preDom[ARGUMENTS.prefix & field].value = ARGUMENTS.data[field];
				}
				for(i=1;i<=listLen(ARGUMENTS.listFields);i++){
					field = listGetAt(ARGUMENTS.listFields,i);
					if(! structKeyExists(_preDom,ARGUMENTS.prefix & field))
						_preDom[ARGUMENTS.prefix & field] = structNew();
					_preDom[ARGUMENTS.prefix & field].selected = ARGUMENTS.data[field];
				}
			}
		} else if(isStruct(ARGUMENTS.data)){
			for(i=1;i<=listLen(ARGUMENTS.fields);i++){
				field = listGetAt(ARGUMENTS.fields,i);
				if(! structKeyExists(_preDom,ARGUMENTS.prefix & field))
					_preDom[ARGUMENTS.prefix & field] = structNew();
				if(structKeyExists(ARGUMENTS.data,ARGUMENTS.prefix & field))
					_preDom[ARGUMENTS.prefix & field].value = ARGUMENTS.data[field];
			}
			for(i=1;i<=listLen(ARGUMENTS.listFields);i++){
				field = listGetAt(ARGUMENTS.listFields,i);
				if(! structKeyExists(_preDom,ARGUMENTS.prefix & field))
					_preDom[ARGUMENTS.prefix & field] = structNew();
				if(structKeyExists(ARGUMENTS.data,field))
					_preDom[ARGUMENTS.prefix & field].selected = ARGUMENTS.data[field];
			}
		}
       
        return _preDom;
        </cfscript>
    </cffunction>
    
    <cffunction name="structCollection2Query" access="public" output="false">
		<cfargument name="array" default="#arraNew(1)#">
		<cfscript>
	    var qry = queryNew("");
	    var i={};
	    var rows = arrayLen(ARGUMENTS.array); 
	    var tmp = {};

	    if(! rows){
	    	return qry;
	    } else {
			tmp.column = structKeyArray(ARGUMENTS.array[1]);
		//	writeDump(tmp);abort;
			tmp.cols = arrayLen(tmp.column);
			qry = QueryNew(arrayToList(tmp.column));
			queryAddRow(qry, rows);
			for(i.row=1;i.row <= rows; i.row++){
				for(i.col = 1;i.col <= tmp.cols; i.col++){
					querySetCell(qry, tmp.column[i.col], ARGUMENTS.array[i.row][tmp.column[i.col]], i.row);
				} 
			}
			return qry;
		}
		</cfscript>
	</cffunction>
    <cfscript>

	</cfscript>

	<cffunction name="_invertQueryStruct" access="public" output="false">
		<cfargument name="query">
		<cfargument name="fields" default="">
		<cfscript>
		var inverted = [];
		var fieldList = query.ColumnList;
		var i = {};
		var field = "";
		var count = {};

		if(len(trim(ARGUMENTS.fields))){
			fieldList = ARGUMENTS.fields;
		}
		count.field = listLen(fieldList);
		for(i.field=1;i.field<=count.field;i.field++){
			field = listGetAt(fieldList,i.field);
			writeOutput("#field#<br>");
			count.rows = ARGUMENTS.query.recordCount;
			for(i.row=1;i.row<=count.rows;i.row++){
				inverted[i.row][field] = ARGUMENTS.query[field][i.row];
			}
		}
		return inverted;
		</cfscript>
	</cffunction>

	<cffunction name="parse_mediaAlias" access="public" output="false">
		<cfargument name="api">
		<cfargument name="parseText">
		<cfscript>
		var alias = "";
		var aliasResult = ARGUMENTS.parseText;

		if(len(aliasResult) && refind("^@(.)*@",aliasResult)){
			alias = listFirst(aliasResult,"@");
			if(structKeyExists(ARGUMENTS.api,alias)){
				aliasResult = replace(aliasResult,"@#alias#@",ARGUMENTS.api[alias].get_mediaPath());
			}
		}

		return aliasResult;
		</cfscript>
	</cffunction>

	<!--- extended tags to functions --->
	<cffunction name="_createCookie">
		<cfargument name="name" required="true">
		<cfargument name="value" required="false" default="">
		<cfargument name="domain" required="false" default="">
		<cfargument name="expires" required="false" default="">
		<cfargument name="path" required="false" default="">
		<cfargument name="secure" required="false" default="">

		<cfset var cookieString = '#arguments.name#=#arguments.value#'>

		<cfif arguments.expires NEQ ''>
			<cfset cookieString = cookieString & ";expires=#arguments.expires#">
		</cfif>

		<cfif arguments.path NEQ ''>
			<cfset cookieString = cookieString & ";path=#arguments.path#">
		</cfif>

		<cfif arguments.domain NEQ ''>
			<cfset cookieString = cookieString & ";domain=#arguments.domain#">
		</cfif>

		<cfif arguments.secure NEQ ''>
			<cfset cookieString = cookieString & ";secure=#arguments.secure#">
		</cfif>
		<cfheader name="Set-Cookie"
				  value="#cookieString#">

	</cffunction>

	<cffunction name="_formatter">
		<cfargument name="format">
		<cfargument name="string">
		<cfargument name="args" required="false">
		<cfif structKeyExists(arguments,'args')>
			<cfparam name="arguments.args.formatterType" default="">
			<cfparam name="arguments.args.formatterMask" default="">
			<cfparam name="arguments.args.formatterVersion" default="">
		</cfif>
		<cfswitch expression="#arguments.format#">
			<cfcase value="date">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterMask)>
					<cfreturn dateFormat(arguments.string,arguments.args.formatterMask)>
				<cfelse>
					<cfreturn dateFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="decimal">
				<cfreturn decimalFormat(arguments.string)>
			</cfcase>
			<cfcase value="dollar">
				<cfreturn dollarFormat(arguments.string)>
			</cfcase>
			<cfcase value="htmlCode">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterVersion)>
					<cfreturn htmlCodeFormat(arguments.string,arguments.args.formatterVersion)>
				<cfelse>
					<cfreturn htmlCodeFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="htmlEdit">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterVersion)>
					<cfreturn htmlEditFormat(arguments.string,arguments.args.formatterVersion)>
				<cfelse>
					<cfreturn htmlEditFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="lsCurrency">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterType)>
					<cfreturn lsCurrencyFormat(arguments.string,arguments.args.formatterType)>
				<cfelse>
					<cfreturn lsCurrencyFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="lsDate">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterMask)>
					<cfreturn lsDateFormat(arguments.string,arguments.args.formatterMask)>
				<cfelse>
					<cfreturn lsDateFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="lsEuroCurrency">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterType)>
					<cfreturn lsEuroCurrencyFormat(arguments.string,arguments.args.formatterType)>
				<cfelse>
					<cfreturn lsEuroCurrencyFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="lsNumber">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterMask)>
					<cfreturn lsNumberFormat(arguments.string,arguments.args.formatterMask)>
				<cfelse>
					<cfreturn lsNumberFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="lsTime">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterMask)>
					<cfreturn lsTimeFormat(arguments.string,arguments.args.formatterMask)>
				<cfelse>
					<cfreturn lsTimeFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="number">
				<cfif structKeyExists(arguments,"args") AND len(arguments.args.formatterMask)>
					<cfreturn numberFormat(arguments.string,arguments.args.formatterMask)>
				<cfelse>
					<cfreturn numberFormat(arguments.string)>
				</cfif>
			</cfcase>
			<cfcase value="paragraph">
				<cfreturn paragraphFormat(arguments.string)>
			</cfcase>
			<cfdefaultCase>
				<cfthrow detail="Invalid formatter. The specified formatter is not currently supported.">
			</cfdefaultCase>
		</cfswitch>
	</cffunction>

	<cffunction name="_param" output="false" access="public">
		<cfargument name="structure" required="yes">
		<cfargument name="variable" required="yes">
		<cfargument name="value" required="no" default="">
		<cfscript>
		var item = "";
		var strItem = "";
		var items = listLen(ARGUMENTS.variable);
		var i={};
		var str = {};


		for(i.item = 1;i.item <= items;i.item++){
			str = ARGUMENTS.structure;
			for(i.str = 1;i.str < listLen(ARGUMENTS.variable,".");i.str++){
				strItem = listGetAt(ARGUMENTS.variable,i.str,".");
				if(! structKeyExists(str,strItem)){
					str[strItem] = {};
				}
				str = str[strItem];
			}
			item = listLast(listGetAt(ARGUMENTS.variable,i.item),".");
			if(!structKeyExists(ARGUMENTS.structure,item)){
				str[item] = arguments.value;
			}
		}

		return str[item];
		</cfscript>
	</cffunction>
    
   	<cffunction name="get_routeItem" output="true" access="public">
   		<cfargument name="position" default="1">
   		<cfargument name="default" default="">
   		<cfargument name="routeVar" default="#VARIABLES.attributes.__route#">
   		<cfscript>
   		if(isArray(ARGUMENTS.routeVar) && arrayLen(ARGUMENTS.routeVar)>=ARGUMENTS.position){
			return ARGUMENTS.routeVar[ARGUMENTS.position];
		} else {
			return ARGUMENTS.default;
		}
   		</cfscript>
	</cffunction>

	<cffunction name="get_ajaxproxyclass" output="true" access="public">
		<cfargument name="object" default="#this#">
		<cfscript>
		var res = "";
		var baseFile = get_directoryPath();
		var baseAction = VARIABLES.config.action;
		var jsFile = baseFile & "#baseAction#_ajax_class.cfm";
		var cfcFile = baseFile & "#VARIABLES.config.action#.cfc";
		var generate_jsFile = false;
		var hasCFC = true;
		var f = {};
		var methodList = "";
		var meth = "";
		var events = "beforeSend,complete,dataFilter,error,success";
		var thisEvent = "";
		var jsoClass = "";
		var i = {};
		// check for CFC
		if(fileExists(cfcFile)){
			// check for AJAX Object Class file
			if(fileExists(jsFile)){
				if(GetFileInfo(jsFile).lastmodified < GetFileInfo(cfcFile).lastmodified){
					generate_jsFile = true;
				}
			} else {
				generate_jsFile = true;
			}
		} else {
			// at this time we are thinking generate empty class based on base cfc class
			hasCFC = true;
		}
		if(generate_jsFile){
		// the following is generation code //
		methodList = listSort(structKeyList(this),"textNoCase");
		jsoClass = "{
	url: '#get_ajaxservice()#',
	init: function(){
		#this._ajax_init()#
	}";

		for(i.meth=1;i.meth<=listlen(methodList);i.meth++){
	//	for(meth in this){
		meth = listGetAt(methodList,i.meth);
		if(structKeyExists(this[meth],"access")){
				if(this[meth].access == 3){
					// insert function into object
					jsoClass &= ",
	#meth#: function(data){
		if(! data){
			var data = {};
			url = this.url;
		}
		data.method = '#meth#';
		jQuery.ajax({
			url: this.url,
			dataType: 'json',
			data: data,
			beforeSend: this.#meth#_ajax_beforeSend,
			complete: this.#meth#_ajax_complete,
			dataFilter: this.#meth#_ajax_dataFilter,
			error: this.#meth#_ajax_error,
			success: this.#meth#_ajax_success
		});
	}";
					for(i.event=1;i.event<=listLen(events);i.event++){
						thisEvent = listGetAt(events,i.event);
						jsoClass &= ",
	#meth#_ajax_#thisEvent# : function(data){
		#get_ajax_jso_code(meth,thisEvent)#
	}";
					}
				}
			}
		}
		jsoClass &= "
}";
		// end of generation code
			fileWrite(jsFile,jsoClass);
		} else {
			if(hasCFC){
				jsoClass = fileRead(jsFile);
			} else {
				jsoClass = "";
			}
		}
		return jsoClass;
		</cfscript>
	</cffunction>

	<cffunction name="set_ajaxProxyClassContent" output="false">
		<cfargument name="object" default="#this#">
		<cfargument name="id" default="mainAJAXProxyClass">
		<cfargument name="proxyClass" default="proxyClass">
		<cfargument name="proxyObject" default="objProxy">
		<cfscript>
		var varProxyClass = '
<script>
#ARGUMENTS.proxyClass# = Class.extend(#get_ajaxproxyclass(object:ARGUMENTS.object)#);
#ARGUMENTS.proxyObject# = new #ARGUMENTS.proxyClass#();
</script>';

		this.content.addHeadContent(
			id:'sjsi',
			type:'js',
			after:'jQuery',
			src:'/share/js/sos/sjsi.js'
		);
		this.content.addHeadContent(
			id:ARGUMENTS.id,
			type:'js',
			after:'sjsi',
			content:varProxyClass
		);
		</cfscript>
	</cffunction>

	<cffunction name="get_ajax_jso_code" output="false" access="public">
		<cfargument name="methodName">
		<cfargument name="eventName">
		<cfset res = "">
		<cfif structKeyExists(this,"#ARGUMENTS.methodName#_ajax_#ARGUMENTS.eventName#")>
			<cfinvoke 
			    component="#this#" 
			    method="#ARGUMENTS.methodName#_ajax_#ARGUMENTS.eventName#" 
			    returnVariable="res"></cfinvoke>
		<cfelse>
			<cfinvoke 
			    component="#this#" 
			    method="_ajax_#ARGUMENTS.eventName#" 
			    returnVariable="res"></cfinvoke>
		</cfif>
		<cfreturn res>
	</cffunction>

	<cffunction name="_ajax_init" access="public" output="false" returnFormat="JSON">
		<cfreturn "">
	</cffunction>

	<cffunction name="_ajax_beforeSend" access="public" output="false" returnFormat="JSON">
		<cfreturn "">
	</cffunction>

	<cffunction name="_ajax_complete" access="public" output="false" returnFormat="JSON">
		<cfreturn "">
	</cffunction>

	<cffunction name="_ajax_dataFilter" access="public" output="false" returnFormat="JSON">
		<cfreturn "return data;">
	</cffunction>

	<cffunction name="_ajax_error" access="public" output="false" returnFormat="JSON">
		<cfreturn "">
	</cffunction>

	<cffunction name="_ajax_success" access="public" output="false" returnFormat="JSON">
		<cfreturn "">
	</cffunction>
    
   	<cffunction name="_dump" output="true" access="public">
		<cfargument name="var">
		<cfargument name="label" required="false" default="">
		<cfargument name="expand" default="true" required="false">
		<cfargument name="abort" default="false" required="false">
		<cfscript>
			if ( isSimpleValue(arguments.var)) {
				writeOutput("<br/> " & arguments.label & ": ");
			}
		</cfscript>
		<cfdump var="#arguments.var#" label="#arguments.label#" expand="#arguments.expand#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
	</cffunction>

	<cffunction name="_htmlHead" output="false" access="private">
		<cfargument name="text" required="true">

		<cfHtmlHead text="#arguments.text#">
	</cffunction>
    
   	<cffunction name="_rethrow" output="true" access="public">
	   <cftry>
	      <cfcatch>
	      <cfrethrow>
	      </cfcatch>
	   </cftry>
	   <cfthrow type="Context validation error" message="Context validation error for CFRETHROW.">
	</cffunction>
    
   	<cffunction name="_throw" output="true" access="public">
		<cfargument name="message" required="true">
		<cfargument name="detail" required="false" default="">
		<cfargument name="errorCode" required="false" default="">
		<cfargument name="extendedInfo" required="false" default="">
		<cfargument name="object" required="false" default="">
		<cfargument name="type" required="false" default="">
		<cfthrow message="#arguments.message#" detail="#arguments.detail#" errorcode="#arguments.errorCode#" extendedInfo="#arguments.extendedInfo#" type="#arguments.type#">
	</cffunction>

    <!--- extended coprocessor functions --->
	<cffunction name="setConfigVariables" access="private">
		<cfargument name="configXML">
	</cffunction>

</cfcomponent>