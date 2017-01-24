<cfsetting enablecfoutputonly="true">
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value="start">
		<cfparam name="ATTRIBUTES.id" default="">
		<cfparam name="ATTRIBUTES.data" default="">
		<cfparam name="ATTRIBUTES.delimiters" default=",">
		<cfparam name="ATTRIBUTES.displayField" default="display">
		<cfparam name="ATTRIBUTES.formatter" type="string" default="">
		<cfparam name="ATTRIBUTES.formatterMask" type="string" default="">
		<cfparam name="ATTRIBUTES.formatterType" type="string" default="">
		<cfparam name="ATTRIBUTES.formatterVersion" type="string" default="">
		<cfparam name="ATTRIBUTES.innerATTRIBUTES" default="#structNew()#">
		<cfparam name="ATTRIBUTES.itemWrapElement" default="li">
		<cfparam name="ATTRIBUTES.link" default="">
		<cfparam name="ATTRIBUTES.linkField" default="">
		<cfparam name="ATTRIBUTES.linkAttributes" default="#structNew()#">
		<cfparam name="ATTRIBUTES.listItems" default="">
		<cfparam name="ATTRIBUTES.maxrows" default="0">
		<cfparam name="ATTRIBUTES.pagerLocation" default="bottom"><!--- allowed values include top,bottom, and both  --->
		<cfparam name="ATTRIBUTES.pageNum" default="1">
		<cfparam name="ATTRIBUTES.pageSize" default="">
		<cfparam name="ATTRIBUTES.postLink" default="">
		<cfparam name="ATTRIBUTES.renderInclude" default="">
		<cfparam name="ATTRIBUTES.renderModule" default="">
		<cfparam name="ATTRIBUTES.renderPath" default="">
		<cfparam name="ATTRIBUTES.runEmpty" default="false">
		<cfparam name="ATTRIBUTES.wrapElement" default="ul">
		<cfif StructKeyExists(caller,'root')>
			<cfset root = caller.root>
		<cfelse>
			<cfset VARIABLES.root = caller>
		</cfif>
		<cfif NOT thisTag.hasEndTag>
			<cfthrow detail="End tag required" message="All Collaboration tags require an end tag." errorcode="collaboration.tag.ATTRIBUTES">
		</cfif>			
		<cfif ATTRIBUTES.id EQ ''>
			<cfthrow detail="Missing required attribute: 'id'" message="'id' attribute is required">
		</cfif>
		<cfif NOT structKeyExists(VARIABLES.root,"collaborate")>
			<cfthrow detail="Missing required Collaboration object on calling page.">
		</cfif>
		<cfif ATTRIBUTES.pageSize NEQ '' AND ATTRIBUTES.pageNum EQ ''>
			<cfthrow message="The pageNum attribute is required when you pass the page size attribute.">
		</cfif>
		<cfscript>
		if(structKeyExists(VARIABLES.root,"collaborate")){
			collaborate = VARIABLES.root.collaborate;
		}
		standardATTRIBUTES = 'id,formatter,formatterVersion,formatterMask,formatterType,data,pageSize,pagerLocation,pageNum,displayField,innerATTRIBUTES,ordered,delimiters,link,linkField,innerAttribs,innerAttribValues,renderPath,renderModule,renderInclude,runEmpty,itemWrapElement,wrapElement,listItems,maxRows';
		ignoredInnerATTRIBUTES = 'id';
		ignoredLinkATTRIBUTES = 'id';
		contentAttributeList = '';
		ATTRIBUTES = VARIABLES.root.collaborate.mergeATTRIBUTES(ATTRIBUTES,VARIABLES.root);
		attributeList = VARIABLES.root.collaborate.createAttributeList(ATTRIBUTES,standardATTRIBUTES,VARIABLES.root);
		listItemATTRIBUTES = '';
		contentAttributeValueList = '';
		innerDataAttributeList = '';
		innerAttributeList = '';
		linkAttributeList = '';
		linkDataAttributeList = '';
		thisTag.innerATTRIBUTES = arrayNew(1);
		thisTag.linkATTRIBUTES = arrayNew(1);
		thisTag.innerDataATTRIBUTES = structNew();
		thisTag.linkDataATTRIBUTES = structNew();
		pagerString = '';
		VARIABLES.renderMode = "default";
		device = VARIABLES.root.collaborate.content.getDevice();
		if (len(device)) {
			device = '_' & device;
			deviceCheck = true;
		} else {
			deviceCheck = false;	
		}

		if(len(ATTRIBUTES.renderInclude)){
			VARIABLES.renderMode = "include";
			renderSet = reMatchNoCase("^@.[^@]+@",ATTRIBUTES.renderInclude);
			if(arraylen(renderSet) && structKeyExists(VARIABLES.root,"_api")){
				renderKey = replace(renderSet[1],"@","","ALL");
				ATTRIBUTES.renderInclude = replace(ATTRIBUTES.renderInclude,renderSet[1],"");
				if(len(ATTRIBUTES.renderInclude)){
					ATTRIBUTES.renderPath = VARIABLES.root._api[renderKey].get_includePath();
				}
			}
			if (ATTRIBUTES.renderPath EQ '') {
				ATTRIBUTES.renderPath = VARIABLES.root.collaborate.get_sharePath() & 'tags/collaboration/includes/';
			}
			if (deviceCheck && fileExists(expandPath(ATTRIBUTES.renderPath & renderInclude & device))) {
				ATTRIBUTES.renderInclude &= device;
			}

		} else if(len(ATTRIBUTES.renderModule)){
			VARIABLES.renderMode = "module";
			renderSet = reMatchNoCase("^@.[^@]+@",ATTRIBUTES.renderModule);
			if(arraylen(renderSet) && structKeyExists(VARIABLES.root,"_api")){
				renderKey = replace(renderSet[1],"@","","ALL");
				ATTRIBUTES.renderModule = replace(ATTRIBUTES.renderModule,renderSet[1],"");
				if(!len(ATTRIBUTES.renderPath)){
					ATTRIBUTES.renderPath = VARIABLES.root._api[renderKey].get_modulePath();
				}
			}
			if (ATTRIBUTES.renderPath EQ '') {
				ATTRIBUTES.renderPath = VARIABLES.root.collaborate.get_sharePath() & 'tags/collaboration/renderers/';
			}
			if (deviceCheck && fileExists(expandPath(ATTRIBUTES.renderPath & ATTRIBUTES.renderModule & device))) {
				ATTRIBUTES.renderModule &= device;
			}
		}

		ATTRIBUTES.wrapElement = trim(ATTRIBUTES.wrapElement);
		ATTRIBUTES.itemWrapElement = trim(ATTRIBUTES.itemWrapElement);
		</cfscript><!--- 
		<cfoutput>
		#VARIABLES.renderMode#
		<cfdump var="#renderSet#" label="#structKeyExists(VARIABLES.root,"_api")#">
		<cfdump var="#VARIABLES.root._api#">
		<br>
		#ATTRIBUTES.renderPath#
		<br>
		#ATTRIBUTES.renderInclude#
		</cfoutput>
		<cfabort> --->
	</cfcase>
	<cfcase value="end">
		<cfsavecontent variable="formElement">
			<cfscript>
			if (listLen(structKeyList(ATTRIBUTES.innerATTRIBUTES))) {
				if (NOT arrayLen(thisTag.innerATTRIBUTES)) {
					thisTag.innerATTRIBUTES[1] = structNew();
				}
				structAppend(thisTag.innerATTRIBUTES[1],ATTRIBUTES.innerATTRIBUTES);
			}
			if (listLen(structKeyList(ATTRIBUTES.linkATTRIBUTES))) {
				if (NOT arrayLen(thisTag.linkATTRIBUTES)) {
					thisTag.linkATTRIBUTES[1] = structNew();
				}
				structAppend(thisTag.linkATTRIBUTES[1],ATTRIBUTES.linkATTRIBUTES);
			}
			if (arrayLen(thisTag.innerATTRIBUTES)) {
				for (iAttrib in thisTag.innerATTRIBUTES[1]) {
					if (left(iAttrib,5) EQ 'data_') {
						thisTag.innerDataATTRIBUTES[iAttrib] = thisTag.innerATTRIBUTES[1][iAttrib];
						structDelete(thisTag.innerATTRIBUTES[1],iAttrib);
					}
				}
			}
			// we need to review and document what this is doing
			if (arrayLen(thisTag.linkATTRIBUTES)) {
				for (iAttrib in thisTag.linkATTRIBUTES[1]) {
					if (left(iAttrib,5) EQ 'data_') {
						thisTag.linkDataATTRIBUTES[iAttrib] = thisTag.linkATTRIBUTES[1][iAttrib];
						structDelete(thisTag.linkATTRIBUTES[1],iAttrib);
					}
				}
			}
			if (arrayLen(thisTag.innerATTRIBUTES)) {
				innerAttributeList = VARIABLES.root.collaborate.createAttributeList(thisTag.innerATTRIBUTES[1],ignoredInnerATTRIBUTES,VARIABLES.root);
			}
			if (arrayLen(thisTag.linkATTRIBUTES)) {
				 linkAttributeList = VARIABLES.root.collaborate.createAttributeList(thisTag.linkATTRIBUTES[1],ignoredLinkATTRIBUTES,VARIABLES.root);
			}
			if (isSimpleValue(VARIABLES.ATTRIBUTES.data) AND VARIABLES.ATTRIBUTES.data EQ ''){
				VARIABLES.ATTRIBUTES.data = thisTag.generatedContent;
				thisTag.generatedContent = '';
			}
			returnData = createObject("component","#VARIABLES.root.collaborate.get_shareClassPath()#objects.collaboration.returnData").init(VARIABLES.ATTRIBUTES.data,VARIABLES.ATTRIBUTES.delimiters);
			start = 1;
			recordCount = returnData.recordCount();
			if (VARIABLES.ATTRIBUTES.pageSize NEQ '') {
				pagesPossible = recordCount / VARIABLES.ATTRIBUTES.pageSize;
				if (listLen(pagesPossible,'.') GT 1) {
					pagesPossible = ceiling(pagesPossible);
				}
				if (VARIABLES.ATTRIBUTES.pageSize LTE recordCount) {
					if (VARIABLES.ATTRIBUTES.pageNum * VARIABLES.ATTRIBUTES.pageSize LTE recordCount) {
						start = VARIABLES.ATTRIBUTES.pageNum * VARIABLES.ATTRIBUTES.pageSize - VARIABLES.ATTRIBUTES.pageSize + 1;
						recordCount = VARIABLES.ATTRIBUTES.pageNum * VARIABLES.ATTRIBUTES.pageSize;
					} else {
						start = recordCount - (VARIABLES.ATTRIBUTES.pageNum * VARIABLES.ATTRIBUTES.pageSize - recordCount) + 2;
					}
				}
				if (VARIABLES.ATTRIBUTES.pageNum EQ 1) {
					pages = min(pagesPossible,10);
					startPage = 1;
				} else {
					pages = min(pagesPossible,max(VARIABLES.ATTRIBUTES.pageNum + 5,10));
					startPage = max(1,VARIABLES.ATTRIBUTES.pageNum - 5);
				}
				if (VARIABLES.ATTRIBUTES.PageNum NEQ 1) {
					pagerString = pagerString & '<a href="?_#VARIABLES.ATTRIBUTES.id#_page=1">&lt;&lt;&nbsp;</a>&nbsp;';
					pagerstring = pagerString & '<a href="?_#VARIABLES.ATTRIBUTES.id#_page=#VARIABLES.ATTRIBUTES.pageNum -1#">&lt;</a>&nbsp;';
				}
				for (iPage = startPage; iPage LTE pages; iPage = iPage + 1) {
					if (iPage EQ VARIABLES.ATTRIBUTES.pageNum) {
						pagerString = pagerString & '<span id="list_#VARIABLES.ATTRIBUTES.id#_pager">|&nbsp;#VARIABLES.ATTRIBUTES.pageNum#&nbsp;|</span>';
					} else {
						pagerString = pagerString & '<a href="?_#VARIABLES.ATTRIBUTES.id#_page=#iPage#">&nbsp;#iPage#&nbsp;</a>';
					}
				}
				if (ATTRIBUTES.pageNum LT pagesPossible) {
					pagerString = pagerString & '<a href="?_#VARIABLES.ATTRIBUTES.id#_page=#VARIABLES.ATTRIBUTES.pageNum + 1#">&nbsp;&gt;</a>';
					pagerString = pagerString & '<a href="?_#VARIABLES.ATTRIBUTES.id#_page=#pagesPossible#">&nbsp;&gt;&gt;</a>';
				}
			}
			writeOutput('<#VARIABLES.ATTRIBUTES.wrapElement# id="#VARIABLES.ATTRIBUTES.id#"#attributeList#>');
			try
            {
            	iRow = 0;
            	lastStatic = {};
            	for(iRow=start; iRow LTE recordCount; iRow = iRow + 1) {
					if(iRow > 1){ 
						lastStatic = data.__meta__.static; 
					}
					data = returnData.returnDataRowStruct(iRow);
					data.__meta__ = {
						start = iif(iRow==1,"true","false"),
						end = iif(iRow==recordCount,"true","false"),
						empty = false,
						listItems = ATTRIBUTES.listItems,
						item = iRow,
						maxrows = ATTRIBUTES.maxrows,
						recordCount = recordCount,
						static = lastStatic
					};
					data.__ATTRIBUTES = VARIABLES.ATTRIBUTES;
					if(returnData.is_ORMData()){
						data.__entity = returnData.returnORMRow(iRow);
					}
					writeOutput(_getItemContent(data:data));

				}
            }
            catch(Any e)
            {
            	writeDump(iRow);
            	writeDump(attributes.data)
            	writeDump(e);abort;
	            if(1==1 || structKeyExists(REQUEST,"__stage") && REQUEST.__stage EQ "build"){
	            	writeDump(label:"Row #iRow# exception", var:data.__ATTRIBUTES.DATA,expand:false);
	            	abort;
            	}
            }

			writeOutput('</#ATTRIBUTES.wrapElement#>');

			</cfscript>
			<cfif ATTRIBUTES.runEmpty AND recordCount EQ 0>
	        	<cfscript>
				data = {
					display = "",
					value = "",
					__meta__ = {
						start = true,
						end = true,
						empty = true,
						listItems = ATTRIBUTES.listItems,
						item = 0,
						maxrows = ATTRIBUTES.maxrows,
						recordCount = recordCount,
						static = {}
					},
					__ATTRIBUTES = ATTRIBUTES
				};
				</cfscript>
	        	<cfoutput>#_getItemContent(data:VARIABLES.data)#</cfoutput>
        	</cfif>
			</cfsavecontent>
			<cfif ATTRIBUTES.pagerLocation EQ 'top'>
				<cfset formElement = pagerString & formElement>
			<cfelseif ATTRIBUTES.pagerLocation EQ 'bottom'>
				<cfset formElement = formElement & pagerString>
			<cfelseif ATTRIBUTES.pagerLocation EQ 'both'>
				<cfset formElement = pagerString & formElement & pagerString>
			</cfif>
			<cfoutput>#formElement#</cfoutput>
			<cfset thisTag.generatedContent = "">
		</cfcase>
