Parse.Cloud.define("getProductList", function(request, response) {
  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("PetShop_Product");
  query.sort("name");
  query.equalTo("petShopId", request.params.petShopId)
  query.find({
      success: function(results) {
        Console.log(results.length)
        response.success(results);
      },
      error: function() {
        response.error("Product lookup failed");
      }
  });
});

Parse.Cloud.define("getProductWithFilter", function(request, response){
  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("PetShop_Product");

  query.find({
    success: function(results){
      response.success(results);
    },
    error: function(){
      response.error("Product lookup failed");
    }
  });
});