Class User.OAUTH2.Yandex1N Extends %CSP.Page
{

Parameter APPNAME = "Yandex";

Parameter SSLNAME = "GOOGLE";

Parameter REDIRECTURI = "http://localhost:57772/csp/user/User.OAUTH2.Yandex2N.cls";

ClassMethod OnPage() As %Status
{
	&html<
		<html>
			<head>
			</head>
			
			<body style="text-align: center;">

				<!-- insert the page content here -->
				<h1>Facebook OAuth2 API</h1>
			>
	set scope = "login:birthday login:email login:info login:avatar"
				
	set url=##class(%SYS.OAuth2.Authorization).GetAuthorizationCodeEndpoint(..#APPNAME,, 
					..#REDIRECTURI,.properties,.isAuthorized,.sc)
	w !,"<p><a href='"_url_"'><img border='0' alt='Facebook Sign In' ></a>"
				
	&html<		</body>
		</html>
	>;

	return $$$OK
}

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
  #dim %response as %CSP.Response
  
  set scope = "account-info"
  
  if ##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#APPNAME,,,.accessToken,.idtoken,.responseProperties,.error) {
    set %response.ServerSideRedirect="User.OAUTH2.Yandex2N.cls"
  }
  
  quit 1
}

}
