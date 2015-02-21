`import Ember from 'ember'`
`import LatLng from 'spikes/models/lat-lng'`


MarkerModel = Ember.Object.extend

  _updateMarkerPosition: Ember.observer 'position', ->
    @get 'googleMapsMarker'
    ?.setPosition @get 'position'

  _updateMarkerPositionOnMapChanged: Ember.observer 'position', ->
    @_updateMarkerPosition()

  _updateMarkerPositionOnInit: Ember.on 'init', ->
    @_updateMarkerPosition()

  _updateMarkerMap: Ember.observer 'map', ->
    @get 'googleMapsMarker'
    ?.setMap @get 'map'

  _updateMarkerMapOnMapChanged: Ember.observer 'map', ->
    @_updateMarkerMap()

  _updateMarkerMapOnInit: Ember.on 'init', ->
    @_updateMarkerMap()

  _updatePropertiesOnGoogleMapsMarkerChanged: \
    Ember.observer 'googleMapsMarker', ->
      marker = @get 'googleMapsMarker'
      if marker?
        @setProperties
          map: marker.getMap()
          position: marker.getPosition()

  
MarkerModel.reopenClass

  createFromGoogleMapsMarker: (marker) ->
    created = MarkerModel.create()
    created.set 'googleMapsMarker', marker
    return created

  create: (properties) ->
    properties ?= {}
    properties.googleMapsMarker = new google.maps.Marker()
    created = @_super properties
    return created


`export default MarkerModel`
