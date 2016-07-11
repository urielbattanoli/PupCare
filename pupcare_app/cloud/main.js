
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("getPetshopList", function(request, response) {
  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("PetShop");

  var geoPoint = request.params.currentLocation;

  query.near("centerPoint", geoPoint);
  query.limit(20);
  query.find({
      success: function(results) {
        var distances = [];
        for (var i = 0; i < results.length; ++i){
          distances.push(results[i].kilometersTo(geoPoint));
        }
        response.success(distances);
      },
      error: function() {
        response.error("PetShop lookup failed");
      }
  });
});
