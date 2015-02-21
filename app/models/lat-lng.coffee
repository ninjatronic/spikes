`import Ember from 'ember'`


LatLngModel = Ember.Object.extend

  # todo: should be in setter of computed property
  setPropertiesFromGoogleMapsLatLng: (googleMapsLatLng) ->
    @setProperties
      lat: googleMapsLatLng.lat()
      lng: googleMapsLatLng.lng()

  googleMapsLatLng: Ember.computed 'lat', 'lng', ->
    lat = @get 'lat'
    lng = @get 'lng'
    new google.maps.LatLng lat, lng


LatLngModel.reopenClass

  create: ->
    properties = arguments[0]

    if properties? \
      and \
      'function' is typeof properties.lat \
      and \
      'function' is typeof properties.lng

        properties =
          lat: properties.lat()
          lng: properties.lng()

        arguments[0] = properties

    @_super arguments...


`export default LatLngModel`
