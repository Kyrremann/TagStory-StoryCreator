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

def generate_latlng()
  locations = ""
  counter = 1
  get_options.each do | key, value |
    locations += "var myLatlng#{counter} = new google.maps.LatLng(#{value['lat']},#{value['long']})\n"
    counter += 1
  end
  p locations
end

def generate_markers()
  markers = ""
  counter = 1
  get_options.each do | key, value |
    markers += "var marker#{counter} = new google.maps.Marker({ position: myLatlng#{counter}, map: map, draggable: true });"
    counter += 1
  end
  p markers
end

def generate_info_windows()
  infoWindows = ""
  counter = 1
  get_options.each do | key, value |
    infoWindows += "var infowindow#{counter} = new google.maps.InfoWindow({ content: \"Option: #{key}\" });"
    counter += 1
  end
  p infoWindows
end

def generate_listeners()
  listeners = ""
  counter = 1
  get_options.each do | key, value |
    listeners += "google.maps.event.addListener(marker#{counter}, 'click', function() { infowindow#{counter}.open(map, marker#{counter}); });"
    listeners += "google.maps.event.addListener(marker#{counter}, 'drag', function() { document.getElementById('lat-#{key}').value = marker#{counter}.position.lat(); document.getElementById('long-#{key}').value = marker#{counter}.position.lng(); });"
    counter += 1
  end
  p listeners
end

def simple_js_helper()
	p "var marker2 = new google.maps.Marker({
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
