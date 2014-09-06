(function(){
  var attempts = 0;
  var required_perms = ['public_profile', 'email', 'user_groups',
    'read_stream'];

  var check_login = function(scope) {
    console.log('Yes checking login');
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
    console.log('status is ', response.status);
    if (response.status == 'connected') {
      var uid = response.authResponse.userID;
      var accessToken = response.authResponse.accessToken;
      get_missing_permissions(rerequest_permissions);
    } else if (response.status = 'not_authorized') {
      console.log('App has not been authorized');
      //window.location('https://www.facebook.com/login');
      //FB.login();
    }
  };

  var get_youtube_id = function(link) {
    if (link) {
      var match = link.match(/v(.+)?\/(.+)\?/);
      if (match) {
        var video_id = match[match.length - 1];
        console.log('Video ID is ', video_id);
        return video_id;
      }
    } 
    console.log('Here is the link ', link);
    return undefined;
  };

  var get_youtube_link = function(feed) {
    //console.log('working on ', feed)
    if (feed && feed.type == 'status' && feed.message) {
      var match = feed.message.match(/http.+(youtube|you).+(com)?[^\s]+/);
      if (match) {
        return match[0];
      }
    }else if (feed && feed.type == 'video' && feed.source) {
      return feed.source;
    }
    return undefined;
  };

  var get_group_links = function(gid) {
    CGanam.Events.trigger('get_links', {groud_id: gid});
    FB.api('/' + gid + '/feed', function(response) {
      var video_ids = [];
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
        CGanam.Events.trigger('load_videos', video_ids);
      } else {
        console.log('No video IDs detected');
      }
    });
  };

  var get_song_group = function() {
    FB.api('/me/groups', function(response) {
      if (response && !response.error) {
        console.log(response);
        for (var j=0; j<response.data.length; j++) {
          var group = response.data[j];
          if (group.name == 'Malayalam Songs') {
            get_group_links(group.id);
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
})();
