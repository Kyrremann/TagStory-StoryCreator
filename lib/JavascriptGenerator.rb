def generate_latlng()
  locations = ""
  counter = 1
  get_options.each do | key, value |
    locations += "var myLatlng#{counter} = new google.maps.LatLng(#{value['lat']},#{value['long']})\n"
    counter += 1
  end
  locations
end

def generate_markers()
  markers = ""
  counter = 1
  get_options.each do | key, value |
    markers += "var marker#{counter} = new google.maps.Marker({ position: myLatlng#{counter}, map: map, draggable: true });"
    counter += 1
  end
  markers
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
  listeners
end
