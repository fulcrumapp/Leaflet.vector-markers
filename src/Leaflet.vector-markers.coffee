#
#  Leaflet.VectorMarkers, a plugin that adds colorful iconic svg markers for Leaflet, based on the Font Awesome icons
#  (c) 2014, Mathias Schneider
#
#  Version: 0.0.3
#
#  http://leafletjs.com
#  https://github.com/hiasinho
#

#global L

((window, document, undefined_) ->
  "use strict"

  #
  #     * Leaflet.VectorMarkers assumes that you have already included the Leaflet library.
  #
  L.VectorMarkers = {}
  L.VectorMarkers.version = "1.0.0"
  L.VectorMarkers.MAP_PIN = 'M17.501,4c7.444,0,13.5,6.057,13.5,13.501c0,7.865-7.327,16.83-10.494,20.339l-3.006,3.499l-3-3.492 C11.337,34.343,4,25.372,4,17.501C4,10.057,10.057,4,17.501,4 M17.501,0C7.851,0,0,7.851,0,17.501 C0,26.4,7.188,35.709,11.499,40.49l2.969,3.456l3.034,3.531l3.034-3.531l2.975-3.462c4.308-4.78,11.492-14.086,11.492-22.982 C35.002,7.851,27.151,0,17.501,0L17.501,0z'
  L.VectorMarkers.MAP_PIN_OUTLINE = 'M20.508,37.84c3.167-3.509,10.494-12.474,10.494-20.339C31.002,10.057,24.946,4,17.501,4 C10.057,4,4,10.057,4,17.501c0,7.871,7.337,16.842,10.501,20.346l3,3.492L20.508,37.84z'
  L.VectorMarkers.Icon = L.Icon.extend(
    options:
      iconSize: [ 35, 47 ]
      iconAnchor: [ 18, 51 ]
      popupAnchor: [ 2, -40 ]
      shadowAnchor: [ 8, 55 ]
      shadowSize: [ 54, 51 ]
      className: "vector-marker"
      prefix: "fa"
      spinClass: "fa-spin"
      extraClasses: ""
      icon: null
      markerColor: "#858585"
      markerOutlineColor: "#B4B3B3"
      iconColor: "white"

    initialize: (options) ->
      options = L.Util.setOptions(this, options)

    createIcon: (oldIcon) ->
      div = (if (oldIcon and oldIcon.tagName is "DIV") then oldIcon else document.createElement("div"))
      options = @options

      icon = @_createInner()  if options.icon

      pin_path = L.VectorMarkers.MAP_PIN
      pin_outline_path = L.VectorMarkers.MAP_PIN_OUTLINE

      div.innerHTML = '<svg width="35.002px" height="47.477px" viewBox="0 0 35.002 47.477" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">' +
                        '<path d="' + pin_path + '" fill="' + options.markerColor + '"></path>' +
                        '<path fill="' + options.markerOutlineColor + '" d="' + pin_outline_path + '"/>' +
                        icon +
                      '</svg>'
      @_setIconStyles div, "icon"
      @_setIconStyles div, "icon-" + options.markerColor
      div

    _createInner: ->
      iconClass = undefined
      iconSpinClass = ""
      iconColorClass = ""
      iconColorStyle = ""
      options = @options
      if options.prefix is '' or options.icon.slice(0, options.prefix.length + 1) is options.prefix + "-"
        iconClass = options.icon
      else
        iconClass = options.prefix + "-" + options.icon
      iconSpinClass = options.spinClass  if options.spin and typeof options.spinClass is "string"
      if options.iconColor
        if options.iconColor is "white" or options.iconColor is "black"
          iconColorClass = "icon-" + options.iconColor
        else
          iconColorStyle = "style='color: " + options.iconColor + "' "
      "<i " + iconColorStyle + "class='" + options.extraClasses + " " + options.prefix + " " + iconClass + " " + iconSpinClass + " " + iconColorClass + "'></i>"

    _setIconStyles: (img, name) ->
      options = @options
      size = L.point(options[(if name is "shadow" then "shadowSize" else "iconSize")])
      anchor = undefined
      if name is "shadow"
        anchor = L.point(options.shadowAnchor or options.iconAnchor)
      else
        anchor = L.point(options.iconAnchor)
      anchor = size.divideBy(2, true)  if not anchor and size
      img.className = "vector-marker-" + name + " " + options.className
      if anchor
        img.style.marginLeft = (-anchor.x) + "px"
        img.style.marginTop = (-anchor.y) + "px"
      if size
        img.style.width = size.x + "px"
        img.style.height = size.y + "px"

    createShadow: ->
      div = document.createElement("div")
      @_setIconStyles div, "shadow"
      div
  )
  L.VectorMarkers.icon = (options) ->
    new L.VectorMarkers.Icon(options)
) this, document
