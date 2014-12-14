
Parse.Cloud.beforeSave("ChatRoom", function(request, response) {
  var ChatRoom = request.object;
  var expirationDate = new Date();
  expirationDate.setDate(expirationDate.getDate() + 1); //Should come from config
  request.object.set("expiresAt", expirationDate);
  request.object.set("active", true);
  request.object.set("radius", 3.5); //Should come from config
  response.success();
});

