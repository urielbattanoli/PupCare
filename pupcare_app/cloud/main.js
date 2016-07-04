
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("getPetshopList", function(request, response) {
  Parse.Cloud.useMasterKey();

  query = new Parse.Query("PetShop");

  query.find({
      success: function(results) {
        Console.log(results.length)
        response.success(results);
      },
      error: function() {
        response.error("PetShop lookup failed");
      }
  });
});
