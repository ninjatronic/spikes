`import Ember from 'ember'`

# Usage:
#   sw: LatLngModel
#   ne: LatLngModel
LatLngBoundsModel = Ember.Object.extend

  googleMapsLatLngBounds: Ember.computed 'sw.googleMapsLatLng', 'ne.googleMapsLatLng', ->
    sw = @get 'sw.googleMapsLatLng'
    ne = @get 'ne.googleMapsLatLng'
    new google.maps.LatLngBounds sw, ne


`export default LatLngBoundsModel`
