Class User.OAUTH2.Yandex2N Extends %CSP.Page
{

Parameter APPNAME = "Yandex";

ClassMethod OnPage() As %Status
{
 set scope = "login:birthday login:email login:info login:avatar"

	w ##class(%SYS.OAuth2.AccessToken).GetAccessToken(..#APPNAME,,,.accessToken,.idtoken,.responseProperties,.error)
	//set isAuthorized=##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#APPNAME,,,.accessToken,.idtoken,.responseProperties,.error)
	//w "Auth: ", isAuthorized, !
	  set isAuthorized=##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#APPNAME,,scope,.accessToken,.idtoken,.responseProperties,.error)
  if isAuthorized {
	  w isAuthorized
    // Google has no introspection endpoint - nothing to call - the introspection endpoint and display result -- see RFC 7662.
    w "<h3>Data from <span style='color:red;'>GetUserInfo API</span></h3>"
    // userinfo has special API, but could be also retrieved by just calling Get() method with appropriate url  
    try {
      set tHttpRequest=##class(%Net.HttpRequest).%New()
      $$$THROWONERROR(sc,##class(%SYS.OAuth2.AccessToken).AddAccessToken(tHttpRequest,"query","OAuth",..#APPNAME))
      do tHttpRequest.SetParam("oauth_token",tHttpRequest.GetParam("access_token"))
      $$$THROWONERROR(sc,tHttpRequest.Get("https://login.yandex.ru/info"))
      set tHttpResponse = tHttpRequest.HttpResponse

      s tJSONString=tHttpResponse.Data
      do ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(tJSONString,,.data,1)
      zw data
      set ^FName = data."first_name"
		w data."first_name",!
		w data."last_name",!
		w data."real_name",!
		w data."name",!
		w data."display_name",!
		w data."default_email",!
		w data."birthday",!
      //w jsonObject.%ToJSON()
      
    } catch (e) {
      w "<h3><span style='color: red;'>ERROR: ",$zcvt(e.DisplayString(),"O","HTML")_"</span></h3>"  
    }

    /******************************************
    *                                         *
    *      Retrieve info from other APIs      *
    *                                         *
    ******************************************/
  } else {
    w "<h1>Not authorized!</h1>"
  }

	return $$$OK
}

}
