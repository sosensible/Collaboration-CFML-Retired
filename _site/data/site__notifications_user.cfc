component persistent="true" table="site__notifications_user"  output="false" extends="share.objects.appestry.orm"
{
	property name="siteNotificationUser_id" column="siteNotificationUser_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="siteNotification_id" column="siteNotification_id" type="numeric" ormtype="int" ;
	property name="user_id" column="user_id" type="numeric" ormtype="int" ;
	property name="created_on" column="created_on" type="date" ormtype="timestamp" ;
	property name="updated_on" column="updated_on" type="date" ormtype="timestamp" ;
		
	public void function preInsert(){
		var myNow = CreateODBCDateTime(now());
		
		setcreated_on(myNow);
		setupdated_on(myNow);
	}
	
	public void function preUpdate(){
		var myNow = CreateODBCDateTime(now());
		
		setupdated_on(myNow);;
	}
}