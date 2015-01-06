
Parse.Cloud.beforeSave("ChatRoom", function(request, response) {
  var expirationDate = request.object.get("expiresAt");
  if (!expirationDate) {
    expirationDate = new Date();
    expirationDate.setDate(expirationDate.getDate() + 1); //Should come from config
    request.object.set("expiresAt", expirationDate);
  }
  var active = request.object.get("active");
  if (active === undefined || active === null) {
    request.object.set("active", true);
  }
  var radius = request.object.get("radius");
  if (!radius) {
    request.object.set("radius", 3.5); //Should come from config
  }
  response.success();
});

Parse.Cloud.afterSave("ChatRoom", function(request, response) {
  var userRelationQuery = request.object.relation("users").query();
  userRelationQuery.count({
    success: function(value) {
      var currentUserCount = request.object.get("userCount");
      if (value != currentUserCount) {
        console.log(request.object.id + " has " + value + " users");
        request.object.set("userCount", value);
        request.object.save();
      }
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterSave("Chat", function(request) {
  var query = new Parse.Query("ChatRoom");
  query.get(request.object.get("room").id, {
    success: function(room) {
      var user = request.user;
      var alertText = "#" + room.get("Name")  + " @" + user.get("username") + ": " + request.object.get("text");

      var pushQuery = new Parse.Query(Parse.Installation);
      pushQuery.notEqualTo("user", user);
      pushQuery.equalTo("channels", "A" + room.id);

      Parse.Push.send({
        where: pushQuery,
        data: {
          alert: alertText,
          badge: 0,
          sound: "Toast.wav",
          title: "Near message",
          room:  room.id
        }
      }, {
        success: function() {
          console.log("Sent '" + alertText + "' to channel A" + room.id);
        },
        error: function(error) {
          console.error("Got an error " + error.code + " : " + error.message);
        }
      });
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.job("updateActiveChatRooms", function(request, status) {
  Parse.Cloud.useMasterKey();
  var query = new Parse.Query("ChatRoom");
  query.equalTo("active", true);
  query.lessThan("expiresAt", new Date());
  query.each(function(room) {
    room.set("active", false);
    return room.save();
  }).then(function() {
    status.success("Updated active rooms");
  }, function(error){
    status.error("Error while updating active rooms. " + error);
  });
});

Parse.Cloud.define("findAvailableChatRooms", function(request, response) {
  var geoPoint = request.params.geoPoint;
  var query = new Parse.Query("ChatRoom");
  query.equalTo("active", true);
  query.withinKilometers("centerPoint", geoPoint, 100);
  query.find({
    success: function(results) {
      response.success(results);
    },
    error: function(error) {
      response.error("Error");
    }
  });
});

Parse.Cloud.define("reportUser", function(request, response) {
  console.log("Attempting to report User");
  var query = new Parse.Query(Parse.User);
  query.equalTo("objectId", request.params.reportedUserId);
  query.find({
      success: function() {
        // Do stuff to disable
        response.success(true);
      },
      error: function(error) {
        response.error("Error");
      }
  });
});
