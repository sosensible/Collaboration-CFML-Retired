component persistent="true" table="site__useractivity"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="useractivity_id" column="useractivity_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="useractivity_main" column="useractivity_main" type="string" ormtype="string" ;
	property name="user_id" column="user_id" type="numeric" ormtype="int" insert="false" update="false"  ; 
	property name="dated" column="dated" type="date" ormtype="timestamp" ;
	property name="link" column="link" type="string" ormtype="string" ;
	property name="bundle" column="bundle" type="string" ormtype="string" ;
		
	property name="member" type="array" fieldtype="one-to-one"
		cfc="site__user" fkcolumn="user_id" lazy="true";
} 
