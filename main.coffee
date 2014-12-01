(() ->
  loadReview = (url) ->
    $.ajax
      url: url
      cache: false
      success: (data, textStatus, jqXHR) ->
        $(".main").html("")
        $(".main").append(Handlebars.templates.review(data))
        for i of data.ramen
          rating = data.ramen[i].rating
          ratings = []
          labels = []
          for key of rating
            if rating.hasOwnProperty(key)
              labels.push key
              ratings.push rating[key]
          $($(".main .ramen-review")[i]).rating(ratings, {
            numSides: 5
            maxRating: 4
            size: 400
            alternateGrid: true
            gridColor: "#999999"
            barStrokeColor: "#888888"
            barStrokeWidth: 0.1
            #"backgroundStrokeColor": "#444444",
            backgroundFillColor: "#b2b2b2"
            #"strokeColor": "#ff9999",
            fillColor: "#ff9999"
            #"labels": ['broth', 'noodles', 'egg', 'meat', 'toppings']
          })

  ramen = {}

  $(document).ready ->
    $.ajax
      url: "ramen.json"
      cache: false
      success: (data, textStatus, jqXHR) ->
        ramen = data
        return

    $(".menu a").click (e) ->
      hash = window.location.hash
      if hash.indexOf("#browse-") is 0
        for ele of ramen[hash.substr(8)]
          loadReview ramen[hash.substr(8)][ele]
)()
