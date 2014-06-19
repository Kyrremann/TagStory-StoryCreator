require_relative 'StoryHandler.rb'
require_relative 'TagHandler.rb'

def get_rev()
  session[:rev]
end

def set_rev(id)
  session[:rev] = id
end

# User
def get_user()
  session[:user_info]
end

def get_name()
  get_user["name"]
end

def get_given_name()
  get_user["given_name"]
end

def get_picture()
  get_user["picture"]
end

def simple_js_helper2()
  locations = ""
  counter = 1
  get_options.each do | key, value |
    locations += "var myLatlng#{counter} = new google.maps.LatLng(#{value['lat']},#{value['long']})\n"
    counter += 1
  end
  p locations
end

def simple_js_helper()
  get_options.each do | key, value |
  end
	p "var marker1 = new google.maps.Marker({
          position: myLatlng1,
          map: map,
          draggable: true
        });
        var infowindow1 = new google.maps.InfoWindow({
          content: \"Option: 22\"
        });
        google.maps.event.addListener(marker1, 'click', function() {
          infowindow1.open(map, marker1);
        });
        google.maps.event.addListener(marker1, 'drag', function() {
            document.getElementById('lat-22').value = marker1.position.lat();
            document.getElementById('long-22').value = marker1.position.lng();
        });

        var marker2 = new google.maps.Marker({
          position: myLatlng2,
          map: map,
          draggable: true
        });
        var infowindow2 = new google.maps.InfoWindow({
          content: \"Option: 26\"
        });
        google.maps.event.addListener(marker2, 'click', function() {
          infowindow2.open(map, marker2);
        });
        google.maps.event.addListener(marker2, 'drag', function() {
            document.getElementById('lat-26').value = marker2.position.lat();
            document.getElementById('long-26').value = marker2.position.lng();
        });"
end