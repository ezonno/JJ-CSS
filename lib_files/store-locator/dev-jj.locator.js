var brandName;
var countryName;
var geocoder;
var map;
var markers = [];
var cityMarkers = [];
var windows;
var infoBox;
var stores = [];
var bounds;
var country_iso2 = ["FR", "PT", "ES", "RS", "BE", "LU", "SY", "IS", "NO", "NL", "SE", "FI", "AT", "CH", "DE", "AD", "IT", "EE", "HR", "GB", "PL", "CZ", "SA", "BH", "IE", "DK", "SI"];
var country_iso3 = ["FRA", "PRT", "ESP", "SRB", "BEL", "LUX", "SYR", "ISL", "NOR", "NLD", "SWE", "FIN", "AUT", "CHE", "DEU", "AND", "ITA", "EST", "HRV", "GBR", "POL", "CZE", "SAU", "BHR", "IRL", "DNK", "SVN"];
var country_dmw = ["SL", "ON"];
var country_osd = ["SEL", "ON"];
var markerImage = "";
var markerImageSelected = "";
var pipeline = "";
var showStoreTypes = 2;
var brandedStoreType = new Array("CHAIN_STOREFRONT"); //CHAIN_STOREFRONT, SHOP_IN_SHOP, SHOP_IN_SHOP_BS_OPERATED, NON_BESTSELLER_CHAIN, INDEPENDENT_STAND_ALONE

//Map styling
var styles = [
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      { "color": "#d4dade" }
    ]
  },{
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      { "color": "#dbdee4" }
    ]
  },{
    "featureType": "landscape",
    "elementType": "geometry",
    "stylers": [
      { "color": "#f4f4f4" }
    ]
  },{
    "featureType": "road.arterial",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#cdcdcd" }
    ]
  },{
    "featureType": "road.arterial",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#c3c3c3" }
    ]
  },{
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      { "visibility": "on" },
      { "color": "#000000" }
    ]
  },{
    "featureType": "road.arterial",
    "elementType": "labels.text.stroke",
    "stylers": [
      { "color": "#ffffff" },
      { "weight": 2 }
    ]
  },{
    "featureType": "road.highway",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#cdcdcd" }
    ]
  },{
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#c3c3c3" }
    ]
  },{
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#000000" }
    ]
  },{
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [
      { "color": "#ffffff" },
      { "weight": 2 }
    ]
  },{
    "featureType": "road.highway",
    "elementType": "labels.icon",
    "stylers": [
      { "saturation": -100 },
      { "lightness": 30 }
    ]
  },{
    "featureType": "poi.park",
    "elementType": "labels.icon",
    "stylers": [
      { "saturation": -100 },
      { "lightness": 20 }
    ]
  },{
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#808080" }
    ]
  },{
    "featureType": "poi.attraction",
    "stylers": [
      { "saturation": -100 }
    ]
  },{
    "featureType": "transit",
    "stylers": [
      { "saturation": -100 }
    ]
  },{
    "featureType": "road",
    "elementType": "labels",
    "stylers": [
      { "saturation": -100 },
      { "lightness": 25 }
    ]
  }
];

function createMap() {
    var options = {
        zoom: 5,
        panControl: false,
        zoomControl: true,
        zoomControlOptions: {
            style: google.maps.ZoomControlStyle.LARGE,
            position: google.maps.ControlPosition.LEFT_CENTER
        },
        mapTypeId: google.maps.MapTypeId.ROADMAP, styles: styles
    };
    map = new google.maps.Map(document.getElementById("map"), options);
}

function convertCountryCode(country){
    country = country.toUpperCase();
    if(country.length === 2){
        for (key in country_iso2){
            if(country_iso2[key] == country){
                return country_iso3[key];
            }
        }
    } else if(country.length === 3){
        for (key in country_iso3){
            if(country_iso3[key] == country){
                return country_iso2[key];
            }
        }
    } else {
        country
    }
}

function filterStoreType(stores, storeType){
    var storeTypeLink = storeType || "RETAIL"; 
    var filteredStores = [];
    for(var store in stores){
        if(stores[store].storeTypeLink !== undefined && stores[store].storeTypeLink.indexOf(storeTypeLink) > -1){
            filteredStores.push(stores[store]);
        }
    }
    return filteredStores;
}

function isStoreType(store, storeTypeLink){
    if(store.storeTypeLink !== undefined && store.storeTypeLink.indexOf(storeTypeLink) > -1){
    return true;
    } else {
    return false;
    }
}



