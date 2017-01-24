component persistent="true" table="site__logVisit"  output="false" extends="share.objects.appestry.orm"
{
	/* properties */
	
	property name="siteVisit_id" column="siteVisit_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="visit_guid" column="visit_guid" type="string" ormtype="string" default="default" ; 
	property name="startTime" column="startTime" type="date" ormtype="timestamp" default="" ; 
	property name="endTime" column="endTime" type="date" ormtype="timestamp" default="" ; 
	property name="remote_host" column="remote_host" type="string" ormtype="string" default="build" ; 
	property name="user_id" column="user_id" type="numeric"; 
	property name="lastHit" column="lastHit" type="date" ormtype="timestamp" ; 
	property name="pageRequestCount" column="pageRequestCount" type="numeric"; 
	property name="activeSessions" column="activeSessions" type="numeric"; 
}