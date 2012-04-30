/**
 * Dart Hackathon 2012 TLV
 *
 * Code sample to use web.stargam 'api' 
 * Author: Ido Green | greenido.wordpress.com
 * Date: 28/4/2012
 */
#import('dart:html');
#import("dart:json");


// 
// Give us the option to work with web.stagram (use it's data)
// while communicate with the front end page.
//
class HotInsta {

	// basic elements on the page
	InputElement _search= null;
	ButtonElement _go   = null;
	Element _result 	  = null;
	Element _imgs 		  = null;  
	Element _divCar     = null;
		
	// Ctor.  
	HotInsta() {
		_search = document.query('#search');
		_go     = document.query('#go');    
		_result = document.query('#result');
		_imgs   = document.query('#images');
	  _result.hidden = true;
	    
	  _divCar = document.query('#carIn');	    
	  startThePage();
	}
  
  // init values on the page
  startThePage() {
    String baseurl = "http://pipes.yahoo.com/pipes/pipe.run?_id=8a481ba9ce15f5efa8ac6b894b45eeac&rand=3334&_render=json";
    XMLHttpRequest request = new XMLHttpRequest();
    request.open("GET", baseurl, true);
    request.on.load.add((e) {
      _divCar.hidden = false;
      
      var response = JSON.parse(request.responseText);
      var imgs = response['value']['items'];
      for (final img in imgs) {
        writeCarousel(img);
      }
    });
    request.send();
  }

  // write the div+img to the image carousel
  writeCarousel(img) {
    Element divItem = new Element.tag("div");
    if (_divCar.elements.length < 1) {
      divItem.attributes['class'] = "active item";
    }
    else {
      divItem.attributes['class'] = "item";
    }
    divItem.innerHTML = '''<img src = "${img['image']['url']}">${img['title']} ''';
    _divCar.elements.add(divItem);
        
  }
  
	// TODO - hack something simple to change space to + etc'
  String encodeURI(String url) {
  	return url;
  }
  
  // Simple search functionalty
  void run() {
    _go.on.click.add(_(Event clickEvent) {
      if (_search.value != '') {
        // make a web request to our searching pipe
        XMLHttpRequest request = new XMLHttpRequest();
        String searchTerm = _search.value.replaceAll(' ','+');
        String baseurl = "http://pipes.yahoo.com/pipes/pipe.run?_id=8ef6eeff83d97b5a66503af00e891795&_render=json&term=" + searchTerm;
        request.open("GET", baseurl, true);
    
        request.on.load.add((e) {
          _result.hidden = false;
          if (_divCar.elements != null) {
            _divCar.elements.clear();
          }
          var response = JSON.parse(request.responseText);
          //print("res: " + response);
          var imgs = response['value']['items'];
          for (final img in imgs) {
            writeCarousel(img);
          }
        });
        request.send();              
      }      
    });    
  }
	
  // write the result
  void write(img) {
    Element li = new Element.tag('li');
    li.innerHTML = '''<img src = "${img['image']['url']}">${img['title']} ''';
    _result.elements.add(li);
  }
  
}

//
// Start the party
//
void main() {
	new HotInsta().run();
}