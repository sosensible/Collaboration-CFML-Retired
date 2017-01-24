component persistent="true" table="site__user"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="user_id" column="user_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="user_main" column="user_main" type="string" ormtype="string" unique="true" ; 
	property name="password" column="password" type="string" ormtype="string" default=""; 
	property name="user_guid" column="user_guid" type="string" ormtype="string" default="" ; 
	property name="originalEmail" column="originalEmail" type="string" ormtype="string" default=""; 
	property name="email" column="email" type="string" ormtype="string" default=""; 
	property name="firstName" column="firstName" type="string" ormtype="string" default="" ; 
	property name="lastName" column="lastName" type="string" ormtype="string" default="" ; 
	property name="address" column="address" type="string" ormtype="string" default="" ; 
	property name="address2" column="address2" type="string" ormtype="string" default="" ; 
	property name="city" column="city" type="string" ormtype="string" default="" ; 
	property name="state" column="state" type="string" ormtype="string" default="" ; 
	property name="zip" column="zip" type="string" ormtype="string" default="" ; 
	property name="country" column="country" type="string" ormtype="string" default="" ; 
	property name="providence" column="providence" type="string" ormtype="string" default="" ; 
	property name="phone" column="phone" type="string" ormtype="string" default="" ; 
	property name="img" column="img" type="string" ormtype="string" default="" ; 
	property name="imgHeight" column="imgHeight" type="numeric" ormtype="int" ; 
	property name="imgWidth" column="imgWidth" type="numeric" ; 
	property name="created_on" column="created_on" type="date" ormtype="timestamp" ; 
	property name="updated_on" column="updated_on" type="date" ormtype="timestamp" ; 
	property name="title_seo" column="title_seo" type="string" ormtype="string" ; 
	property name="keywords_seo" column="keywords_seo" type="string" ormtype="string" ; 
	property name="description_seo" column="description_seo" type="string" ormtype="string" ; 
	property name="usertype_id" column="usertype_id" type="numeric" ormtype="int" ; 
	property name="validationcode" column="validationcode" type="string" ormtype="string" ; 
	property name="validationtime" column="validationtime" type="date" ormtype="timestamp" ; 
	property name="isdeleted" column="isdeleted" type="numeric" ormtype="byte" ;
	property name="isbanned" column="isbanned" type="numeric" ormtype="byte" default="0" ;
	property name="skin" column="skin" type="string" ormtype="string" default="" ; 
	
	/* Relational Properties */
	property name="groups" type="array" fieldtype="many-to-many" 
		cfc="site__group" inversejoincolumn="group_id"  
		linktable="site__group_user" fkcolumn="user_id" ;
	
	property name="subscription" type="array" fieldtype="many-to-many" 
		cfc="site__subscription" inversejoincolumn="subscription_id"  
		linktable="site__subscription_user" fkcolumn="user_id" lazy="true" ;
	
	property name="extDetail" type="array" fieldtype="one-to-one" 
		cfc="site__userextend" mappedby="site__user" ;
	
	property name="sites" type="array" fieldtype="many-to-many" 
		cfc="site__site" inversejoincolumn="site_id"  
		linktable="site__user_site" fkcolumn="user_id" lazy="true" ;
	
	//extra properties
	
	/* Over Ride Functions */
	
	
	/* Get site__user roles */
	public array function getRoles()
	{
		
		if(!structKeyExists(VARIABLES,"role_entities")){
			VARIABLES.role_entities = updateRoles();
		}
		
		return VARIABLES.role_entities;
	}
	
	public array function updateRoles()
	{
		var o = {};
		var i = {};
		
		VARIABLES.role_list = "";
		VARIABLES.role_entities = [];
		
		o.groups = getGroups();
		for(i.group in o.groups){
			for(i.role in i.group.getRoles()){
				if(!listFindNoCase(VARIABLES.role_list,i.role.getRole_Main())){
					VARIABLES.role_list = listAppend(VARIABLES.role_list,i.role.getapp()&"__"&i.role.getRole_main());
					arrayAppend(VARIABLES.role_entities,i.role);
				}
			}
		}
		return VARIABLES.role_entities;
	}
	
	public string function getRoleList()
	{
		var i = {};
		
		if(!structKeyExists(VARIABLES,"role_list")){
			VARIABLES.role_entities = getRoles();
			VARIABLES.role_list = "";
			for(i.role in VARIABLES.role_entities){
				VARIABLES.role_list = listAppend(VARIABLES.role_list,i.role.getapp()&"__"&i.role.getrole_main());
			}
		}
		
		return VARIABLES.role_list;
	}
	
	public query function getRoleQuery()
	{
		
		if(!structKeyExists(VARIABLES,"role_entities")){
			VARIABLES.role_entities = updateRoles();
		}
		
		return entityToQuery(VARIABLES.role_entities);
	}
	public void function preInsert(){
		var myNow = CreateODBCDateTime(now());
		
		setcreated_on(myNow);
		setupdated_on(myNow);
	}
	
	public void function preUpdate(){
		var myNow = CreateODBCDateTime(now());
		
		setupdated_on(myNow);;
	}
	
	public void function _check_field_lists(){
		VARIABLES.fields = {
			all = THIS._getPropertyList(),
			list = "",
			standard = "user_id,user_main,password,user_guid,originalEmail,email,firstName,lastName,address,address2,city,state,zip,country,providence,phone,img,imgHeight,imgWidth,created_on,updated_on,title_seo,keywords_seo,description_seo,usertype_id,validationcode,validationtime,isdeleted,isbanned,skin",
			required = THIS._getRequiredList()
		};
	}
} 
