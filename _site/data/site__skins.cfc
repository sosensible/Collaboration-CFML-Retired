component persistent="true" table="site__skin"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	property name="skin_id" column="skin_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="skin_main" column="skin_main" type="string" ormtype="string" ;  
	property name="thumb" column="thumb" type="string" ormtype="string" ; 
		
} 
