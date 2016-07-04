module.exports = (robot) ->

  robot.respond /snipplr(.*)$/i, (msg) ->
    name = msg.match[1].trim()

    if name is "ruby"
      url = "all/language/"
    else if name is "javascript"
      url = "all/language/"


    msg.http("http://snipplr.com/#{url}.json")
    .get() (err, res, body) ->
      try
        data = JSON.parse body
        children = data.data.children
        snippet = msg.random(children).data

        snippettext = snippet.title.replace(/\*\.\.\.$/,'') + ' ' + snippet.selftext.replace(/^\.\.\.\s*/, '')

        msg.send snippettext.trim()

      catch ex
        msg.send "Erm, something went EXTREMELY wrong - #{ex}"
