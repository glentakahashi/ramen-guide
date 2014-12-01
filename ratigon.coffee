(($) ->
  lineFunction = (data) -> return d3.svg.line().x((d) -> d.x).y((d) -> d.y).interpolate("linear")(data) + 'Z'

  scalePolygon = (polygon, scale, maxScale) ->
    if maxScale?
      $.map(polygon, (val, i) ->
        r = {}
        r.x = val.x * scale[i] / maxScale
        r.y = val.y * scale[i] / maxScale
        return r
      )
    else
      $.map(polygon, (val) ->
        r = {}
        r.x = val.x * scale
        r.y = val.y * scale
        return r
      )

  $.fn.rating = (ratings, options) ->
    return @each () ->
      #initialize default options
      settings = $.extend({
        numSides: 5
        maxRating: 10
        size: 150
        alternateGrid: false
        gridStrokeWidth: 1
        barStrokeWidth: 1
        backgroundStrokeWidth: 1
        backgroundFillOpacity: 1
        strokeWidth: 1
        fillOpacity: 0.5
        rotation: -90
      }, options)

      #generate our shape
      shape = []
      i = 0
      while i < ratings.length
        x = 200 * Math.cos(2 * Math.PI * i / settings.numSides + settings.rotation * Math.PI / 180)
        y = 200 * Math.sin(2 * Math.PI * i / settings.numSides + settings.rotation * Math.PI / 180)
        shape.push({
          x: x
          y: y
        })
        i++

      #update
      if not options?
        #TODO: update the rating
      else
        #create the base svg
        svg = d3.select(this).append("svg").attr("width", settings.size).attr("height", settings.size)
        svg = svg.attr("viewBox", "-210 -210 420 420").attr("fill","none")

        #main background
        path = svg.append("path").attr("d", lineFunction(shape))
        if settings.backgroundStrokeColor?
          path.attr("stroke", settings.backgroundStrokeColor)
              .attr("stroke-width", settings.backgroundStrokeWidth)
        if settings.backgroundFillColor?
          path.attr("fill", settings.backgroundFillColor)
              .attr("fill-opacity", settings.backgroundFillOpacity)

        #inner lines
        if settings.gridColor?
          color = settings.gridColor
          i = settings.maxRating - 1
          g = svg.append("g")
          while i > 0
            if settings.alternateGrid
              color = if i % 2 == 1 - settings.maxRating % 2 then settings.gridColor else settings.backgroundFillColor
            path = g.append("path").attr("d", lineFunction(scalePolygon(shape, i / settings.maxRating)))
            #if we aren't alternating, just draw a line for each thing
            if not settings.alternateGrid
              path.attr("stroke", color)
                  .attr("stroke-width", settings.gridStrokeWidth)
            else
              path.attr("fill", color)
                  .attr("fill-opacity", settings.backgroundFillOpacity)
            i--

        #dividing grid
        if settings.barStrokeColor?
          i = 0
          g = svg.append("g")
          while i < settings.numSides
            g.append("path").attr("d", lineFunction([{x: 0, y: 0}, shape[i]]))
                            .attr("stroke", settings.barStrokeColor)
                            .attr("stroke-width", settings.barStrokeWidth)
            i++

        #rating shape
        path = svg.append("path").attr("d", lineFunction(scalePolygon(shape, ratings, settings.maxRating)))
                                 .attr("class", "rating-path")

        if settings.strokeColor?
          path.attr("stroke", settings.strokeColor)
              .attr("stroke-width", settings.strokeWidth)
        if settings.fillColor?
          path.attr("fill", settings.fillColor)
              .attr("fill-opacity", settings.fillOpacity)
)( jQuery )
