component persistent="true" table="site__notifications"  output="false" extends="share.objects.appestry.orm"
{
	property name="siteNotification_id" column="siteNotification_id" type="numeric" ormtype="int" fieldtype="id" generated="insert" generator="native" ; 
	property name="title" column="title" type="string";
    property name="body" column="body" type="string";
	property name="publishStartDate" column="publishStartDate" type="date" ormtype="timestamp" ;
	property name="publishEndDate" column="publishEndDate" type="date" ormtype="timestamp" ;
	property name="oneTimeNotice" column="oneTimeNotice" type="numeric" ormtype="byte" ;
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