/*-----------------------------------------------------------------------------------
    Geocode functions
-----------------------------------------------------------------------------------*/
function centerMapOnCountry(country) {
    country = convertCountryCode(country);
    geocoder.geocode({ 'address': country, 'region': country }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            map.setCenter(results[0].geometry.location);
            map.fitBounds(results[0].geometry.bounds);
        }
    });
}

/*-----------------------------------------------------------------------------------
    List functions - JSON Callbacks
-----------------------------------------------------------------------------------*/
function listCountries(json) {
    $("#select_country").html("");
    $("#select_country").append("<option value=''>" + $("#select_country").attr("title") + "</option>");
    //sort
    var countryArray = json;
    countryArray.sort(function(a,b){
        if(a.name<b.name) return -1;
        if(a.name>b.name) return 1;
        return 0;
    });
    for (var j = 0; j < countryArray.length; j++) {
        $("#select_country").append("<option value='" + countryArray[j].code + "'>" + countryArray[j].name + "</option>");
    }

    $("#select_country").find("option").each(function () {
        if ($(this).val() == countryName) {
            $(this).attr("selected", "selected");
            getCities();
        }
    });
}
function listCities(json) {
    $("#select_city").html("");
    $("#select_city").append("<option value=''>" + $("#select_city").attr("title") + "</option>");
    //sort
    var cityArray = json;
    cityArray.sort(function(a,b){
        if(a.name<b.name) return -1;
        if(a.name>b.name) return 1;
        return 0;
    });
    for (var j = 0; j < cityArray.length; j++) {
        if (cityArray[j].name.indexOf("Haldensleben") === -1) {
        $("#select_city").append("<option value='" + cityArray[j].name + "'>" + cityArray[j].name + "</option>");
            //markCity(json[j].name);
        }
    }
    $('#select_city').show();
    map.showCityMarkers();
}
function markCity(city) {
    geocoder.geocode({ 'address': city }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            map.addCityMarker(results[0].geometry.location, city, brandName, function(){selectCityFromMap(city)});
        }
    });
}
function selectCityFromMap(city) {
    //alert("selectCityFromMap " + city);
    $("#select_city").find("option:contains('" + city + "')").each(function () {
        if ($(this).text() == city) {
            $(this).attr("selected", "selected");
            getStores();
            map.hideCityMarkers();
        }
    });
}

function in_array(needle, haystack) {
    for(var i in haystack) {
        if(haystack[i] == needle) return true;
    }
    return false;
}

function listStores(json) {
    resetStores();
    if(showStoreTypes == 0){ // Retail
    json = filterStoreType(json, "RETAIL");
    } else if(showStoreTypes == 1) { // Wholesale
    json = filterStoreType(json, "WHOLESALE");
    }
    if (json.length > 0) { 
        map.setListId("storelist");
    map.hideCityMarkers();
        for (var i = 0; i < json.length; i++) {
        if(showStoreTypes === 0){
        if(json[i].brandedStores.length > 0){
            var exitDueToBrandedStoreType = 0;
            for (var b=0; b < json[i].brandedStores.length; b++){
            if(!in_array(json[i].brandedStores[b].type, brandedStoreType) && brandedStoreType.length > 0){
                exitDueToBrandedStoreType = 1;
            }
            }
            if(exitDueToBrandedStoreType){continue;}
        } else {
            if(json[i].storeTypeLink.indexOf("RETAIL") > -1){
            continue;
            }
        }
        }
            var store = json[i].address;
            var latLng = new google.maps.LatLng(store.latitude, store.longitude);
            var content = buildStoreContent(json[i]);
            var title = json[i].name;
            var address = store.street + ", " + store.postalCode + ", " + store.city;
            var display = (json.length == 1) ? true : false;
            map.addMarker(latLng, title, content, brandName, store.geocodeAccuracy, address, display);
        }

        map.fitMarkers();
        //createCarousel(json.length);
    } else {
    alert(emptyStoreText);
    }
    $('#select_city').show();
}
function resetStores() {

    jQuery('.shops').empty();
    var list = document.createElement("ul");
    list.id = "storelist";
    //$(list).addClass("jcarousel-skin-tango");
    $('.shops').append(list);

    map.clearMarkers();
}
/*
function createCarousel(itemCount) {

    jQuery('#storelist').jcarousel({ scroll: 3 });

    if (itemCount > 4) {
        $("div.jcarousel-prev").show();
        $("div.jcarousel-next").show();
    } else {
        $("div.jcarousel-prev").hide();
        $("div.jcarousel-next").hide();
    }
}
*/
function buildStoreContent(store) {
    var html = "";
    /* if(isStoreType(store, "WHOLESALE")){
     html += "<div class='storelogo'></div>";
    } else {
    html += "<div style='height:16px;'></div>";
    } */
    html += "<div class='innercontent'>";
    html += "<h1>" + $("#select_city").val() + "</h1>";
    if (brandName == 'OBJECT') {
        html += "<div class='title'>" + store.name + "</div>";
    }else {
        html += (store.name.length > 0) ? store.name + "<br />" : "";
    }
    html += (store.address.street) ? store.address.street + "<br />" : "";
    html += (store.address.postalCode) ? store.address.postalCode + " " : "";
    html += (store.address.city) ? store.address.city + "<br />" : "";
    html += (store.address.phone) ? "<span class='phone'>" + store.address.phone + "</span><br />" : "";
    //html += '<a href="#">Get directions »</a>';
    html += "</div>";
    return html;
}


