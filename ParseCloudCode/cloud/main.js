
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
  request.object.set("radius", 3.5); //Should come from config
  response.success();
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
