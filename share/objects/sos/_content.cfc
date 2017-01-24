<cfcomponent name="content" displayName="content" output="false">

	<cffunction name="addContent" access="public" output="false">
		<cfargument name="name" required=true>
		<!--- Default should be "mainBody", but must be declared by user --->
		<cfargument name="content" required="true">
		<cfargument name="position" default="">
		<cfargument name="nest" default="true" required="false">
		<cfargument name="cache" default="false" required="false">
		<cfscript>
		var contentToAdd = structNew();

		structAppend(contentToAdd,arguments);
		structDelete(contentToAdd,"name");
		structDelete(contentToAdd,"position");
		paramContent();

		if (NOT structKeyExists(VARIABLES.content,arguments.name)) {
			VARIABLES.content[arguments.name] = arrayNew(1);
		}
		if (arguments.position != 'first' AND arguments.position GT arrayLen(VARIABLES.content[arguments.name])) {
			arguments.position = 'last';
		}
		if (arguments.position == 'first'){
			arrayPrepend(VARIABLES.content[arguments.name],contentToAdd);
		} else if (isNumeric(arguments.position)) {
			arrayInsertAt(VARIABLES.content[arguments.name],arguments.position,contentToAdd);
		} else {
			arrayAppend(VARIABLES.content[arguments.name],contentToAdd);
		}
		</cfscript>
	</cffunction>

	<cffunction name="paramContent" access="public" output="false">
		<cfif NOT(structKeyExists(VARIABLES,"content"))>
			<cfset VARIABLES.content = {}>
		</cfif>
	</cffunction>

	<cffunction name="setDevice" ouput="false" access="public">
		<cfargument name="device" default="">

		<cfset VARIABLES.device = arguments.device>
		<cfreturn this>
	</cffunction>

	<cffunction name="paramDevice" access="private" output="false">
		<cfif NOT(structKeyExists(VARIABLES,"device"))>
			<cfset setDevice('')>
		</cfif>
		<cfreturn VARIABLES.device>
	</cffunction>

	<cffunction name="getDevice" access="public" output="false">
		<cfreturn paramDevice()>
	</cffunction>

	<cffunction name="addSrcItem" access="private" output="false">
		<cfargument name="type">
		<cfargument name="item">

		<cfif arguments.type EQ 'js'>
			<cfreturn '
	<script type="text/javascript" src="#arguments.item#"></script>'>
		<cfelseif arguments.type EQ 'css'>
			<cfreturn '
	<link href="#arguments.item#" rel="stylesheet" type="text/css" />'>
		</cfif>
	</cffunction>
	<cffunction name="getContent" access="public" output="false">
		<cfargument name="name" required=true>
		<cfscript>
		paramContent();

		if(structKeyExists(VARIABLES.content,ARGUMENTS.name)){
			return VARIABLES.content[ARGUMENTS.name];
		} else {
			return {};
		}
		</cfscript>
	</cffunction>

	<cffunction name="contentExists" access="public" output="false">
		<cfargument name="name" required=true>

		<cfscript>
		paramContent();

		return structKeyExists(VARIABLES.content,ARGUMENTS.name);
		</cfscript>
	</cffunction>

	<cffunction name="getContentList" access="public" output="false">
		<cfscript>
		paramContent();

		return structKeyList(VARIABLES.content);
		</cfscript>
	</cffunction>

	<cffunction name="getFullContent" access="public" output="false">
		<cfscript>
		paramContent();

		return VARIABLES.content;
		</cfscript>
	</cffunction> 

	<cffunction name="getHeadContent" access="public" output="false">
		<!--- replaced by direct call to getHeadCSSContent()
		<cfset var thisItem = ''>
		<cfset var myReturn = ''>
		<cfset var iArrayElem = 0>
		<cfset prepHeadContent("js")>
		<cfset prepHeadContent("css")>
		<cfset processSequencedItem("js")>
		<cfset processSequencedItem("css")>
		<cfloop from="1" to="#arrayLen(VARIABLES.headContent.css.item)#" index="iArrayElem">
			<cfset thisItem = VARIABLES.headContent.css.item[iArrayElem]>
			<cfif NOT structKeyExists(thisItem,"content")>
				<cfset myReturn = myReturn & '
	<link href="#thisItem.src#" rel="stylesheet" type="text/css" />'>
			<cfelse>
				<cfset myReturn = myReturn & "#thisItem.content#
