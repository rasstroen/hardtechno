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
	// chat refresh interval in seconds
	refreshSpeed: 0.8,
	// variables
	// 
	// element on page for draw chat
	divElement:false,
	// element fo logging
	logElement:false,
	// secret for authorization
	authCookie:'', 
	// user's id
	authId:'', 
	// user's profile
	profile:{},
	// initializing
	init : function(id){
		chat.divElement = document.getElementById(id);
		chat.authCookie = chat.getCookie(chat.authCookieName);
		chat.authId = chat.getCookie(chat.authCookieIdName);
		chat.authorize();
	},
	log: function(s){
		if(!chat.logDiv)	{
			chat.logDiv = document.createElement('DIV');
			chat.logDiv.id = 'chat_log';
			chat.divElement.appendChild(chat.logDiv);
		}
		chat.logDiv.innerHTML += "\n<br>"+s;
	},
	// authorize user via server
	authorize : function(){
		data = {};
		data.action = 'authorize';
		data.jquery = 'chat_module';
		data.id = chat.authId;
		data.secret = chat.authCookie;
		chat.request(data, chat.on_authorize);
	},
	set_authorized : function (is_authorized){
		if(is_authorized)	{
			chat.log('authorized as '+chat.profile.nick);
		}else{
			chat.log('unauthorized');
		}
	},
	on_authorize : function(data){
		if(data && data.success){
			// authorized, so we can wrote
			chat.profile = data.profile;
			chat.set_authorized(true);
		}else
			chat.set_authorized(false);
		chat.start_timer();
	},
	start_timer : function(){
		setInterval('chat.on_timer()',chat.refreshSpeed*1000);
	},
	on_timer: function(){
		var d = new Date();
		chat.log(d.getTime()/1000);
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
		$.post(chat.server_url, data, function(data){
			callback(data);
		}, "json"
		);
	}
}
