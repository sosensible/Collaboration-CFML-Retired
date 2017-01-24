component persistent="true" table="site__slowRequests"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="slowRequest_id" column="slowRequest_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="dbSessionID" column="dbSessionID" type="string" ormtype="string" default="default" ; 
	property name="target" column="target" type="string" ormtype="string" default="" ; 
	property name="pageType" column="pageType" type="string" ormtype="string" default="" ; 
	property name="tickCount" column="tickCount" type="numeric"; 
	property name="hitCount" column="hitCount" type="numeric"; 
	property name="created_on" column="created_on" type="date" ormtype="timestamp" ; 
	property name="updated_on" column="updated_on" type="date" ormtype="timestamp" ; 
}