">
			</cfif>
		</cfloop>
		--->
		<!--- replaced by direct call to getHeadJSContent()
		<cfset iArrayElem = 0>
		<cfloop from="1" to="#arrayLen(VARIABLES.headContent.js.item)#" index="iArrayElem">
			<cfset thisItem = VARIABLES.headContent.js.item[iArrayElem]>
			<cfif NOT structKeyExists(thisItem,"content")>
				<cfset myReturn = myReturn & '
	<script type="text/javascript" src="#thisItem.src#"></script>'>
			<cfelse>
				<cfset myReturn = myReturn & "#thisItem.content#
">
			</cfif>
		</cfloop>
		--->
		<!--- removed for portability
			# added to coop root tag
			# call tag manually in other frameworks (or getHeadCSSContent and/or getHeadJSContent)
		<cfhtmlHead text="#myReturn#" >
		 --->
		<cfreturn getHeadCSSContent() & getHeadJSContent()>
	</cffunction>


	<cffunction name="getHeadCSSContent" access="public" output="false">
		<cfset var thisItem = ''>
		<cfset var myReturn = ''>
		<cfset var iArrayElem = 0>
		<cfset prepHeadContent("css")>
		<cfset processSequencedItem("css")>
		<cfloop from="1" to="#arrayLen(VARIABLES.headContent.css.item)#" index="iArrayElem">
			<cfset thisItem = VARIABLES.headContent.css.item[iArrayElem]>
			<cfif NOT structKeyExists(thisItem,"content")>
				<cfset myReturn = myReturn & '
	<link href="#parseCSSAlias(thisItem.src)#" rel="stylesheet" type="text/css" />'>
			<cfelse>
				<cfset myReturn = myReturn & "#parseCSSAlias(thisItem.content)#
">
			</cfif>
		</cfloop>
		<cfreturn myReturn>
	</cffunction>

	<cffunction name="parseCSSAlias" access="private" output="false">
		<cfargument name="aliasCSS">
		<cfscript>
		var retAlias = ARGUMENTS.aliasCSS;
		if(findNoCase("@skin@",ARGUMENTS.aliasCSS)){
			retAlias = replaceNoCase(ARGUMENTS.aliasCSS,"@skin@","#SESSION.user.get_skinCSSPath()#","ALL");
		}
		if(findNoCase("@share@",ARGUMENTS.aliasCSS)){
			retAlias = replaceNoCase(ARGUMENTS.aliasCSS,"@share@","/share/","ALL");
		}
		return retAlias;
		</cfscript>
	</cffunction>

	<cffunction name="getHeadJSContent" access="public" output="false">
		<cfset var thisItem = ''>
		<cfset var myReturn = ''>
		<cfset var iArrayElem = 0>
		<cfset prepHeadContent("js")>
		<cfset processSequencedItem("js")>
		<cfloop from="1" to="#arrayLen(VARIABLES.headContent.js.item)#" index="iArrayElem">
			<cfset thisItem = VARIABLES.headContent.js.item[iArrayElem]>
			<cfif NOT structKeyExists(thisItem,"content")>
				<cfset myReturn = myReturn & '
	<script type="text/javascript" src="#thisItem.src#"></script>'>
			<cfelse>
				<cfset myReturn = myReturn & "#thisItem.content#
