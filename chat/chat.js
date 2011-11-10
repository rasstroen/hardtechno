var chat = {
	//
	// settings
	// 
	// where is server
	server_url:'/',
	// cookie name with auth hash
	authCookieName:'thardhash_',
	// cookie name with user id
	authCookieIdName:'thardid_',
	//
	// variables
	// 
	// element on page for draw chat
	divElement:'',
	// secret for authorization
	authCookie:'', 
	// user's id
	authId:'', 
	// initializing
	init : function(id){
		this.divElement = document.getElementById(id);
		this.authCookie = this.getCookie(this.authCookieName);
		this.authId = this.getCookie(this.authCookieIdName);
		this.authorize();
	},
	// authorize user via server
	authorize : function(){
		data = {};
		data.action = 'authorize';
		data.id = this.authId;
		data.secret = this.authCookie;
		this.request(data, this.on_authorize);
	},
	on_authorize : function(data){
		
	},
	timer : function(){
		
	},
	send : function(){
		
	},
	get : function(){
		
	},
	on_after_get : function(){
		
	},
	// after send request to server
	on_after_send : function(){
		
	},
	// getting browser's Cookie
	getCookie : function (c_name){
		var i,x,y,ARRcookies=document.cookie.split(";");
		for (i=0 ; i<ARRcookies.length; i++){
			x = ARRcookies[i].substr(0 , ARRcookies[i].indexOf("="));
			y = ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
			x = x.replace(/^\s+|\s+$/g , "");
			if (x == c_name)
				return unescape(y);
		}
		return false;
	},
	// making request
	request : function(data , callback){
		callback = callback ? callback : function(data){};
		$.post(this.server_url, data, function(data){
			callback(data);
		}
		);
	}
}
