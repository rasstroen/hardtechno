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
        refreshSpeed: 1.8,
        // translates
        translate_say : 'написать',
        // variables
        //
        // can i write?
        can_write : false,
        // chat status
        status : 1,
        // statuses
        status_wait : 1, // do nothing
        status_request_sended_fetch : 2, // sent request fo fetch new data
        status_request_sended_message : 3, // sent message
        // last message user see now
        last_message_received_id : 0,
        // last message timestamp
        last_message_received_time : 0,
        // messages
        messages : {},
        // element on page for draw chat
        divElement:false,
        // element on page for draw message before it
        last_message_div:false,
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
                chat.last_message_div = document.createElement('div');
                chat.divElement.appendChild(chat.last_message_div);
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
                data.id = chat.authId;
                data.secret = chat.authCookie;
                chat.request(data, chat.on_authorize);
        },
        drawInput : function(){
                var _input = document.createElement('input');
                _input.type = 'text';
                _input.id = 'chat_input';
                chat.divElement.appendChild(_input);

                var _button = document.createElement('input');
                _button.type = 'button';
                _button.value = chat.translate_say;
                _button.onclick = function(){
                        chat.send();
                }
                chat.divElement.appendChild(_button);
        },
        set_authorized : function (is_authorized){
                if(is_authorized)	{
                        chat.log('authorized as '+chat.profile.nick);
                        chat.can_write = 1;
                        chat.drawInput();
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
                chat.on_timer();
                setInterval('chat.on_timer()',chat.refreshSpeed*1000);
        },
        on_timer: function(){
                // if it's no pending get requests
                // put new request
                if(chat.status == chat.status_wait){
                        // we can sent request to fetch data
                        chat.get();
                }
        },
        send : function(){
                chat.status = chat.status_request_sended_message;
                var data = {};
                data.action = 'say';
                data.message = document.getElementById('chat_input').value;
                // message not empty & we are authorized to write
                if(data.message && chat.can_write){
                        chat.request(data, chat.on_after_send);
                }
        },
        // request for get messages
        get : function(){
                var data = {};
                data.action = 'fetch';
                data.last_message_received_id = chat.last_message_received_id;
                data.last_message_received_time = chat.last_message_received_time;
                chat.status = chat.status_request_sended_fetch;
                chat.request(data, chat.on_after_get);
        },
        on_after_get : function(data){
                if(data && data['success']){
                        if(data.messages){
                                for(var i in data.messages){
                                        if(!chat.messages[data.messages[i].id]){
                                                // new message
                                                chat.messages[data.messages[i].id] = data.messages[i];
                                                chat.draw_message(data.messages[i]);
                                                chat.last_message_received_id = Math.max(chat.last_message_received_id, data.messages[i].id)
                                                chat.last_message_received_time = Math.max(chat.last_message_received_time, data.messages[i].time)
                                        }
                                }
                        }
                }
                chat.status = chat.status_wait;
        },
        // after send request to server
        on_after_send : function(data){
                chat.status = chat.status_wait;
                chat.last_message_received_id = data.last_message_id;
                chat.on_after_get(data);
        },
        // inserting message div by message object into chat window
        draw_message : function(message){
                var message_plank = document.createElement('div');
                message_plank.id = 'message_'+message.id;
                message_plank.name = 'chat_message';
                message_plank.innerHTML = message.message;
                // find place
                chat.divElement.appendChild(message_plank);
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
                data.jquery = 'chat_module';

                var request = $.ajax({
                        cache: false,
                        url: chat.server_url,
                        type: "POST",
                        data: data,
                        timeout: 10000,
                        dataType: "json",
                        global: false
                });

                request.done(function(data){
                        // request done
                        callback(data);
                });
                request.fail(function(o , status){
                        // something went wrong
                        chat.log(status);
                        // we will try another time
                        chat.status = chat.status_wait;
                });
        }
}