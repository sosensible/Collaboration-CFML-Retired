<cfcomponent output="false">

	<cfscript>
	import "_site.data.*"; // data/ORM object classes
	</cfscript>
	<!---
	<cfproperty name="site" type="dio" dioclass="@@application@@.@site@.site" dioname="site" dioaccess="public" />
	<cfproperty name="device" type="dio" dioclass="@@session@@.@site@.device" dioname="device" dioaccess="public" />
	<cfproperty name="site2" type="dio" dioclass="@@application@@.@site@.site" dioname="site" dioaccess="private" />
	<cfset VARIABLES.redirectSettings = {}>
	
	<cffunction name="onFactoryCreate" access="public" output="false">
		<cfscript>
		VARIABLES.getFields = "user_id";
		set_guest();
	//	arrayAppend(REQUEST._log,{loc='_user.onFactoryCreate()',note='THIS .. (variables - #structKeyList(VARIABLES)#)'});
	//	arrayAppend(REQUEST._log,{loc='_user.onFactoryCreate()',note='THIS .. (this - #structKeyList(this)#)'});
		arrayAppend(REQUEST._log,{loc='_user.onFactoryCreate()',note='THIS .. (device has device variable - #VARIABLES.device.get_vCheck('device')#)'});
		arrayAppend(REQUEST._log,{loc='_user.onFactoryCreate()',note='THIS .. (device has device this - #VARIABLES.device.get_tCheck('device')#)'});
		arrayAppend(REQUEST._log,{loc='_user.onFactoryCreate()',note='THIS .. (site has config variable - #VARIABLES.site.get_vCheck('cfg')#)'});
		</cfscript>
	</cffunction>
	--->

	<cffunction name="init" access="public" output="false">
		<cfargument name="site" />
		<cfargument name="device" default="#structNew()#"/>

		<cfscript>
		// import "/_site/data.*";
		
		VARIABLES.site = ARGUMENTS.site;
		VARIABLES.getFields = "user_id";
		VARIABLES.redirectSettings = {};
		VARIABLES.device = ARGUMENTS.device;
	//	VARIABLES.oUser = entityNew("site__user");
		VARIABLES.redirectSettings = {};
	//	arrayAppend(REQUEST._log,{loc='_user.init()',device=VARIABLES.device,site=variables.site});
		VARIABLES.rs = queryNew("");
		
		set_guest();

		return THIS;
		</cfscript>
	</cffunction>


	<cffunction name="login" access="public" output="false">
		<cfargument name="user_main" required="true" />
		<cfargument name="password" required="true" />

		<cfscript>
		var DS = {}; // for holding data sets used to pull ORM entities
		var rsRoles = "";
		var result = "";
		var filter = [];
		var str = {};
		var o = {}; // array for holding objects

		// import "/_site/data.*";
		// import "/_site/data2.*";

		o.sUser = new "site__userService"();

		if(isDefined("o.login")){


			VARIABLES.oUser = duplicate(o.login);
			VARIABLES.rs = entityToQuery(VARIABLES.oUser);
			VARIABLES.user_id = o.login.getUser_id();
			VARIABLES.groups = "";
			VARIABLES.roles = "";
			VARIABLES.groups = entityToQuery(o.login.getGroups());
			VARIABLES.roles = o.sUser.getsite__userroles(o.login.getUser_id());
			result = {
				value = true,
				message = "You have been logged in."
			};

			if (len(o.login.getSkin())) {
				set_skin(o.login.getSkin());
				session.__cfish.initRequest(skin:o.login.getSkin());
			}
		} else {
			set_guest();
			result = {
				value = false,
				message = "Your entry did not match our system so you were not logged in."
			};
		}

		return result;
		</cfscript>
	</cffunction>

	<cffunction name="set_skin" access="public" output="false">
		<cfargument name="skin">
		<cfscript>
		VARIABLES.skin = createObject("component","#APPLICATION._site.get_shareClassPath()#skins.objects.skin").init(SESSION.__cfish,ARGUMENTS.skin);
		</cfscript>
	</cffunction> 

	<cffunction name="get_skinCSSPath" access="public" output="false">
		<cfscript>
		return VARIABLES.skin.get_CSSPath();
		</cfscript>
	</cffunction>

	<cffunction name="get_skinName" access="public" output="false">
		<cfscript>
		return VARIABLES.skin.get_name();
		</cfscript>
	</cffunction>

	<cffunction name="get_skinMediaPath" access="public" output="false">
		<cfscript>
		return VARIABLES.skin.get_MediaPath();
		</cfscript>
	</cffunction>

	<cffunction name="get_skinPath" access="public" output="false">
		<cfscript>
		return VARIABLES.skin.get_path();
		</cfscript>
	</cffunction>

	<cffunction name="get_device" access="public" output="false">
		<cfscript>
		return VARIABLES.device.get_device();
		</cfscript>
	</cffunction>

	<cffunction name="get_deviceCheck" access="public" output="false">
		<cfscript>
		return VARIABLES.device.get_vCheck('device');
		</cfscript>
	</cffunction>

	<cffunction name="isMobile" access="public" output="false">
		<cfscript>
		return VARIABLES.device.isMobile();
		</cfscript>
	</cffunction>

	<cffunction name="logout" access="public" output="false">
		<cfscript>
		set_guest();
		APPLICATION._site.set_skinName();
		</cfscript>
	</cffunction>

	<cffunction name="get_emailRS" access="public" output="false">
		<cfargument name="email" required="true" />

		<cfscript>
		var rsLoopup = "";
		var DS = {
			email = ARGUMENTS.email
 		};

		if(VARIABLES.oUser.recordCount == 0){
			rsLookup = entityload("site__user",DS,true);
			if(isDefined("rsLookup")){
				return rsLookup;
			}
		} else {
			return VARIABLES.oUser;
		}
		return "";
		</cfscript>

	</cffunction>

	<cffunction name="get_userRS" access="public" output="false">

		<cfreturn VARIABLES.rs>

	</cffunction>

	<cffunction name="get_stdFields" access="public" output="false">
		<cfscript>
		if(VARIABLES.oUser.recordCount){
			return "user_id,user_main,password,email,firstName,lastName,address,address2,city,state,zip,country,providence,phone,created_on,updated_on,title_seo,keywords_seo,description_seo";
		} else {
			return "";
		}
		</cfscript>
	</cffunction>

	<cffunction name="get_listFields" access="public" output="false">
		<cfscript>
		if(VARIABLES.oUser.recordCount){
			return "userType_id";
		} else {
			return "";
		}
		</cfscript>
	</cffunction>

	<cffunction name="update" access="public" output="false">
		<cfargument name="user_main" default="#EntityToQuery(VARIABLES.oUser).User_main#" >
		<cfargument name="password" default="#EntityToQuery(VARIABLES.oUser).Password#" >
		<cfargument name="email" default="#EntityToQuery(VARIABLES.oUser).Email#" >
		<cfargument name="firstName" default="#EntityToQuery(VARIABLES.oUser).FirstName#" >
		<cfargument name="lastName" default="#EntityToQuery(VARIABLES.oUser).LastName#" >
		<cfargument name="address" default="#EntityToQuery(VARIABLES.oUser).Address#" >
		<cfargument name="address2" default="#EntityToQuery(VARIABLES.oUser).Address2#" >
		<cfargument name="city" default="#EntityToQuery(VARIABLES.oUser).City#" >
		<cfargument name="state" default="#EntityToQuery(VARIABLES.oUser).State#" >
		<cfargument name="zip" default="#EntityToQuery(VARIABLES.oUser).Zip#" >
		<cfargument name="country" default="#EntityToQuery(VARIABLES.oUser).Country#" >
		<cfargument name="providence" default="#EntityToQuery(VARIABLES.oUser).Providence#" >
		<cfargument name="phone" default="#EntityToQuery(VARIABLES.oUser).Phone#" >
		<cfargument name="img" default="#EntityToQuery(VARIABLES.oUser).Img#" >
		<cfargument name="imgHeight" default="#EntityToQuery(VARIABLES.oUser).ImgHeight#" >
		<cfargument name="imgWidth" default="#EntityToQuery(VARIABLES.oUser).ImgWidth#" >
		<cfargument name="title_seo" default="#EntityToQuery(VARIABLES.oUser).Title_seo#" >
		<cfargument name="keyWords_seo" default="#EntityToQuery(VARIABLES.oUser).Keywords_seo#" >
		<cfargument name="description_seo" default="#EntityToQuery(VARIABLES.oUser).Description_seo#" >
		<cfargument name="userType" default="#EntityToQuery(VARIABLES.oUser).Usertype_id#" >
		<cftry>
		<cfscript>
		var result = {
			value = true,
			message = "Your account record has been updated."
		};
		var DS = "";
			if(val(VARIABLES.oUser.getUser_id())){
				DS = { user_id = VARIABLES.oUser.getUser_id() };
				ARGUMENTS.user.user_id = VARIABLES.oUser.getUser_id();
				VARIABLES.oUser.setUser_main(ARGUMENTS.user_main);
				if(len(ARGUMENTS.password)){
					VARIABLES.oUser.setPassword(ARGUMENTS.password);
				}
				VARIABLES.oUser.setEmail(ARGUMENTS.email);
				VARIABLES.oUser.setFirstName(ARGUMENTS.firstName);
				VARIABLES.oUser.setLastName(ARGUMENTS.lastName);
				VARIABLES.oUser.setAddress(ARGUMENTS.address);
				VARIABLES.oUser.setAddress2(ARGUMENTS.address2);
				VARIABLES.oUser.setCity(ARGUMENTS.city);
				VARIABLES.oUser.setState(ARGUMENTS.state);
				VARIABLES.oUser.setZip(ARGUMENTS.zip);
				VARIABLES.oUser.setCountry(ARGUMENTS.country);
				VARIABLES.oUser.setProvidence(ARGUMENTS.providence);
				VARIABLES.oUser.setPhone(ARGUMENTS.phone);
				VARIABLES.oUser.setImg(ARGUMENTS.img);
				VARIABLES.oUser.setImgHeight(val(ARGUMENTS.imgHeight));
				VARIABLES.oUser.setImgWidth(val(ARGUMENTS.imgWidth));
				VARIABLES.oUser.setUpdated_on(now());
				VARIABLES.oUser.setTitle_seo(ARGUMENTS.title_seo);
				VARIABLES.oUser.setKeywords_seo(ARGUMENTS.keyWords_seo);
				VARIABLES.oUser.setDescription_seo(ARGUMENTS.description_seo);
				//VARIABLES.oUser.setUsertype_id(ARGUMENTS.userType);

				entitySave(VARIABLES.oUser);
				ormFlush();
				VARIABLES.oUser = entityload("site__user",DS,true);
				if (isDefined("VARIABLES.oUser")) {
					VARIABLES.groups = VARIABLES.oUser.getGroups();
					VARIABLES.roles = VARIABLES.oUser.getRoles();
				}
			}

		return result;
		</cfscript>
		<cfcatch>
			<cfdump var="#variables.oUser#">
			<cfdump var="#arguments.imgHeight#">
			<cfdump var="#cfcatch#"><cfabort>
		</cfcatch>

		</cftry>
	</cffunction>

	<cffunction name="register" access="public" output="false">
		<cfargument name="user_main" required="true" />
		<cfargument name="email" required="true" />
		<cfargument name="password" required="true" />

		<cfscript>
		var result = {
			value = true,
			registrationID = "",
			message = "Registration ID created"
		};
		var DStype = { usertype_main = "Registered" };
		var rsType = entityload("site__userType",dsType,true);

		var DScheck = { user_main = ARGUMENTS.userName };
		var rsCheck = entityload("site__user",DScheck);
		var rsRegister = "";
		var oUser = createObject("#VARIABLES.site.get_dataClassPath()#site__user"); 

		// check if user name already exists
		if(arrayLen(rsCheck)){
			result.value = false;
			result.message = "The user name you requested already exists.";
		} else {
			DScheck = { email = ARGUMENTS.userEmail };
			// check if email already exists
			rsCheck = entityload("site__user",DScheck);
			if(arrayLen(rsCheck)){
				result.value = false;
				result.message = "The email you requested already exists.";
			} else {
				oUser.setUser_main(ARGUMENTS.user_main);
				oUser.setEmail(ARGUMENTS.email);
				oUser.setPassword(ARGUMENTS.password);
				oUser.setRegistrationid(createUUID());
				oUser.setUserTypeid(iif(isDefined("rsType"),'rsType.getUserTypeID()',0));
				entitySave(oUser);
				result.registrationid = oUser.getRegistrationID();
			}
		}

		return result;
		</cfscript>

	</cffunction>

	<cffunction name="validate" access="public" output="false">
		<cfargument name="validationCode" required="true" />

		<cfscript>
		var result = {
			value = true,
			message = "Your account record has been validated."
		};
		var DS = {
			registrationid = ARGUMENTS.validationCode
		};
		var rsValidate = entityload("site__user",ds,true);
		var DStype = { usertype_main = "Member" };
		var rsType = entityload("site__userType",DStype);
		var rsUser = '';
		var rsUserGroup = '';

		if(isDefined("rsValidate")){
			DS = {
				user_id = rsValidate.user_id
			};
			rsUser = entityLoad("site__user",ds,true);
			rsUser.setUserTypeID = iif(isDefined("rsType"),'rsType.getUserTypeID()',0);
			entitySave(rsUser);
			DS = {
				user_id = rsValidate.user_id,
				group_id=2
			};
			rsUserGroup = createObject("#_api.site.getDataClassPath()#site__group_User");
			rsUserGroup.setUser_id(rsValidate.getUser_id());
			rsUserGroup.setGroup_id(2);

			entitySave(rsUserGroup);
		} else {
			result.value = false;
			result.message = "Your validation code was not found";
		}

		return result;
		</cfscript>
	</cffunction>

	<cffunction name="set_guest" access="public" output="false">
		<cfscript>
		VARIABLES.user_id = 0;
		/*
		writeDump(VARIABLES.site.GETOBJECTCLASSPATH());
		abort;
		*/
		VARIABLES.oUser = createObject("#VARIABLES.site.getDataClassPath()#site__user");
		VARIABLES.rs = entityToQuery(VARIABLES.oUser);
		VARIABLES.groups = "";
		VARIABLES.roles = "";
		</cfscript>
	</cffunction>

	<cffunction name="get_groups" access="public" output="false">
		<cfreturn VARIABLES.groups>
	</cffunction>

	<cffunction name="get_roles" access="public" output="false">
		<cfreturn VARIABLES.roles>
	</cffunction>

	<cffunction name="get_groupRoles" access="public" output="true">
		<cfargument name="user_id" required="true" />
		<cfscript>
		/*
		var mySQL = "SELECT gu.user_id,r.role_id,r.role_main,r.app
FROM site__group_user gu
	Inner Join site__group_role gr
	Inner Join site__role r
WHERE gu.user_id = #ARGUMENTS.user_id#
ORDER BY r.role_main";
		var rsRoles = ORMExecuteQuery(mySQL);
		var roles = "";
		var i = 0;
		var lastRole = "";

		for(i=1;i<=rsRoles.recordCount;i++){
			if(lastRole != rsRoles.role_main[i]){
				roles = listAppend(roles,rsRoles.bundle[i] & "__" & rsRoles.role_main[i]);
				lastRole = rsRoles.role_main[i];
			}
		}
		*/
		// VERY TEMPORARY. NEED TO ADDRESS
		return 1;
		</cfscript>
	</cffunction>

	<cffunction name="set_groups" access="public" output="false">
		<cfreturn VARIABLES.groups>
	</cffunction>

	<cffunction name="get_id" access="public" output="false">
		<cfreturn VARIABLES.user_id>
	</cffunction>

	<cffunction name="get_name" access="public" output="false">
		<cfscript>
		if(structKeyExists(VARIABLES.rs,"recordCount") && VARIABLES.rs.recordCount){
			return VARIABLES.rs.user_main;
		} else {
			return "guest";
		}
		</cfscript>
	</cffunction>

	<cffunction name="isLoggedIn" access="public" output="false">
		<cfreturn val(VARIABLES.user_ID)>
	</cffunction>

	<cffunction name="isAuthorized" displayname="Is Authorized" hint="This checks against the current user's roles for authorization." access="public" returntype="boolean" output="false">
		<cfargument name="roles" required="no" default="">
		<cfargument name="app" required="no" default="site">
		<cfargument name="test" required="no" default="false">

		<!--- isAuthorized body --->
		<cfscript>
		var myReturn = structNew();
		var iSet = "";
		var iRoles = "";
		var checkAll = FALSE;
		var checkSet = TRUE;
		var permission = "";
		</cfscript>

		<cfloop index="iSet" list="#arguments.roles#" delimiters="|">
			<cfset checkSet = TRUE>
			<cfif ARGUMENTS.test><cfoutput><hr>#iSet#</cfoutput></cfif>
			<cfloop index="iRole" list="#iSet#">
				<cfif find("__",iRole)>
					<cfset permission = iRole>
				<cfelse>
					<cfset permission = "#ARGUMENTS.app#__#iRole#">
				</cfif>
				<cfif ARGUMENTS.test><cfoutput>#iRole#/#permission#<hr></cfoutput></cfif>
				<cfif not listfindnocase(VARIABLES.roles,permission)>
					<cfset checkSet = FALSE>
				</cfif>
			</cfloop>
			<cfif checkSet>
				<cfset checkAll = TRUE>
			</cfif>
		</cfloop>

		<cfscript>if(arguments.test){
		writeDump(listToArray(variables.roles));
		writeDump(listToArray(get_groupRoles(4)));

		abort;
		}
		if(len(arguments.roles) EQ 0) {
			return true;
		} else {
			return checkAll;
		}
		</cfscript>
	</cffunction>

	<cffunction name="onMissingMethod" access="public" output="false">
		<cfargument name="missingMethodName"  />
		<cfargument name="missingMethodArguments" />

		<cfscript>
		var method = ARGUMENTS.missingMethodName;
		var mARG = "";
		var mLen = len(method);
		var mResult = "";
		</cfscript>
		<cfif len(mLen GT 3)
			AND listFindNoCase("set,get",left(method,3))>
			<cfset mARG = right(method,mLen-3)>
			<cfParam name="ARGUMENTS.value" default="">
			<cfinvoke
				method="#left(method,3)#"
				returnVariable="mResult">
				<cfinvokeArgument name="field" value="#mARG#" />
				<cfinvokeArgument name="value" value="#ARGUMENTS.value#" />
			</cfinvoke>

			<cfreturn mResult />
		</cfif>
	</cffunction>


	<cffunction name="storeRedirectSettings" access="public" output="false">
		<cfargument name="redirectURL">

		<cfset VARIABLES.redirectSettings.url = ARGUMENTS.redirectURL>
		<cfset VARIABLES.redirectSettings.attributes = duplicate(form)>
		<cfset structAppend(VARIABLES.redirectSettings.attributes,duplicate(url),"YES")>

	</cffunction>

	<cffunction name="retrieveRedirectSettings" access="public" output="false">
		<cfreturn VARIABLES.redirectSettings>
	</cffunction>

	<cffunction name="clearRedirectSettings" access="public" output="false">
		<cfset VARIABLES.redirectSettings = {}>
	</cffunction>

	<cffunction name="hasRedirectSettings" access="public" output="false">
		<cfreturn structKeyList(variables.redirectSettings) EQ 'attributes,url'>
	</cffunction>

	<!--- Missing Method Functions --->
	<cffunction name="get" access="private" output="true">
		<cfargument name="field">

		<cfset var val = ''>
		<cfif structKeyExists(VARIABLES.oUser,ARGUMENTS.field)>
			<cfinvoke returnVariable="val" object="#VARIABLES.oUser#" method="#ARGUMENTS.field#" />
			<cfreturn val>
		<cfelse>
			<cfif listFindNoCase(VARIABLES.getFields,ARGUMENTS.field)>
				<cfreturn VARIABLES[ARGUMENTS.field]>
			<cfelse>
				<cfreturn "">
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>