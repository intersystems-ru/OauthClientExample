Class User.OAUTH2.Facebook2N Extends %CSP.Page
{

Parameter APPNAME = "Facebook";

Parameter ROOT = "api.vk.com";

ClassMethod OnPage() As %Status
{
	set scope = "email"

	set isAuthorized=##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#APPNAME,,scope,.accessToken,.idtoken,.responseProperties,.error)
	if isAuthorized {
		set tHttpRequest=##class(%Net.HttpRequest).%New()
		$$$THROWONERROR(sc,##class(%SYS.OAuth2.AccessToken).AddAccessToken(tHttpRequest,"query",##class(OAuth2.App).#SSLNAME, ##class(OAuth2.FacebookApp).#APPNAME))
		do tHttpRequest.SetParam("oauth_token", tHttpRequest.GetParam("access_token"))
		$$$THROWONERROR(sc,tHttpRequest.Get("https://graph.facebook.com/v2.10?ids=platform,me"))
		set tHttpResponse=tHttpRequest.HttpResponse
    	s tJSONString=tHttpResponse.Data.Read()
    	w !, tJSONString
	}
	return $$$OK
}

}
