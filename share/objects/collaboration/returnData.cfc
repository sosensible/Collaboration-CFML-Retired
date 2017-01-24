<cfcomponent name="dataList" displayName="dataList" output="false">
	<cffunction name="init" output="false">
		<cfargument name="appData">
		<cfargument name="delimiters" required="false" default=",">
		<cfargument name="classPath" required="false" default="share.">
		<cfscript>
		var meta = {};
		var validData = true;

		variables.data = arguments.appData;
		 if (isSimpleValue(variables.data)) {
		 	if (isJSONData(variables.data)) {
		 		variables.dataType = "JSON";
		 		variables.oJSON = createObject("component","#arguments.classPath#objects.cfjson.json");
		 		variables.data = variables.oJSON.decode(variables.data);
		 	} else if (isXML(variables.data)) {
		 		variables.dataType = "xml";
		 		variables.data = xmlParse(variables.data);
		 	}else {
				variables.dataType = 'List';
				variables.delimiters = arguments.delimiters;
				convertList2Array();
		 	}
		} else if (isQuery(variables.data)) {
			variables.dataType = 'Query';
		} else if (isArray(variables.data)) {
			variables.dataType = 'Array';
			if(arrayLen(variables.data) && is_ORM(variables.data)){
				variables.dataType = "ORMCollection";
				variables.oData = variables.data;
				variables.data = entityToQuery(variables.data);
			}
		}  else if (is_ORM(variables.data)) {
			variables.dataType = 'ORM';
			variables.oData = variables.data;
			variables.data = entityToQuery(variables.data);
		} else if (isStruct(variables.data)){
			variables.dataType = "structure";
		}  else if (isXMLDoc(variables.data)) {
			variables.dataType = 'XML';
		} else {
			validData = false;
		}
		if(!validData){
			_throw("That dataType is not currently supported by the returnData cfc");
		}

		return this;
		</cfscript>
	</cffunction>
	<cffunction name="convertList2Array" access="private">
		<cfscript>
		var newData = [];
		var i = {};
		var row = {};
		var value = "";

		for(i.item=1;i.item<=listLen(variables.data);i.item++){
			value = listGetAt(VARIABLES.data,i.item,VARIABLES.delimiters);
			row = {
				display = value,
				value = value
			};
			arrayAppend(newData,row);
		}
		VARIABLES.data = newData;
		VARIABLES.dataType = 'Array';
		</cfscript>
	</cffunction>
	<cffunction name="_throw">
		<cfargument name="detail">
		<cfthrow detail="#arguments.detail#">
	</cffunction>
	<cffunction name="getData" output="false">
		<cfargument name="position">
		<cfargument name="column" required="false"> 
		<cfargument name="xpathString" required="false"> 
		<cfif structKeyExists(variables,"data") and structKeyExists(variables,"dataType")>
			<cfinvoke method="get#variables.dataType#Data" argumentCollection="#arguments#" returnvariable="myReturn"></cfinvoke>
			<cfreturn myReturn>
		<cfelse>
			<cfthrow message="You must call the init method before calling the getData function." detail="The init function stores the data on the page and sets variables up that will be used later throughout the page, and must be called first.">
		</cfif>
	</cffunction>
	<cffunction name="getListData" output="false" access="private">
		<cfscript>
		var myDataValue = listGetAt(variables.data,arguments.position,variables.delimiters);
		var myReturn = {
			value = myDataValue,
			display = myDataValue
		};

		return myReturn;
		</cfscript>
		<!---
		<cfreturn listGetAt(variables.data,arguments.position,variables.delimiters)>
		--->
	</cffunction>
	<cffunction name="getXMLData" output="false" access="private">
		<cfset var returnData = ''>
		<cfset var selector = ''>
		<cfset returnData =  xmlSearch(variables.data,arguments.xPathString)>
		<cfset selector = returnData[arguments.position].xmlType>
		<cfif selector Eq 'element'>
			<cfset selector = "xmlText">
		<cfelse>
			<cfset selector = "xmlValue">
		</cfif>
		<cfset returnData = returnData[arguments.position][selector]>
		<cfreturn returnData>
	</cffunction>
	<cffunction name="getArrayData" output="false" access="private">
		<cfif NOT isSimpleValue(variables.data[1]) AND NOT isStruct(variables.data[1])>
			<cfif isXML(variables.data[1])>
				<cfinvoke method="getXMLData" argumentcollection="#arguments#" returnvariable="myReturn">
				<cfreturn myReturn>
			</cfif>
		</cfif>
		<cfif isStruct(variables.data[arguments.position])>
			<cfif structKeyExists(variables.data[arguments.position],arguments.column)>
				<cfreturn variables.data[arguments.position][arguments.column]>
			</cfif>
		<cfelse>
			<cfreturn variables.data[arguments.position]>
		</cfif>
	</cffunction>
	<cffunction name="getQueryData" output="false" access="private">
		<cfreturn variables.data[arguments.column][arguments.position]>
	</cffunction>
	<cffunction name="getORMData" output="false" access="private">
		<cfreturn variables.data[arguments.column][arguments.position]>
	</cffunction>
	<cffunction name="getORMCollectionData" output="false" access="private">
		<cfreturn variables.data[arguments.column][arguments.position]>
	</cffunction>
	<cffunction name="getJSONData">
		<cfif isArray(variables.data) AND isStruct(variables.data[arguments.position])>
			<cfif structKeyExists(variables.data[arguments.position],arguments.column)>
				<cfreturn variables.oJSON.encode(variables.data[arguments.position][arguments.column])>
			</cfif>
		<cfelseif isStruct(variables.data) AND isArray(variables.data[arguments.column])>
			<cfreturn variables.data[arguments.column][arguments.position]>
		<cfelse>
			<cfreturn variables.oJSON.encode(variables.data[arguments.position])>
		</cfif>
	</cffunction>
	<cffunction name="getStructureData" access="private" output="false">
		<cfreturn variables.data[arguments.column][arguments.position]>
	</cffunction>

	<cffunction name="getDataType" output="false">
		<cfreturn variables.dataType>
	</cffunction>

	<cffunction name="recordCount" output="false">
		<cfargument name="xPathString" required="false">
		<cfscript>
		switch (variables.dataType) {
			case 'Query':
			case 'ORM':
			case 'ORMCollection': {
				return variables.data.recordCount;
				break;
			}
			case 'List': {
				return listLen(variables.data,variables.delimiters);
				break;
			}
			case 'array': {
				return arrayLen(variables.data);
				break;
			}
			case 'xml': {
				return arrayLen(xmlSearch(variables.data,arguments.xPathString));
				break;
			}
			case 'structure': {
				return arrayLen(variables.data[listFirst(structKeyList(variables.data))]);
				break;
			}
		}
		</cfscript>
	</cffunction>

	<cffunction name="returnDataRSRow" output="false">
		<cfargument name="selector" required="false" default="">


		<!--- 
		Include processing for each data Type
		 --->
		<cfset var columnList = getColumnList(arguments.selector)>
		<cfset var returnData = queryNew(columnList)>
		<cfset var position = arguments.selector>
		<cfset var argumentStruct = structNew()>
		<cfset var currentValue = ''>

		<cfif NOT isNumeric(arguments.selector)>
			<cfset position = 1>
		</cfif>

		<cfset queryAddRow(returnData)>

		<cfloop from="1" to="#listLen(columnList)#" index="iColumn">
			<cfset currentColumn = listGetAt(columnList,iColumn)>
			<cfset argumentStruct.position = position>
			<cfif NOT isNumeric(arguments.selector)>
				<cfset argumentStruct.xPathString = arguments.selector>
			<cfelse>
				<cfset argumentStruct.column = currentColumn>
			</cfif>
			<cfinvoke method="get#variables.dataType#Data" argumentCollection="#argumentStruct#" returnvariable="currentValue">
			<cfset querySetCell(returnData,currentColumn,currentValue)>
		</cfloop>
		<cfreturn returnData>
	</cffunction>

	<cffunction name="returnORMRow" output="false">
		<cfargument name="selector" required="false" default="">
		<cfif structKeyExists(VARIABLES,"oData")>
			<cfif isArray(variables.oData)>
				<cfreturn variables.oData[ARGUMENTS.selector]>
			<cfelseif ARGUMENTS.selector EQ 1>
				<cfreturn VARIABLES.oData>
			<cfelse>
				<cfthrow type="sos.returnData" message="cannot return ORM row because only one row"
					detail="The data passed into the returnData object had only one row.">
			</cfif>
		<cfelse>
			<cfthrow type="sos.returnData" message="cannot return ORM row because data not ORM"
				detail="The data passed into the returnData object was not an ORM entity data type.">
		</cfif>
	</cffunction>

	<cffunction name="returnDataRowStruct" output="false">
		<cfargument name="selector" required="false" default="">

		<!--- 
		Include processing for each data Type
		 --->
		<cfscript>
		var columnList = getColumnList(arguments.selector);
		var returnData = structNew();
		var position = arguments.selector;
		var argumentStruct = structNew();
		var currentValue = '';
		var i = {};
		var currentColumn = {};
		</cfscript>

		<cfif NOT isNumeric(arguments.selector)>
			<cfset position = 1>
		</cfif>
		<cfloop from="1" to="#listLen(columnList)#" index="i.column">
			<cfset currentColumn = listGetAt(columnList,i.column)>
			<cfset argumentStruct.position = position>
			<cfif NOT isNumeric(arguments.selector)>
				<cfset argumentStruct.xPathString = arguments.selector & '[' & i.column & ']'>
			<cfelse>
				<cfset argumentStruct.column = currentColumn>
			</cfif>
			<cftry>
			<cfinvoke method="get#variables.dataType#Data" argumentCollection="#argumentStruct#" returnvariable="currentValue">
			<cfset returnData[currentColumn] = currentValue>
			<cfcatch>
			</cfcatch>
			</cftry>

		</cfloop>
		<cfreturn returnData>
	</cffunction>

	<cffunction name="returnEntireRS" output="false">
		<cfargument name="selector" required="false" default="">
		<cfset var columnList = getColumnList(arguments.selector)>
		<cfset var returnData = queryNew(columnList)>
		<cfset var position = arguments.selector>
		<cfset var argumentStruct = structNew()>
		<cfset var currentValue = ''>
		<cfset var iRow = 0>


		<cfloop from="1" to="#recordCount(arguments.selector)#" index="iRow">
		<cfset queryAddRow(returnData)>

			<cfloop from="1" to="#listLen(columnList)#" index="iColumn">
				<cfset currentColumn = listGetAt(columnList,iColumn)>
				<cfset argumentStruct.position = iRow>
				<cfset argumentStruct.column = currentColumn>
				<cfinvoke method="get#variables.dataType#Data" argumentCollection="#argumentStruct#" returnvariable="currentValue">
				<cfset querySetCell(returnData,currentColumn,currentValue)>
			</cfloop>
		</cfloop>
		<cfreturn returnData>
	</cffunction>

	<cffunction name="getColumnList" output="false">
		<cfargument name="selector">

		<cfset var XMLArray = ''>
		<cfset var columnList = ''>

		<cfif variables.dataType EQ 'XML'>
			<!--- Handle xml data here... --->
			<cfset XMLArray = xmlSearch(variables.data,arguments.selector)>
			<cfloop from="1" to="#arrayLen(XMLArray)#" index="i">
				<cfif NOT listFindNoCase(columnList,xmlArray[i].xmlName)>
					<cfset columnList = listAppend(columnList,XMLArray[i].xmlName)>
				</cfif>
			</cfloop>
			<cfreturn columnList>
		<cfelse>
			<!--- DataTypes:
			arrays
			lists
			
			Query
			Struct
			
			ArrayOfStructures
			StructuresOfArrays
			
			JSON
			<cfdump var="#variables.data#">
			<cfdump var="#variables.dataType#">
			<cfdump var="#structKeyList(variables.data[1])#">
			<cfabort>
			 --->
			<cfswitch expression="#variables.dataType#">
				<cfcase value="list">
					<cfreturn "1">
				</cfcase>

				<cfcase value="array">
					<cfif isSimpleValue(variables.data[1])>
						<cfreturn "1">
					<cfelseif isStruct(variables.data[1])>
						<cfreturn structKeyList(variables.data[1])>
					</cfif>
				</cfcase>

				<cfcase value="structure">
					<cfreturn structKeyList(variables.data)>
				</cfcase>

				<cfcase value="Query,ORM,ORMCollection">
					<cfreturn variables.data.columnList>
				</cfcase>

				<cfcase value="JSON">
					<cfif isStruct(variables.data)>
						<cfreturn structKeyList(variables.data)>
					<cfelseif isArray(variables.data)>
						<cfif isStruct(variables.data[1])>
							<cfreturn structKeyList(variables.data[1])>
						<cfelse>
							<cfreturn 1>
						</cfif>
					<cfelse>
						<cfreturn 1>
					</cfif>
				</cfcase>
			</cfswitch>
		</cfif>
	</cffunction>

	<cffunction name="getSet">
		<cfargument name="returnFormat" default="#variables.dataType#">
		<cfargument name="pageSize" default="#recordCount()#">
		<cfargument name="page" default="1">

		<!--- By default it will return all records --->
		<cfset var set = ''>
		<cfset var setData = structNew()>
		<cfset var data = ''>
		<cfset var startRow = ''>
		<cfset var endRow = ''>
		<cfset var _pageSize = ''>
		<cfset var pagesPossible = ''>
		<cfset var _page = ''>

		<cfif arguments.returnFormat EQ 'list' 
			AND (variables.dataType NEQ 'list'
			OR variables.dataType EQ  'array'
				 AND isStruct(variables.data[1]))>
			<cfthrow detail="Cannot return data other than lists or simple arrays with a return format of 'list'. Please specify a different return format for the requested set.">
		</cfif>

		<cfset data = returnEntireRS()>
		<cfset _pageSize = min(arguments.pageSize,recordCount())>
		<cfset pagesPossible = recordCount() / _pageSize>
		<cfset _page = min(arguments.page,pagesPossible)>

		<cfif _pageSize>
			<cfset startRow = _page * _pageSize - _pageSize + 1>
			<cfset endRow = _page * _pageSize>
		<cfelse>
			<cfset startRow = 1>
			<cfset endRow = data.recordCount>
		</cfif>
			<cfloop 
				query="data" 
				startrow="#startRow#" 
				endrow="#endRow#">
				<cfloop list="#data.columnList#" index="iField">
				<cfswitch expression="#arguments.returnFormat#">

					<cfcase value="list">
						<cfset set = listAppend(set,data[iField][currentRow])>
					</cfcase>

					<cfcase value="array">
						<cfif len(data.columnList)-1>
							<cfset setData[iField] = data[iField][currentRow]>
							<cfif NOT isArray(set)>
								<cfset set = arrayNew(1)>
							</cfif>
							<cfif iField EQ listLast(data.columnList)>
								<cfset arrayAppend(set,setData)>
							</cfif>
						<cfelse>
							<cfif NOT isArray(set)>
								<cfset set = arrayNew(1)>
							</cfif>
							<cfset arrayAppend(set,data[iField][currentRow])>
						</cfif>
					</cfcase>

					<cfcase value="structure">
						<cfif NOT isStruct(set)>
							<cfset set = structNew()>
						</cfif>
						<cfif NOT structKeyExists(set,iField)>
							<cfset set[iField] = arrayNew(1)>
						</cfif>
						<cfset arrayAppend(set[iField],data[iField][currentRow])>
					</cfcase>

					<cfcase value="query">
						<cfif NOT isQuery(set)>
							<cfset set = queryNew(data.columnList)>
						</cfif>

						<cfif iField EQ listFirst(data.columnList)>
							<cfset queryAddRow(set)>
						</cfif>

						<cfset querySetCell(set,iField,data[iField][currentRow])>
					</cfcase>

					<cfcase value="json">
						<cfif NOT isStruct(set)>
							<cfset set = structNew()>
						</cfif>
						<cfif NOT structKeyExists(set,iField)>
							<cfset set[iField] = arrayNew(1)>
						</cfif>
						<cfset arrayAppend(set[iField],data[iField][currentRow])>
						<cfif currentRow EQ data.recordCount>
							<cfset set = serializeJSON(set)>
						</cfif>
					</cfcase>

				</cfswitch>
				</cfloop>
			</cfloop>
		<cfreturn set/>
	</cffunction>

	<cffunction name="_dump">
			<cfargument name="variable">
			<cfdump var="#arguments.variable#">
			<cfabort>
		</cffunction>
	<cffunction name="isJSONData" output="false" returntype="boolean" access="public">
		<cfargument name="testValue" required="true" type="any">
		<!---
		NOTE: This function does not check if it is a syntatically correct JSON
		string, just if it is an "attempted" JSON 
		Author: Stefan.Vesterlund@gmail.com 
		--->
		<cfif NOT isSimpleValue(arguments.testValue)>
			<!--- if it is not a string, it is not JSON --->
			<cfreturn false>
		</cfif>
		<!--- remove eventual () from string (a common "invalid key" workaround") --->
		<cfset arguments.testValue=replace(arguments.testValue,'(',',','all')>
		<cfset arguments.testValue=replace(arguments.testValue,')',',','all')>  
		<cfif (left(arguments.testValue,1) is "{" 
				OR left(arguments.testValue,1) is  "[" 
				OR left(arguments.testValue,2) is "[{") 
				and (right(arguments.testValue,1) is "}" 

				OR right(arguments.testValue,1) is "]" 
				OR right(arguments.testValue,2) is "}]")>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>

	<cffunction name="is_ORMData" access="public" output="false">
		<cfreturn structKeyExists(VARIABLES,"oData")>
	</cffunction>

	<cffunction name="is_ORM" access="private" output="false">
		<cfargument name="item">
		<cfscript>
		var metaItem = {};
		try{
			if(isArray(ARGUMENTS.item) && arrayLen(ARGUMENTS.item)){
				metaItem = getMetadata(ARGUMENTS.item[1]);
			} else {
				metaItem = getMetadata(ARGUMENTS.item);
			}
			if(structKeyExists(metaItem,'persistent') && metaItem.persistent){
				return true;
			} else {
				return false;
			}
		} catch(any e){
			return false;
		}
		</cfscript>
	</cffunction>
</cfcomponent>