">
			</cfif>
		</cfloop><!---<cfdump var="#myReturn#" label="sosContent"><cfabort>--->
		<cfreturn myReturn>
	</cffunction>

	<cffunction name="prependSequencedItem">
		<cfargument name="type">
		<cfargument name="curItem">

		<cfscript>
		var currentItem = arguments.curItem;
		var findDependantPos = '';
		if (currentItem.AFTER NEQ '' AND NOT listFindNoCase(VARIABLES.headContent[arguments.type].key,currentItem.id,chr(8))) {
			if (!listFindNoCase(VARIABLES.headContent[arguments.type].key,currentItem.after,chr(8))) {
				findDependantPos = listFindNoCase(VARIABLES.headContent[arguments.type].sequencekey,currentItem.after,chr(8));
				if (findDependantPos)
				prependSequencedItem(arguments.type,VARIABLES.headContent[arguments.type].sequencedItem[findDependantPos]);
			}
				if (currentItem.after EQ 'none') {
					// first
					arrayPrepend(VARIABLES.headContent[arguments.type].item,currentItem);
					VARIABLES.headContent[arguments.type].key = listPrepend(VARIABLES.headContent[arguments.type].key,currentItem.id,chr(8));
				} else if (currentItem.after EQ 'all') {
					// last
					arrayAppend(VARIABLES.headContent[arguments.type].item,currentItem);
					VARIABLES.headContent[arguments.type].key = listAppend(VARIABLES.headContent[arguments.type].key,currentItem.id,chr(8));
				} else {
					// specific position
					position = listFindNoCase(VARIABLES.headContent[arguments.type].sequencekey,currentItem.after,chr(8)) + 1;
					if (position  GTE listLen(VARIABLES.headContent[arguments.type].sequencekey)) {
						arrayAppend(VARIABLES.headContent[arguments.type].item,currentItem);
						VARIABLES.headContent[arguments.type].key = listAppend(VARIABLES.headContent[arguments.type].key,currentItem.id,chr(8));
					}else {
						arrayInsertAt(VARIABLES.headContent[arguments.type].item,position,currentItem);
						VARIABLES.headContent[arguments.type].key = listInsertAt(VARIABLES.headContent[arguments.type].key,position,currentItem.id,chr(8));
					}
				}
			}

		</cfscript>

	</cffunction>

	<cffunction name="appendSequencedItem">
		<cfargument name="type">
		<cfargument name="curItem">

		<cfscript>
		var currentItem = arguments.curItem;
		var findDependantPos = '';

		if (currentItem.before NEQ '' AND NOT listFindNoCase(VARIABLES.headContent[arguments.type].key,currentItem.id,chr(8))) {
			if (!listFindNoCase(VARIABLES.headContent[arguments.type].key,currentItem.after,chr(8))) {
				findDependantPos = listFindNoCase(VARIABLES.headContent[arguments.type].sequencekey,currentItem.after,chr(8));
				if (findDependantPos)
				appendSequencedItem(arguments.type,VARIABLES.headContent[arguments.type].sequencedItem[findDependantPos]);
			}
			if (currentItem.before EQ 'none') {
				// first
				arrayApppend(VARIABLES.headContent[arguments.type].item,currentItem);
				VARIABLES.headContent[arguments.type].key = listApppend(VARIABLES.headContent[arguments.type].key,currentItem.id,chr(8));
			} else if (currentItem.before EQ 'all') {
				// last
				arrayPrepend(VARIABLES.headContent[arguments.type].item,currentItem);
				VARIABLES.headContent[arguments.type].key = listPrepend(VARIABLES.headContent[arguments.type].key,currentItem.id,chr(8));
			} else if (listFindNoCase(VARIABLES.headContent[arguments.type].key,currentItem.before,chr(8))) {
				// specific position
				position = max(1,listFindNoCase(VARIABLES.headContent[arguments.type].key,currentItem.before,chr(8)));
				arrayInsertAt(VARIABLES.headContent[arguments.type].item,position,currentItem);
				VARIABLES.headContent[arguments.type].key = listInsertAt(VARIABLES.headContent[arguments.type].key,position,currentItem.id,chr(8));
			}
		}	

		</cfscript>

	</cffunction>


	<cffunction name="processSequencedItem" access="private" output="false">
		<cfargument name="type">
		<cfscript>
		var i=0;
		var currentItem = '';
		var position = '';
		// loop forward first for the after items.

		for (i=1; i LTE arrayLen(VARIABLES.headContent[arguments.type].sequencedItem); i++) {
			currentItem = VARIABLES.headContent[arguments.type].sequencedItem[i];
			prependSequencedItem(arguments.type,currentItem);	
		}

		// then loop in reverse for before's
		for (i=arrayLen(VARIABLES.headContent[arguments.type].sequencedItem); i GTE 1; i--) {
			currentItem = VARIABLES.headContent[arguments.type].sequencedItem[i];
			prependSequencedItem(arguments.type,currentItem);	
		}
		</cfscript>
	</cffunction>

	<cffunction name="appendBlockContent" access="public" output="false">
		<cfargument name="name">
		<cfargument name="value" default="">
		<cfargument name="attributes" default="#structNew()#">
		<cfparam name="VARIABLES.blockContent" default="#structNew()#">
		<cfparam name="VARIABLES.blockContentAttributes" default="#structNew()#">
		<cfparam name="VARIABLES.blockContentAttributes[ARGUMENTS.name]" default="#structNew()#">
		<cfset VARIABLES.blockContent[arguments.name] = VARIABLES.blockContent[arguments.name] & arguments.value>
		<cfset structAppend(VARIABLES.blockContentAttributes[arguments.name],ARGUMENTS.attributes,"YES")>
	</cffunction>

	<cffunction name="getBlockContent" access="public" output="false">
		<cfargument name="name">
		<cfparam name="VARIABLES.blockContent" default="#structNew()#">
		<cfif structKeyExists(VARIABLES.blockContent,ARGUMENTS.name)>
			<cfreturn VARIABLES.blockContent[ARGUMENTS.name]>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>

	<cffunction name="getBlockContentAttributes" access="public" output="false">
		<cfargument name="name">
		<cfparam name="VARIABLES.blockContentAttributes" default="#structNew()#">
		<cfif structKeyExists(VARIABLES.blockContentAttributes,ARGUMENTS.name)>
			<cfreturn VARIABLES.blockContentAttributes[ARGUMENTS.name]>
		<cfelse>
			<cfreturn structNew()>
		</cfif>
	</cffunction>

	<cffunction name="getBlockContentList" access="public" output="false">
		<cfparam name="VARIABLES.blockContent" default="#structNew()#">

		<cfreturn structKeyList(VARIABLES.blockContent)>
	</cffunction>

	<cffunction name="setBlockContent" access="public" output="false">
		<cfargument name="name">
		<cfargument name="value" default="">
		<cfargument name="attributes" default="#structNew()#">
		<cfparam name="VARIABLES.blockContent" default="#structNew()#">
		<cfset VARIABLES.blockContent[arguments.name] = arguments.value>
		<cfset VARIABLES.blockContentAttributes[arguments.name] = ARGUMENTS.attributes>
	</cffunction>

	<cffunction name="paramBlockContent" access="public" output="false">
		<cfargument name="name">
		<cfargument name="value" default="">
		<cfparam name="VARIABLES.blockContent" default="#structNew()#">
		<cfparam name="VARIABLES.blockContentAttributes" default="#structNew()#">
		<cfparam name="VARIABLES.blockContentAttributes[ARGUMENTS.name]" default="#structNew()#">
		<cfif !structKeyExists(VARIABLES.blockContent,ARGUMENTS.name)>
			<cfset VARIABLES.blockContent[arguments.name] = arguments.value>
			<cfset structAppend(VARIABLES.blockContentAttributes[arguments.name],ARGUMENTS.attributes,"YES")>
		</cfif>
	</cffunction>

	<cffunction name="prependBlockContent" access="public" output="false">
		<cfargument name="name">
		<cfargument name="value" default="">
		<cfparam name="VARIABLES.blockContent" default="#structNew()#">
		<cfparam name="VARIABLES.blockContentAttributes" default="#structNew()#">
		<cfparam name="VARIABLES.blockContentAttributes[ARGUMENTS.name]" default="#structNew()#">
		<cfset VARIABLES.blockContent[arguments.name] = arguments.value & VARIABLES.blockContent[arguments.name]>
		<cfset structAppend(VARIABLES.blockContentAttributes[arguments.name],ARGUMENTS.attributes,"YES")>
	</cffunction>

	<cffunction name="getAliasItem" access="public" output="false">
		<cfargument name="name">
		<cfargument name="type">
		<cfset var aliases = getAliases()>
		<cfif structKeyExists(aliases[arguments.type],arguments.name)>
			<cfreturn aliases[arguments.type][arguments.name]>
		<cfelse>
			<!---<cfdump var="#ALIASES#" label="#arguments.name#"><cfabort>--->
			<cfthrow message="If No 'src' or 'content' arguments are passed in, the 'id' argument must be the name of a predefined alias item.">
		</cfif>
	</cffunction>

	<cffunction name="getAliasAfter" access="public" output="false">
		<cfargument name="name">
		<cfargument name="type">
		<cfset var aliases = getAliases()>
		<cfif structKeyExists(aliases[arguments.type],arguments.name)>
			<cfreturn aliases[arguments.type][arguments.name]>
		<cfelse>
			<cfthrow message="If No 'src' or 'content' arguments are passed in, the 'id' argument must be the name of a predefined alias item.">
		</cfif>
	</cffunction>

	<cffunction name="aliasExists" access="public" output="false">
		<cfargument name="type">
		<cfargument name="id">
		<cfset aliases = getAliases()>
		<cfreturn structKeyExists(aliases[arguments.type],arguments.id)>
	</cffunction>

	<cffunction name="setAlias" access="public" output="false">
		<cfargument name="name" hint="This becomes the ID internally for uniqueness.">
		<cfargument name="type">
		<cfargument name="src" default="">
		<cfargument name="content" default="">
		<cfargument name="after" default="">
		<cfargument name="before" default="">
		<cfargument name="position" default="">

		<cfscript>
		VARIABLES.aliases[arguments.type][arguments.name] = arguments;
		VARIABLES.aliases[arguments.type][arguments.name].id = ARGUMENTS.name;
		/*if(len(arguments.src)){
			VARIABLES.aliases[arguments.type][arguments.name].content = addSrcItem(type:arguments.type,item:arguments.src);
		}*/
		if(len(arguments.src)){
			if(findNoCase("@skin@",ARGUMENTS.src)){
			//	writeDump(var:ARGUMENTS,label:"source for cfg alias");
				VARIABLES.aliases[arguments.type][arguments.name].prefix = "skin";
			/*
				ARGUMENTS.src = replace(ARGUMENTS.src,"@skin@","");
				writeDump(var:ARGUMENTS,label:"source for cfg alias");
				abort;
			*/
			}
			VARIABLES.aliases[arguments.type][arguments.name].content = addSrcItem(type:arguments.type,item:arguments.src);
		}
		</cfscript>
	</cffunction>

	<cffunction name="setAliases" access="public" output="false">
		<cfargument name="collection" hint="array of structures of type alias">
		<cfscript>
		var i={};

		getAliasCache();

		for(i.alias=1;i.alias<=arrayLen(ARGUMENTS.collection);i.alias++){
			setAlias(argumentCollection:ARGUMENTS.collection[i.alias]);
		}
		return this;
		</cfscript>
	</cffunction>

	<cffunction name="paramAlias" access="public" output="false">
		<cfscript>
		if(!structKeyExists(aliases[ARGUMENTS.type],ARGUMENTS.name)){
			setAlias(argumentCollection:ARGUMENTS);
		}
		</cfscript>
	</cffunction>
	<cffunction name="getAliases" access="private" output="false">
		<cfscript>
		getAliasCache();
		return VARIABLES.aliases;
		</cfscript>
	</cffunction>
	<cffunction name="setAliasCache" access="public" output="false" description="I set the system cache. This requires application scope to be available.">
		<cfscript>
		prepAliasCache();
		APPLICATION.__CACHE.sosContent.aliases[ARGUMENTS.type] = VARIABLES.aliases;
		</cfscript>
	</cffunction>

	<cffunction name="getAliasCache" access="public" output="false">
		<cfscript>
		prepAliasCache();
		VARIABLES.aliases = APPLICATION.__CACHE.sosContent.aliases;
		return VARIABLES.aliases;
		</cfscript>
	</cffunction>

	<cffunction name="prepAliasCache" access="private" output="false">
		<cfscript>
		if(!structKeyExists(APPLICATION,"__cache")){
			APPLICATION.__CACHE = structNew();
		}
		if(!structKeyExists(APPLICATION.__cache,"sosContent")){
			APPLICATION.__CACHE.sosContent = structNew();
		}
		if(!structKeyExists(APPLICATION.__cache.sosContent,"aliases")){
			APPLICATION.__CACHE.sosContent.aliases = structNew();
		}
		if(!structKeyExists(APPLICATION.__cache.sosContent.aliases,"css")){
			APPLICATION.__CACHE.sosContent.aliases.css = structNew();
		}
		if(!structKeyExists(APPLICATION.__cache.sosContent.aliases,"js")){
			APPLICATION.__CACHE.sosContent.aliases.js = structNew();
		}
		</cfscript>
	</cffunction>

	<cffunction name="clearAliasCache" access="public" output="false">
		<cfargument name="types" default="">
		<cfscript>
		var i={};
		var typeList = ARGUMENTS.types;
		if(len(ARGUMENTS.type)){
			typeList = structKeyList(VARIABLES.aliases);
		}
		for(i.type=1;i.type>=listLen(typeList);i.type++){
			structDelete(VARIABLES.aliases,listGetAt(typeList,i.type));
		}
		</cfscript>
	</cffunction>

	<cffunction name="clearAliasCacheItem" access="public" output="false">
		<cfargument name="type">
		<cfargument name="name">
		<cfscript>
		// to do
		</cfscript>
	</cffunction>

	<cffunction name="addHeadContent" access="public" output="true">
		<cfscript>
		prepHeadContent(arguments.type);
		// ToDo: record content head IDs and only add once
		setHeadContent(argumentCollection:ARGUMENTS);
		</cfscript>
	</cffunction>

	<cffunction name="paramHeadContent" access="public" output="true">
		<cfscript>
		prepHeadContent(arguments.type);
		// only add if content does not already exist in content request cache
		if(!listFindNoCase(VARIABLES.headContent[arguments.type].key,ARGUMENTS.id)){
			addHeadContent(argumentCollection:ARGUMENTS);
		}
		</cfscript>
	</cffunction>

	<cffunction name="setHeadContent" access="public" output="true">
		<cfargument name="position" required="false" default="">
		<cfargument name="before" required="false" default="">
		<cfargument name="after" required="false" default="">
		<cfargument name="type" required="false">
		<cfargument name="id" required="false" default="">
		<cfargument name="content" required="false" default="">
		<cfargument name="src" required="false" default="">
		<cfargument name="ssrc" required="false" default="">
		<cfargument name="cdn" required="false" default="">
		<cfargument name="prefix" required="false" default="default">
		<cfscript>
			var thisInclude = structNew();
			var thisPosition = 1;
			var delimiter = chr(8);
			var doAppend = true;
			prepHeadContent(arguments.type);

			if (arguments.content EQ '' && arguments.src EQ '') {
				ARGUMENTS = getAliasItem(
					name:arguments.id,
					type:arguments.type
				);
			}
			if (arguments.id EQ '') {
				arguments.id = createUUID();
			}
			if(isDefined('arguments.level')){arguments.lev=0;};
			if (len(arguments.after)) {
				if (aliasExists(type:arguments.type,id:arguments.after)) {
					setHeadContent(
						type:arguments.type,
						id:arguments.after
					);
				}
			}

			if(arguments.src NEQ '') {
				if(!len(arguments.id)){
					arguments.id = arguments.src;
				}
				if(structKeyExists(ARGUMENTS,"prefix")){
					switch(ARGUMENTS.prefix){
						case "skin":
							thisInclude.src = SESSION.user.get_skinPath() & arguments.src;
						default:
							thisInclude.src = arguments.src;
					}
				} else {
					thisInclude.src = arguments.src;
				}
			}
			if (arguments.content NEQ ''){
				thisInclude.content = arguments.content;
			} else if (arguments.src EQ '') {
				doAppend = false;
			}
			thisInclude.id = arguments.id;
			thisPosition = getPosition(arguments.before,arguments.after,arguments.position,arguments.type);
			if(!!listFindNoCase(VARIABLES.headContent[arguments.type].key,arguments.id,chr(8)) ||
				!!listFindNoCase(VARIABLES.headContent[arguments.type].sequenceKey,arguments.id,chr(8)) ){
				doAppend=false;
			}
			if (doAppend) {
				if (arguments.before NEQ '' OR arguments.after NEQ ''){
					thisInclude.before = arguments.before;
					thisInclude.after = arguments.after;
					arrayAppend(VARIABLES.headContent[arguments.type].sequencedItem,thisInclude);
					VARIABLES.headContent[arguments.type].sequenceKey = listAppend(VARIABLES.headContent[arguments.type].sequenceKey,arguments.id,delimiter);
				} else {
					arrayAppend(VARIABLES.headContent[arguments.type].item,thisInclude);
					VARIABLES.headContent[arguments.type].key = listAppend(VARIABLES.headContent[arguments.type].key,arguments.id,delimiter);
				}
			}
			if (len(arguments.before)) {
				if (aliasExists(id:arguments.id,type:arguments.type,name:arguments.before)) {
					setHeadContent(
						type:arguments.type,
						id:arguments.before
					);
				}
			}

			return arguments.id;
		</cfscript>
	</cffunction>

	<cffunction name="getHeadContentItems">
		<cfreturn VARIABLES.headContent>
	</cffunction>

	<cffunction name="getHeadContentItem" access="public" output="false">
		<cfargument name="type" required="true">
		<cfargument name="id" required="true">
		<cfscript>
		var position = {};
		var position2 = 0;
		var delimiter = chr(8);
		prepHeadContent(ARGUMENTS.type);
		position.item = listFindNoCase(VARIABLES.headContent[ARGUMENTS.type].key,ARGUMENTS.id,delimiter);
		if(position.item){
			return VARIABLES.headContent[ARGUMENTS.type].item[position.item];
		}
		position.seq = listFindNoCase(VARIABLES.headContent[ARGUMENTS.type].sequenceKey,ARGUMENTS.id,delimiter);
		if(position.seq){
			return VARIABLES.headContent[ARGUMENTS.type].sequencedItem[position.seq];
		}
		</cfscript>
	</cffunction>

	<cffunction name="getPosition" access="private" output="false">
		<cfargument name="before">
		<cfargument name="after">
		<cfargument name="position">
		<cfargument name="type">
		<cfscript>
			var thisPosition = arrayLen(VARIABLES.headContent[arguments.type].item);
			var currentPOS = 1;
			var iListItem = 1;
			var delimiter = chr(8);
			if (arguments.before EQ 'none' AND arguments.after EQ 'all') {
				if (arguments.position EQ 'first' OR arguments.position LT 1) {
					thisPosition = 1;
				} else if (arguments.position EQ 'last' OR arguments.position EQ '' OR arguments.position gt arrayLen(VARIABLES.headContent[arguments.type].item)) {
					thisPosition = 'append';
				} else {
					thisPosition = arguments.position;
				}
			} else {
				if (arguments.before NEQ 'none') {
					if (listLen(arguments.before) GT 1) {
						for (iListItem = 1;iListItem LTE listLen(arguments.before); iListItem=iListItem + 1) {
							currentPos = listFindNoCase(VARIABLES.headContent[arguments.type].key,listGetAt(arguments.before,iListItem),delimiter);
							if (currentPos LT thisPosition) {
								thisPosition = currentPos + 1;
							}
						}
					} else {
						thisPosition = listFindNoCase(VARIABLES.headContent[arguments.type].key,arguments.before,delimiter);
					}
				} else if (arguments.after NEQ 'all') {
					if (listLen(arguments.after) GT 1) {
						for (iListItem = 1;iListItem LTE listLen(arguments.after); iListItem=iListItem + 1) {
							currentPos = listFindNoCase(VARIABLES.headContent[arguments.type].key,listGetAt(arguments.after,iListItem),delimiter);
							if (currentPos LTE thisPosition) {
								thisPosition = currentPos + 1;
							}
						}
					} else {
						thisPosition = listFindNoCase(VARIABLES.headContent[arguments.type].key,arguments.after,delimiter) + 1;
					}
				}
			}
			if (thisPosition LT 1) {
				thisPosition = 'append';
			}
			return thisPosition;
		</cfscript>
	</cffunction>

	<cffunction name="dump_headContent" access="public" output="true">
		<cfset prepHeadContent(type:'js')>
		<cfdump var="#VARIABLES.headContent#">
	</cffunction>

	<cffunction name="_dump" access="public" output="true">
		<cfargument name="var">
		<cfargument name="label" required="false" default="">
		<cfargument name="expand" default="true" required="false">
		<cfargument name="abort" default="false" required="false">
		<cfscript>
			if ( isSimpleValue(arguments.var)) {
				writeOutput("<br/> " & arguments.label & iif(len(arguments.label),'',": "));
			}
		</cfscript>
		<cfdump var="#arguments.var#" label="#arguments.label#" expand="#arguments.expand#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
	</cffunction>

	<cffunction name="prepHeadContent" access="public" output="false">
		<cfargument name="type">
		<cfscript>
		if (NOT structKeyExists(variables,"headContent")) {
			variables["headContent"] = structNew();
		}
		if (NOT structKeyExists(VARIABLES.headContent,arguments.type)) {
			VARIABLES.headContent[arguments.type] = structNew();
			VARIABLES.headContent[arguments.type]["item"] = arrayNew(1);
			VARIABLES.headContent[arguments.type]["sequenceKey"] = '';
			VARIABLES.headContent[arguments.type]["key"] = '';
			VARIABLES.headContent[arguments.type]["sequencedItem"] = arrayNew(1);
		}
		</cfscript>
	</cffunction>

	<cffunction name="setTemplate" access="public" output="false">
		<cfargument name="template" required="true">
		<cfargument name="setting" required="true">
		<cfset VARIABLES.template[ARGUMENTS.template] = ARGUMENTS.setting>
	</cffunction>

	<cffunction name="getTemplate" access="public" output="false">
		<cfargument name="template" required="true">

		<cfparam name="VARIABLES.template" default="#structNew()#">
		<cfscript>
		if(structKeyExists(VARIABLES.template,ARGUMENTS.template)){
			return VARIABLES.template[ARGUMENTS.template];
		} else {
			return "default";
		}
		</cfscript>
	</cffunction>

</cfcomponent>