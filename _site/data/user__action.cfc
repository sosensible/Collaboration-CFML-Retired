component persistent="true" table="user__action"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="action_id" column="action_id" type="numeric" ormtype="long" fieldtype="id" generated="insert" generator="native" ; 
	property name="action_main" column="action_main" type="string" ormtype="string" ; 
	property name="detail" column="detail" type="string" ormtype="string" ; 
	property name="link" column="link" type="string" ormtype="string" ; 
	property name="user_id" column="user_id" type="numeric" ormtype="int" ; 
	property name="dated" column="dated" type="date" ormtype="timestamp" ; 	
} 
