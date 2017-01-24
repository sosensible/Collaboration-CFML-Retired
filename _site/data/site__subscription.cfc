component persistent="true" table="site__subscription"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="subscription_id" column="subscription_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="user_id" column="user_id" type="numeric" ormtype="int"; 
	
	property name="subscriber" type="array" fieldtype="many-to-many" 
		cfc="site__user" inversejoincolumn="user_id"  
		linktable="site__subscription_user" fkcolumn="subscription_id" ;
} 
