<cfscript>
mySites = EntityLoad("site__site");
if(!arrayLen(mySites)){
	mySites = [];
	
	mySite = EntityNew("site__site");
	mySite.seturl(CGI.server_name);
	mySite.setroles("admin");
	EntitySave(mySite);
	arrayAppend(mySites,mySite);
	
	myUser = EntityNew("site__user");
	myUser.setUser_main("admin");
	myUser.setPassword("temp");
	myUser.setEmail("admin@");
	myUser.setFirstName("temp");
	myUser.setLastName("Admin");
	myUser.setValidationTime(now());
	myUser.setUser_guid(createUUID());
	// add sites here
	myUser.addSites( mySite );
	// create groups & roles and link objects
	// * admin
	myGroup = EntityNew("site__group");
	myGroup.setGroup_main("admin");
	myGroup.setApp("site");
	EntitySave(myGroup);
	myRole = EntityNew("site__role");
	myRole.setRole_main("admin");
	myRole.setApp("site");
	myRole.addGroups(myGroup);
	EntitySave(myRole);
	myUser.addGroups( myGroup );
	EntitySave(myUser);
	// * member
	myGroup = EntityNew("site__group");
	myGroup.setGroup_main("member");
	myGroup.setApp("site");
	EntitySave(myGroup);
	myRole = EntityNew("site__role");
	myRole.setRole_main("member");
	myRole.setApp("site");
	myRole.addGroups(myGroup);
	EntitySave(myRole);
	myUser.addGroups( myGroup );
	EntitySave(myUser);
	// * guest
	myGroup = EntityNew("site__group");
	myGroup.setGroup_main("guest");
	myGroup.setApp("site");
	EntitySave(myGroup);
	myRole = EntityNew("site__role");
	myRole.setRole_main("guest");
	myRole.setApp("site");
	myRole.addGroups(myGroup);
	EntitySave(myRole);
	myUser = EntityNew("site__user");
	myUser.setUser_main("guest");
	myUser.setPassword("");
	myUser.setEmail("guest@");
	myUser.setFirstName("guest");
	myUser.setLastName("user");
	myUser.addGroups( myGroup );
	myUser.addSites( mySite );
	EntitySave(myUser);
	// * registered ## no default members in this set
	myGroup = EntityNew("site__group");
	myGroup.setGroup_main("registered");
	myGroup.setApp("site");
	EntitySave(myGroup);
	myRole = EntityNew("site__role");
	myRole.setRole_main("registered");
	myRole.setApp("site");
	myRole.addGroups(myGroup);
	EntitySave(myRole);

	myGroup = EntityNew("site__Group");
	myGroup.setGroup_main("member");
	myGroup.setApp("wpd");
	EntitySave(myGroup);
	myRole = EntityNew("site__role");
	myRole.setRole_main("member");
	myRole.setApp("wpd");
	myRole.addGroups(myGroup);
	EntitySave(myRole);
}
</cfscript>