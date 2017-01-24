<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	The SOS ORM is the work of the community and managed by SOSensible Group, LLC.
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
	*** credit ***
	This is based on SimpleBasePersistentObject.cfc by Bob Silverberg also under Apache 2 lisc. at time
	of the first build of this object.
	
--->
<cfcomponent output="false">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new object.">
		<cfscript>
		configure();
		return this;
		</cfscript>
	</cffunction>

	<cffunction name="configure" access="Public" returntype="any" output="false" hint="I build a new object.">
		<cfscript>
		if(!structKeyExists(VARIABLES,"Metadata")){
			VARIABLES.Metadata = getMetadata(this);
			_param(VARIABLES.MetaData,"cleanseInput",false);
		}
		if(!structKeyExists(VARIABLES,"exception")){
			VARIABLES.exception = {
				exists = false,
				item = []
			};
		}
		</cfscript>
	</cffunction>
	
	<cffunction name="get_meta" access="public" returntype="any" output="false" hint="I return the meta structure for this object.">
		<cfreturn getMetaData(this)>
	</cffunction>

	<cffunction name="populate" access="public" returntype="any" output="false" hint="Populates the object with values from the arguments">
		<cfargument name="data" type="any" default="#structNew()#" />
		<cfargument name="propList" type="any" required="no" default="#ArrayNew(1)#" />
		<cfargument name="api" type="any" required="no" />
		<cfscript>
		var o = {};
		var ds = {};
		var hql = {};
		var file = {};
		
		configure();
		</cfscript>
		<cfloop array="#variables.Metadata.properties#" index="local.theProperty">
			<cfif structKeyExists(local.theProperty,"_file") AND structKeyExists(ARGUMENTS,"api")>
				<cfscript>
				local.thisFileCfg = local.theProperty._file;
				file[local.theProperty.column] = {
					api = listFirst(local.theProperty._file),
					method = listGetAt(local.theProperty._file,2),
					fileAction = listGetAt(local.theProperty._file,3),
					fileName = listGetAt(local.theProperty._file,4)
				};
				</cfscript>
				<cfdump var="#file#">
				<cfabort>
			</cfif>
			<cfif structKeyExists(local.theProperty,"_ignoreEmpty") and local.theProperty._ignoreEmpty>
				<cfif structKeyExists(ARGUMENTS.data,local.theProperty.column) AND !len(trim(ARGUMENTS.data[local.theProperty.column]))>
					<cfscript>
					structDelete(ARGUMENTS.data,local.theProperty.column);
					</cfscript>
				</cfif>
			</cfif>
		</cfloop>
		<cfloop array="#variables.Metadata.properties#" index="local.theProperty">
			<cftry>
			<cfscript>
			if(NOT ArrayLen(ARGUMENTS.propList) OR ArrayContains(ARGUMENTS.propList,local.theProperty.name))
			{	// If a propList was passed in only allow those properties to populate this entity
				if(NOT StructKeyExists(local.theProperty,"fieldType") OR local.theProperty.fieldType EQ "column")
				{	// normal simple data columns
					if(StructKeyExists(ARGUMENTS.data,local.theProperty.name)){
						// property has matching argument
						local.varValue = ARGUMENTS.data[local.theProperty.name];
						if((NOT StructKeyExists(local.theProperty,"notNull") OR NOT local.theProperty.notNull) AND NOT Len(local.varValue))
						{	// if nullable field is blank set to null
							_setPropertyNull(local.theProperty.name);
						} else 
						{	// cleanse input ?
							_param(
								structure:local,
								variable:"theProperty.cleanseInput",
								value:variables.Metadata.cleanseInput);
							if(local.theProperty.cleanseInput){
								local.varValue = _cleanse(local.varValue);
							}
							_setProperty(local.theProperty.name,local.varValue);
						}
					}
				} else if(local.theProperty.fieldType EQ "many-to-one")
				{	// many to one data columns
					/*
					if(StructKeyExists(ARGUMENTS.data,local.theProperty.fkcolumn)){
						local.fkValue = ARGUMENTS.data[local.theProperty.fkcolumn];
					} else if(StructKeyExists(ARGUMENTS.data,local.theProperty.name)) {
						local.fkValue = ARGUMENTS.data[local.theProperty.name];
					}
					if(StructKeyExists(local,"fkValue")){
						local.varValue = EntityLoadByPK(local.theProperty.name,local.fkValue);
						if(IsNull(local.varValue)){
							if(NOT StructKeyExists(local.theProperty,"notNull") OR NOT local.theProperty.notNull){
								_setPropertyNull(local.theProperty.name);
							} else {
								throw(detail:"Trying to load a null into the #local.theProperty.name#, but it doesn't accept nulls.");
							}
						} else {
							_setProperty(local.theProperty.name,local.varValue);
						}
					}
					*/
				} else if(local.theProperty.fieldType EQ "many-to-many")  
				{	// many to many data columns
					
				}
			}
			</cfscript>
			<cfcatch>
				<cfdump var="#local.theProperty#" label="Current Property">
				<cfdump var="#cfcatch#" label="there seems to have been a problem with the ( #local.theProperty.name# ) variable">
				<cfdump var="#ARGUMENTS.data#">
				<cfabort>
			</cfcatch>
			</cftry>
		</cfloop>
		<cfreturn this>
	</cffunction>

	<cffunction name="save" access="public" returntype="any" output="false" hint="Persists the object to the database.">
		<cfscript>
		validate();
		if(VARIABLES.exception.exists){
			throw(
				message : "You cannot save an item that does not validate.",
				type : "sos.orm.validation",
				detail : "This item is not valid. There are #arrayLen(VARIABLES.exception.item)# issues.",
				errorCode = ""
			);
		} else {
			entitySave(this);
		}
		return this;
		</cfscript>
	</cffunction>

	<cffunction name="validate" access="public" returntype="any" output="false" hint="Persists the object to the database.">
		<cfscript>
		var exception = {
			exists = false,
			item = []
		};
		
		VARIABLES.exception = exception;
		
		return duplicate(exception);
		</cfscript>
	</cffunction>
	
	<cffunction name="get_exceptions" access="public" returntype="any" output="false" hint="This returns any current exceptions for entity validation.">
		
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="any" hint="Deletes an object from the database.">
		<cfset entityDelete(this) />
	</cffunction>
	
	<cffunction name="get_allFields" access="public" returntype="any" output="false" hint="I return property fields that are list oriented.">
		<cfscript>
		_check_field_lists();
		return VARIABLES.fields.all;
		</cfscript>
	</cffunction>
	
	<cffunction name="get_listFields" access="public" returntype="any" output="false" hint="I return property fields that are list oriented.">
		<cfscript>
		_check_field_lists();
		return VARIABLES.fields.list;
		</cfscript>
	</cffunction>
	
	<cffunction name="get_standardFields" access="public" returntype="any" output="false" hint="I return property fields that are not list oriented.">
		<cfscript>
		_check_field_lists();
		return VARIABLES.fields.standard;
		</cfscript>
	</cffunction>
	
	<cffunction name="get_requiredFields" access="public" returntype="any" output="false" hint="I return property fields that are not list oriented.">
		<cfscript>
		_check_field_lists();
		return VARIABLES.fields.required;
		</cfscript>
	</cffunction>
	
	<cffunction name="_check_field_lists" access="public" returntype="any" output="false" hint="I check to see that the entity field types struct is set">
		<cfscript>
		if(!structKeyExists(VARIABLES,"fields")){
			VARIABLES.fields = {
				all = THIS._getPropertyList(),
				list = "",
				standard = "",
				required = THIS._getRequiredList()
			};
		}
		</cfscript>
	</cffunction>
	
	
	<!--- These private methods are used by the populate() method --->

	<cffunction name="_setProperty" access="private" returntype="void" output="false" hint="I set a dynamically named property">
		<cfargument name="name" type="any" required="yes" />
		<cfargument name="value" type="any" required="false" />
		<cfset var setMethod = this["set" & ARGUMENTS.name] />
		<cfset var getMethod = this["get" & ARGUMENTS.name] />
		
		<cfif IsNull(ARGUMENTS.value)>
			<cfset setMethod(javacast('NULL', '')) />
		<cfelse>
			<cfset setMethod(ARGUMENTS.value) />
		</cfif>
	</cffunction>
	
	<cffunction name="_setPropertyNull" access="private" returntype="void" output="false" hint="I set a dynamically named property to null">
		<cfargument name="name" type="any" required="yes" />
		<cfset _setProperty(ARGUMENTS.name) />
	</cffunction>

	<cffunction name="_cleanse" access="private" returntype="any" output="false" hint="I cleanse input via HTMLEditFormat. My implementation can be changed to support other cleansing methods.">
		<cfargument name="data" type="any" required="yes" />
		<cfreturn HTMLEditFormat(ARGUMENTS.data) />
	</cffunction>
	
	<cffunction name="_fileStore" access="private" returntype="any" output="false" hint="I store files passed in by the configuration of the target ORM entity class">
		<cfargument name="file" type="any" required="no">
		<cfscript>
		var fileStoreText = "";
		
		return fileStoreText;
		</cfscript>
	</cffunction>
	
	<cffunction name="_getAliasPath" access="private" returntype="any" output="false" hint="I return the unaliased path.">
	
	</cffunction>
	
	<cffunction name="_getAliasDirectory" access="private" returntype="any" output="false" hint="I return the unaliased path.">
	
	</cffunction>
	
	<cffunction name="_getPropertyList" access="public" returntype="any" output="false" hint="I return the unaliased path.">
		<cfscript>
		var properties = "";
		var i = {};
		var propArray = get_meta().properties;

		for(i.p=1;i.p<=arrayLen(propArray);i.p++){
			if(structKeyExists(propArray[i.p],"ormtype")){
				properties = listAppend(properties,propArray[i.p].name);
			} 
		}
		
		return properties;
		</cfscript>
	</cffunction>
	
	<cffunction name="_getRequiredList" access="public" returntype="any" output="false" hint="I return the unaliased path.">
		<cfscript>
		var properties = "";
		var i = {};
		var propArray = get_meta().properties;

		for(i.p=1;i.p<=arrayLen(propArray);i.p++){
			if(structKeyExists(propArray[i.p],"_required") && listFindNoCase("true,new",propArray[i.p]._required)){
				properties = listAppend(properties,propArray[i.p].name);
			}
		}
		
		return properties;
		</cfscript>
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
				str[item] = ARGUMENTS.value;
			}
		}
		
		return str[item];
		</cfscript>
	</cffunction>

</cfcomponent>