</cfswitch>
<cffunction name="_getItemContent">
	<cfargument name="data" />

	<cfset var itemContent = ''>
	<cfset var content = ''>
	<cfset var contentAttributeValuesList = ''>
	<cfsavecontent variable="itemContent">
		<cfswitch expression="#VARIABLES.renderMode#">
			<cfcase value="module">
				<cfmodule template="#ATTRIBUTES.renderPath##ATTRIBUTES.renderModule#.cfm" attributeCollection="#arguments#">
			</cfcase>
			<cfcase value="include">
				<cftry>
					<cfinclude template="#ATTRIBUTES.renderPath#_#ATTRIBUTES.renderInclude#.cfm">
					<cfcatch>
						<cfdump var="#cfcatch#"><cfabort>
						<cfif structKeyExists(REQUEST,"__stage") AND REQUEST.__stage EQ "build">
							<cfdump var="#ARGUMENTS.data#" title="Data">
							<cfdump var="#cfcatch#" title="Exception Dump">
							<cfabort>
						</cfif>
						<cfabort>
					</cfcatch>
				</cftry>
			</cfcase>
			<cfdefaultCase>
				<cfscript>
				if (VARIABLES.ATTRIBUTES.displayField EQ '')  {
					content = data[1];
				} else {
					if (reFindNoCase("##*##",VARIABLES.ATTRIBUTES.displayField)) {
						content = evaluate(VARIABLES.ATTRIBUTES.displayField);
					} else {
						content = VARIABLES.data[VARIABLES.ATTRIBUTES.displayField];
					}
				}
				if (len(VARIABLES.ATTRIBUTES.formatter)) {
					content = VARIABLES.root.collaborate._formatter(VARIABLES.ATTRIBUTES.formatter,itemContent,VARIABLES.ATTRIBUTES);
				}
				VARIABLES.innerDataAttributeList = '';
					for (iAttrib in VARIABLES.thisTag.innerDataATTRIBUTES) {
						if (reFindNoCase("##*##",VARIABLES.thisTag.innerDataATTRIBUTES[iAttrib])) {
							VARIABLES.innerDataAttributeList = listAppend(VARIABLES.innerDataAttributeList,'#right(iAttrib,len(iAttrib)-5)#="#evaluate(VARIABLES.thisTag.innerDataATTRIBUTES[iAttrib])#"'," ");
						} else {
							VARIABLES.innerDataAttributeList = listAppend(VARIABLES.innerDataAttributeList,'#right(iAttrib,len(iAttrib)-5)#="#data[VARIABLES.thisTag.innerDataATTRIBUTES[iAttrib]]#"'," ");
						}
					}
					VARIABLES.linkDataAttributeList = '';
					for (iAttrib in VARIABLES.thisTag.linkDataATTRIBUTES) {
						if (reFindNoCase("##*##",thisTag.linkDataATTRIBUTES[iAttrib])) {
							linkDataAttributeList = listAppend(linkDataAttributeList,'#right(iAttrib,len(iAttrib)-5)#="#evaluate(thisTag.linkDataATTRIBUTES[iAttrib])#"'," ");
						} else {
							linkDataAttributeList = listAppend(linkDataAttributeList,'#right(iAttrib,len(iAttrib)-5)#="#data[thisTag.linkDataATTRIBUTES[iAttrib]]#"'," ");
						}
					}
					if (VARIABLES.innerDataAttributeList NEQ ''){
						VARIABLES.innerDataAttributeList = ' ' & VARIABLES.innerDataAttributeList;
					}
					if (VARIABLES.linkDataAttributeList NEQ ''){
						VARIABLES.linkDataAttributeList = ' ' & VARIABLES.linkDataAttributeList;
					}
					writeOutput('<#VARIABLES.ATTRIBUTES.itemWrapElement##VARIABLES.innerAttributeList##VARIABLES.innerDataAttributeList#>');
					if (VARIABLES.ATTRIBUTES.link NEQ '') {
						VARIABLES.link = '';
						if(!len(VARIABLES.ATTRIBUTES.linkField)){ VARIABLES.ATTRIBUTES.linkField = "link"; }
						if (VARIABLES.ATTRIBUTES.linkField NEQ '') {
							if (reFindNoCase("##*##",VARIABLES.ATTRIBUTES.linkField)) {
								VARIABLES.link = evaluate(VARIABLES.ATTRIBUTES.linkField);
							} else {
								VARIABLES.link = ARGUMENTS.data[VARIABLES.ATTRIBUTES.linkField];
							}
						}
						writeOutput('<a href="#VARIABLES.ATTRIBUTES.link##VARIABLES.link##VARIABLES.ATTRIBUTES.postLink#"#VARIABLES.linkAttributeList##VARIABLES.linkDataAttributeList#>#content#</a>');
					}
					else if (VARIABLES.ATTRIBUTES.link EQ '' AND VARIABLES.ATTRIBUTES.linkField NEQ ''){
						if (VARIABLES.ATTRIBUTES.linkField NEQ '') {
							if (reFindNoCase("##*##",VARIABLES.ATTRIBUTES.linkField)) {
								link = evaluate(VARIABLES.ATTRIBUTES.linkField);
							} else {
								link = data[ATTRIBUTES.linkField];
							}
						}
						writeOutput('<a href="#VARIABLES.ATTRIBUTES.link##link#"#VARIABLES.linkAttributeList##VARIABLES.linkDataAttributeList#>#content#</a>');
					} else {
						writeOutput(content);
					}
						writeOutput('</#VARIABLES.ATTRIBUTES.itemWrapElement#>');
				</cfscript>
			</cfdefaultCase>
		</cfswitch>
	</cfsavecontent>

	<cfreturn itemContent>
</cffunction>

<cfsetting enablecfoutputonly="false">