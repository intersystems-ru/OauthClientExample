Class OAuth2.App {

Parameter APPNAME;

Parameter REDIRECTURI;

Parameter SSLNAME = "OAuth2";

ClassMethod GetURL(scope As %String = "") As %String
 {
 	set url = ##class(%SYS.OAuth2.Authorization).GetAuthorizationCodeEndpoint(..#APPNAME,scope,..#REDIRECTURI,.properties,.isAuthorized,.sc)
 	return url
 }
 
 ClassMethod GetInfo() As %DynamicObject
 {
 
 }

}