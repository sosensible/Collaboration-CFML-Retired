<cfcomponent output="false" extends="_user">

	<cffunction name="login" access="public" output="false">
		<cfargument name="user_main" required="true" />
		<cfargument name="password" required="true" />
		<cfargument name="requireValidated" default="true" />

		<cfscript>
		var DS = {}; // for holding data sets used to pull ORM entities
		var rsRoles = "";
		var result = "";
		var filter = [];
		var str = {};
		var o = {}; // array for holding objects
		/*
		import "/_site/data.*";
		import "/_site/data2.*";
		*/
		DS.user = {
			user_main = ARGUMENTS.user_main,
			password = ARGUMENTS.password
		};
		o.login = entityload("site__user",DS.user,true);
		
	//	o.sUser = new "site__userService"();
		if(isDefined("o.login") && (!arguments.requireValidated  || isDate(o.login.getValidationTime()))){
			VARIABLES.rs = entityToQuery(o.login);
			VARIABLES.user_id = o.login.getUser_id();
			VARIABLES.groups = "";
			VARIABLES.roles = "";
			VARIABLES.groups = entityToQuery(o.login.getGroups());
		//	VARIABLES.roles = o.sUser.getsite__userroles(o.login.getUser_id());
			VARIABLES.roles = o.login.getRoleList();
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

	<cffunction name="set_demouser" access="private" output="false">
		<cfscript>
		VARIABLES.user_id = 2;
		VARIABLES.rs = queryNew("user_id,user_main,password,firstname,lastname");
		VARIABLES.groups = "user";
		VARIABLES.roles = "guest";

		queryAddRow(VARIABLES.rs);
		querySetCell(VARIABLES.rs,"user_id","2");
		querySetCell(VARIABLES.rs,"user_main","demouser");
		querySetCell(VARIABLES.rs,"password","demo");
		querySetCell(VARIABLES.rs,"firstname","Demo");
		querySetCell(VARIABLES.rs,"lastname","User");
		</cfscript>
	</cffunction>

	<cffunction name="set_demoadmin" access="private" output="false">
		<cfscript>
		VARIABLES.user_id = 1;
		VARIABLES.rs = queryNew("user_id,user_main,password,firstname,lastname");
		VARIABLES.groups = "user,admin";
		VARIABLES.roles = "user,admin";

		queryAddRow(VARIABLES.rs);
		querySetCell(VARIABLES.rs,"user_id","1");
		querySetCell(VARIABLES.rs,"user_main","demoadmin");
		querySetCell(VARIABLES.rs,"password","demo");
		querySetCell(VARIABLES.rs,"firstname","Demo");
		querySetCell(VARIABLES.rs,"lastname","Admin");
		</cfscript>
	</cffunction>

</cfcomponent>