/*-----------------------------------------------------------------------------------
    JSON
-----------------------------------------------------------------------------------*/
function changeCountry() {
//    $('#select_city').hide();
//    if ($("#select_country :selected").val().length < 1) return false;

    var countryName = $("#select_country :selected").val();
    resetStores();
    centerMapOnCountry(countryName);
    map.clearCityMarkers();
    getCities();
}
function getCountries() {
    loadJSON(pipeline+"?param=countries%3Fbrand%3D"+$("#hBrand").val(), listCountries);
}
function getCities() {
    var countryName = $("#select_country :selected").val();
    if(showStoreTypes == 0){ // Retail
    loadJSON(pipeline+"?param=cities%3Fcountry%3D"+countryName+"%26brand%3D"+$("#hBrand").val()+"%26storetype%3Dretail", listCities);
    } else if(showStoreTypes == 1) { // Wholesale
    loadJSON(pipeline+"?param=cities%3Fcountry%3D"+countryName+"%26brand%3D"+$("#hBrand").val()+"%26storetype%3Dwholesale", listCities);
    } else {
    loadJSON(pipeline+"?param=cities%3Fcountry%3D"+countryName+"%26brand%3D"+$("#hBrand").val(), listCities);
    }
    
}
function getStores(brand) {
    var city = encodeURIComponent($("#select_city :selected").val());
    if (city != null && city.length > 0) {
        //var url = "JSON.ashx?action=getbrandedstores&brand=" + $("#hBrand").val() + "&countryid=" + $("#select_country :selected").val() + "&city=" + city;
    if(showStoreTypes == 0){ // Retail
        var url = pipeline+"?param=stores%3Fcountry%3D" + $("#select_country :selected").val() + "%26city%3D"+city+"%26brand%3D"+$("#hBrand").val()+"%26type%3Dretail";
    } else if(showStoreTypes == 1) { // Wholesale
        var url = pipeline+"?param=stores%3Fcountry%3D" + $("#select_country :selected").val() + "%26city%3D"+city+"%26brand%3D"+$("#hBrand").val()+"%26type%3Dwholesale";
    } else {
        var url = pipeline+"?param=stores%3Fcountry%3D" + $("#select_country :selected").val() + "%26city%3D"+city+"%26brand%3D"+$("#hBrand").val();
    }
        
        loadJSON(url, listStores);
    } else {
        //if user selects default city after a city has been selected
        var countryName = $("#select_country :selected").text();
        resetStores();
        centerMapOnCountry(countryName);
        map.showCityMarkers();
    }
}



/*-----------------------------------------------------------------------------------
    Helper functions
-----------------------------------------------------------------------------------*/
function loadJSON(url, callback) {
    $.ajax({
        type: "GET",
        async: true,
        cache: false,
        url: url,
        dataType: "json",
        contentType: "application/x-www-form-urlencoded;charset=UTF-8",
        success: callback,
        error: function (e) { alert("Error loading data"); debug(dump(e)); }
    });
}
function debug(str) {
    $("#debug").html($("#debug").html() + "\n\n" + str);
}
function dump(arr, level) {
    var dumped_text = "";
    if (!level) level = 0;

    //The padding given at the beginning of the line.
    var level_padding = "";
    for (var j = 0; j < level + 1; j++) level_padding += "    ";

    if (typeof (arr) == 'object') { //Array/Hashes/Objects 
        for (var item in arr) {
            var value = arr[item];

            if (typeof (value) == 'object') { //If it is an array,
                dumped_text += level_padding + "'" + item + "' ...\n";
                dumped_text += dump(value, level + 1);
            } else {
                dumped_text += level_padding + "'" + item + "' => \"" + value + "\"\n";
            }
        }
    } else { //Stings/Chars/Numbers etc.
        dumped_text = "===>" + arr + "<===(" + typeof (arr) + ")";
    }
    return dumped_text;
}