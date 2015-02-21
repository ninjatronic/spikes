`import Ember from 'ember'`
`import LatLng from 'spikes/models/lat-lng'`


LatLngBoundsModel = Ember.Object.extend

  # todo: should be in setter of computed property
  setPropertiesFromGoogleMapsLatLngBounds: (googleMapsLatLngBounds) ->
    @setProperties
      sw: LatLng.create googleMapsLatLngBounds.getSouthWest()
      ne: LatLng.create googleMapsLatLngBounds.getNorthEast()

  googleMapsLatLngBounds: Ember.computed 'sw.googleMapsLatLng', 'ne.googleMapsLatLng', ->
    sw = @get 'sw.googleMapsLatLng'
    ne = @get 'ne.googleMapsLatLng'
    new google.maps.LatLngBounds sw, ne


LatLngBoundsModel.reopenClass

  create: ->
    properties = arguments[0]

    if properties? \
      and \
      'function' is typeof properties.getNorthEast \
      and \
      'function' is typeof properties.getSouthWest

        properties =
          ne: properties.getNorthEast()
          sw: properties.getSouthWest()

        arguments[0] = properties

    @_super arguments...


`export default LatLngBoundsModel`
