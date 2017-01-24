component persistent="true" table="site__group"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="group_id" column="group_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="group_main" column="group_main" type="string" ormtype="string" ; 
	property name="app" column="app" type="string" ormtype="string" ; 
	
	/* Relational Properties */
	property name="roles" type="array" fieldtype="many-to-many" 
		cfc="site__role" linktable="site__group_role"  fkcolumn="group_id" 
		inversejoincolumn="role_id" ;
		
} 
