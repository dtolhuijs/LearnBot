# Description:
#   Search for code snippets on Snipplr
#
# Dependencies:
#   none
#
# Configuration:
#   HUBOT_READER_EMAIL
#   HUBOT_READER_TOKEN
#
# Commands:
#   learnbot reader me <query> - Search for the query
#
# Author:
#   wrdevos

module.exports = (robot) ->
    robot.respond /snipplr (.*)/i, (msg) ->
     searchQuery = msg.match[1]
     console.log searchQuery

     snippetSearch msg, searchQuery

 snippetSearch = (msg, searchQuery) ->
   data = ""
   msg.http("http://snipplr.com/all/convert.json/")
     .query
       search: encodeURIComponent(searchQuery)
       raw_text: searchQuery
       user_token: process.env.HUBOT_READER_TOKEN
     .get( (err, req)->
       req.addListener "response", (res)->
         output = res

         output.on 'data', (d)->
           data += d.toString('utf-8')

         output.on 'end', ()->
           parsedData = JSON.parse(data)

           if parsedData.error
             msg.send "Error searching snippet: #{parsedData.error}"
             return

           if parsedData.length > 0
             qs = for article in parsedData[0..3]
               "https://snipplr.com/all/#{Snipplr.title[0].slug}/snippets/#{snippet.slug} - #{snippet.title}"
             if parsedData.total-5 > 0
               qs.push "#{parsedData.total-3} more..."
             for ans in qs
               msg.send ans
           else
             msg.reply "No snippet found matching that search."
     )()
