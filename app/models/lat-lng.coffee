`import Ember from 'ember'`


LatLngModel = Ember.Object.extend

  googleMapsLatLng: Ember.computed 'lat', 'lng', ->
    lat = @get 'lat'
    lng = @get 'lng'
    new google.maps.LatLng lat, lng


`export default LatLngModel`
