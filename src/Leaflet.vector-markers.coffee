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
  L.VectorMarkers.MAP_PIN_BODY = 'M11.28,3c4.565,0,8.279,4.038,8.279,9c0,5.243-4.494,11.219-6.436,13.558l-1.843,2.333l-1.84-2.328 C7.5,23.228,3,17.247,3,12C3,7.038,6.715,3,11.28,3 M11.28,0C5.061,0,0,5.383,0,12c0,5.982,4.442,12.237,7.108,15.451l1.818,2.3 l2.354,2.977l2.353-2.978l1.821-2.304C18.12,24.232,22.56,17.979,22.56,12C22.56,5.383,17.5,0,11.28,0L11.28,0z'
  L.VectorMarkers.MAP_PIN_OUTLINE = 'M13.124,25.558C15.066,23.219,19.56,17.243,19.56,12c0-4.962-3.714-9-8.279-9C6.715,3,3,7.038,3,12 c0,5.247,4.5,11.228,6.44,13.563l1.84,2.328L13.124,25.558z'
  L.VectorMarkers.Icon = L.Icon.extend(
    options:
      iconSize: [ 23, 33 ]
      iconAnchor: [ 11, 35 ]
      popupAnchor: [ 2, -40 ]
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

      icon = if options.icon then @_createInner() else ''

      pin_body_path = L.VectorMarkers.MAP_PIN_OUTLINE
      pin_outline_path = L.VectorMarkers.MAP_PIN_BODY

      div.innerHTML = '<svg width="22.56px" height="32.729px" viewBox="0 0 22.56 32.729" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">' +
                        '<path class="marker-body" fill="' + options.markerColor + '" d="' + pin_body_path + '"></path>' +
                        '<path class="marker-outline" fill="' + options.markerOutlineColor + '" d="' + pin_outline_path + '"/>' +
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
  )
  L.VectorMarkers.icon = (options) ->
    new L.VectorMarkers.Icon(options)
) this, document
