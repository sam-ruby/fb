(function(){
  var attempts = 0;
  var required_perms = ['public_profile', 'email', 'user_groups',
    'read_stream'];

  var check_login = function(scope) {
    if (!scope) {
      FB.getLoginStatus(login_handler);
    } else {
      FB.getLoginStatus(login_handler,
        {scope: scope, auth_type: 'rerequest'});
    }
  };

  var rerequest_permissions = function(miss_perms) {
    if (miss_perms.length > 0 && attempts < 2) {
      attempts++;
      var scope = miss_perms.join(',');
      console.log('asking for ', scope);
      check_login(scope);
    } else {
      CGanam.Events.trigger('get_song_group');
    }
  };

  var login_handler = function(response) {
    if (response.status == 'connected') {
      var uid = response.authResponse.userID;
      var accessToken = response.authResponse.accessToken;
      get_missing_permissions(rerequest_permissions);
      $('.fb-login-box').hide();
    } else if (response.status = 'not_authorized') {
      console.log('App has not been authorized');
      //window.location('https://www.facebook.com/login');
      //FB.login();
      $('.fb-login-box').show();
    }
  };

  var get_youtube_id = function(link) {
    var video_id;
    if (link) {
      if (link.indexOf('v=') >= 0) {
        video_id = link.split("v=")[1].substring(0, 11);
      } else if (link.indexOf('v/') >= 0) {
        video_id = link.split("v/")[1].substring(0, 11);
      }
      /*
      var match = link.match(/v(.+)?\/(.+)\?/);
      var match = link.match(/http.+v[\/=](.+)[\s&\?]?/);
      if (match) {
        var video_id = match[1];
        console.log('Video ID is ', video_id);
        return video_id;
      }
      */
    } 
    console.log('Here is the link ', link, video_id);
    return video_id;
  };

  var get_youtube_link = function(feed) {
    if (feed && feed.type == 'status' && feed.message) {
      console.log('Status is ', feed.message);
      var match = feed.message.match(/http.+(youtube|you).+(com)?[^\s]+/);
      if (match) {
        console.log('Returning ', match[0]);
        return match[0];
      }
    }else if (feed && feed.type == 'video' && feed.source) {
      console.log('Returning video ', feed.source);
      return feed.source;
    }
    return undefined;
  };

  var get_group_links = function(gid, tokens) {
    FB.api('/' + gid + '/feed', tokens, function(response) {
      console.log('Here is the response ', response);
      var video_ids = [];
      if (response.paging && response.paging.next) {
        var time_token = response.paging.next.split('until=')[1].split('&')[0];
        var paging_token = response.paging.next.split(
          '__paging_token=')[1].split('&')[0];
        CGanam.Events.trigger('feed-pagination-marker', gid,
          {until: time_token,
           '_paging_token': paging_token,
           limit: 50});
      }

      if (response && response.data && response.data.length > 0) {
        //CGanam.Events.trigger('load-songs', response.data)
        for (var j = 0; j<response.data.length; j++) {
          var video_id = get_youtube_id(get_youtube_link(response.data[j]));
          if (video_id) {
            video_ids.push(video_id);
          }
        }
      }
      if (video_ids.length ) {
        CGanam.Events.trigger('get-video-details', video_ids);
      } else {
        console.log('No video IDs detected');
      }
    });
  };

  var get_song_group = function() {
    FB.api('/me/groups', function(response) {
      if (response && !response.error) {
        for (var j=0; j<response.data.length; j++) {
          var group = response.data[j];
          if (group.name == 'Malayalam Songs') {
            get_group_links(group.id, {limit: 50});
            break;
          }
        }
      } else {
        console.log(response.error);
      }
    });
  };

  var get_missing_permissions = function (callback) {
    var missing_perms = [], current_perms = [];
    FB.api('/me/permissions', function(response) {
      console.log('Here are the permissions', response);
      if (response && response.data && response.data.length > 0) {
        for (var j=0; j < response.data.length; j++) {
          var perms = response.data[j];
          current_perms.push(perms.permission);
          if (required_perms.indexOf(perms.permission) >= 0 && 
              perms.status == 'declined') {
            missing_perms.push(perms.permission);
          } else if (required_perms.indexOf(perms.permission) < 0) {
            missing_perms.push(perms.permission);
          }
        }
      }
      for (var j=0; j < required_perms.length; j++) {
        if (current_perms.indexOf(required_perms[j]) < 0 ) {
          missing_perms.push(required_perms[j]);
        }
      }
      callback(missing_perms);
    });
  };
  
  //CGanam.Events.listenTo('yt_ready', get_song_group);
  CGanam.Group = _.extend({get_song_group: get_song_group},
    Backbone.Events);
  CGanam.Auth = {check_login: check_login};
  CGanam.Events.trigger('fb_ready');
  CGanam.Group.listenTo(
      CGanam.Events, 'get_song_group', get_song_group);
  CGanam.Group.listenTo(
      CGanam.Events, 'get-next-set-feed', get_group_links);
})();
