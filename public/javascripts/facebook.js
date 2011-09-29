var loading_image = "<div class='ajax-loading'><img src='/images/loading.gif'/></div>";

$(function(){
  var fb_app_id = $('#fb_app_id').val();
  var fb_page_id = $('#fb_page_id').val();
  //initialize fb
  FB.init({
    appId: fb_app_id,
    status: true,
    cookie: true,
    xfbml: true
  });
  //set fb canvas to autoresize
  FB.Canvas.setAutoResize();
});

//function to authenticate fb user
function authenticate_user()
{
  var fb_app_id = $('#fb_app_id').val();
  var fb_page_id = $('#fb_page_id').val();
  FB.getLoginStatus(function(response){
    if (response.session){
    } else {
      var redirect_uri = "http://www.facebook.com/pages/" + fb_page_id + "/" + fb_page_id + "?sk=app_" + fb_app_id;
      oauth_url = 'http://www.facebook.com/dialog/oauth?display=page&client_id=' + fb_app_id + '&redirect_uri=' + encodeURIComponent(redirect_uri);
      top.location.href = oauth_url;
    }
  });
}

/***********************************************************
function to request for specific page
***********************************************************/
function link_to_page(page_request, parameter, replace_tag)
{
  //setup location
  if ( replace_tag == null ) replace_tag = "moluko_content";
  var content = $('#' + replace_tag);

  // setup across url parameter
  parameter['fb_page_admin'] = $('#fb_page_admin').val();
  parameter['fb_page_liked'] = $('#fb_page_liked').val();
  parameter['current_category_id'] = $('#current_category_id').val();
  parameter['current_product_id'] = $('#current_product_id').val();
  parameter['current_categories_page'] = $('#current_categories_page').val();
  parameter['current_products_page'] = $('#current_products_page').val();
  parameter['page_request'] = page_request;
  parameter['replace_tag'] = replace_tag;

  //call ajax
  content.html(loading_image);
  $.ajax({
    type: 'GET',
    url: $('#fb_page_id').val(),
    data: parameter,
    dataType: 'script',
    error: function(jqXHR, textStatus, errorThrown){
      content.html('.. please try again ..');
    }
  });
}

/***********************************************************
function to show fb user cart
***********************************************************/
function show_cart()
{
  var content = $('#moluko_cart');

  // setup across url parameter
  var parameter={};
  parameter['fb_user_id'] = $('#fb_user_id').val();
  parameter['fb_page_liked'] = $('#fb_page_liked').val();
  parameter['fb_page_admin'] = $('#fb_page_admin').val();

  //call ajax
  content.html(loading_image);
  $.ajax({
    type: 'GET',
    url: $('#fb_page_id').val() + '/show_cart',
    data: parameter,
    dataType: 'script',
    error: function(jqXHR, textStatus, errorThrown){
      content.html('.. please try again ..');
    }
  });
}

/***********************************************************
function to show add to cart dialog
***********************************************************/
function show_add_to_cart_dialog(product_id)
{
  var content = $('#dialog_container');

  // setup across url parameter
  var parameter={};
  parameter['product_id'] = product_id;
  parameter['fb_user_id'] = $('#fb_user_id').val();
  parameter['fb_page_liked'] = $('#fb_page_liked').val();
  parameter['fb_page_admin'] = $('#fb_page_admin').val();

  //create dialog
  content.dialog({
    title: 'Add To Cart',
    height: 300,
    width: 480,
    resizable: false,
    modal: true,
    position: 'top'
  });

  //call ajax
  content.html(loading_image);
  $.ajax({
    type: 'GET',
    url: $('#fb_page_id').val() + '/show_add_to_cart_dialog',
    data: parameter,
    dataType: 'script',
    error: function(jqXHR, textStatus, errorThrown){
      content.html('.. please try again ..');
    }
  });
}
/***********************************************************
function to add product to cart
***********************************************************/
function add_to_cart(product_id, quantity)
{
  var content = $('#moluko_cart');

  $('#dialog_container').dialog('destroy');

  // setup across url parameter
  var parameter={};
  parameter['product_id'] = product_id;
  parameter['quantity'] = quantity;
  parameter['fb_user_id'] = $('#fb_user_id').val();
  parameter['fb_page_liked'] = $('#fb_page_liked').val();
  parameter['fb_page_admin'] = $('#fb_page_admin').val();

  content.html(loading_image);
  $.ajax({
    type: 'GET',
    url: $('#fb_page_id').val() + '/add_to_cart',
    data: parameter,
    dataType: 'script',
    error: function(jqXHR, textStatus, errorThrown){
      content.html('.. please try again ..');
    }
  });
}
/***********************************************************
function to hide or show cart
***********************************************************/
function toggle_cart(show_text, hide_text)
{
  var content = $('#cart_content');
  var link = $('#toggle_cart');
  if (content.css('display') == 'none')
  { content.show(); link.html(hide_text); }
  else { content.hide(); link.html(show_text); }
}
/***********************************************************
function to delete cart item
***********************************************************/
function delete_cart_item(product_id)
{
  var content = $('#moluko_cart');

  // setup across url parameter
  var parameter={};
  parameter['product_id'] = product_id;
  parameter['fb_user_id'] = $('#fb_user_id').val();
  parameter['fb_page_liked'] = $('#fb_page_liked').val();
  parameter['fb_page_admin'] = $('#fb_page_admin').val();

  content.html(loading_image);

  $.ajax({
    type: 'GET',
    url: $('#fb_page_id').val() + '/delete_cart_item',
    data: parameter,
    dataType: 'script',
    error: function(jqXHR, textStatus, errorThrown){
      content.html('.. please try again ..');
    }
  });
}
/***********************************************************
function to add product to cart
***********************************************************/
function show_calculate_shipping_dialog()
{
  var content = $('#dialog_container');

  // setup across url parameter
  var parameter={};
  parameter['fb_user_id'] = $('#fb_user_id').val();
  parameter['fb_page_liked'] = $('#fb_page_liked').val();
  parameter['fb_page_admin'] = $('#fb_page_admin').val();

  //create dialog
  content.dialog({
    title: 'Calculate Shipping Fee!',
    height: 380,
    width: 480,
    resizable: false,
    modal: true,
    position: 'top'
  });

  //call ajax
  content.html(loading_image);
  $.ajax({
    type: 'GET',
    url: $('#fb_page_id').val() + '/show_calculate_shipping_dialog',
    data: parameter,
    dataType: 'script',
    error: function(jqXHR, textStatus, errorThrown){
      content.html('.. please try again ..');
    }
  });
}
/***********************************************************
function to add product to cart
***********************************************************/
function calculate_shipping(country, region, zipcode, delivery_type)
{
  var content = $('#shipping_result');

  // setup across url parameter
  var parameter={};
  parameter['fb_user_id'] = $('#fb_user_id').val();
  parameter['fb_page_liked'] = $('#fb_page_liked').val();
  parameter['fb_page_admin'] = $('#fb_page_admin').val();
  parameter['country'] = country;
  parameter['region'] = region;
  parameter['zipcode'] = zipcode;
  parameter['delivery_type'] = delivery_type;

  //call ajax
  content.html(loading_image);
  $.ajax({
    type: 'GET',
    url: $('#fb_page_id').val() + '/calculate_shipping',
    data: parameter,
    dataType: 'script',
    error: function(jqXHR, textStatus, errorThrown){
      content.html('.. please try again ..');
    }
  });

}
