component persistent="true" table="site__role"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="role_id" column="role_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="role_main" column="role_main" type="string" ormtype="string" ; 
	property name="app" column="app" type="string" ormtype="string" ; 
	
	/* Relational Properties */
	property name="groups" type="array" fieldtype="many-to-many" 
		cfc="site__group" 
		linktable="site__group_role"  fkcolumn="role_id" inversejoincolumn="group_id" ;	
} 
