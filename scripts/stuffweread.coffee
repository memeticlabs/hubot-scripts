# Stuffweread.coffee
#
# Description:
#   Utility tweets out a reading recommendation from hipchat 
#   via a common twitter account on behalf of a hipchat user.
#
# Commands:
#   hubot read [URL] [#hashtag]
#
# Response:
#   @twitterhandle just tweeted: [user] recommends [URL] [#hashtags]
#
# Dependencies:
#   underscore
#	twit

_ = require "underscore"
Twit = require "twit"

config =
  consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
  access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET

module.exports = (robot) ->
  twit = undefined
  robot.respond /read ?(.*)/i, (msg) ->
  	unless config.consumer_key
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
      return
    unless config.consumer_secret
      msg.send "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
      return
    unless config.access_token
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN environment variable."
      return
    unless config.access_token_secret
      msg.send "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
      return

    unless twit
      twit = new Twit config
  
  	# get the user who called hubot
  	user = msg.message.user.name.split " "

  	# grab his first name
  	if user.length > 1
  		user = user[0]

  	payload = msg.match[1].split " "

  	# get url
  	url = payload[0]

  	# get hashtags if present
  	hashtags = undefined
  	if payload.length > 1
  		hashtags = payload[1..]
  	hashtags = hashtags.toString().replace /,/g, " "

  	# compose tweet
  	tweet = "#{user} recommends #{url} #{hashtags}"

  	# post tweet
  	twit.post "statuses/update",
  		status: tweet
  	, (err, reply) ->
  		if err
  		  data = JSON.parse(err.data).errors[0]
  		  msg.reply "I can't do that. #{data.message} (error #{data.code})"
  		  return
  		if reply['text']
  			return msg.send "#{reply['user']['screen_name']} just tweeted: #{reply['text']}"
  		else
  			return msg.reply "Hmmm.. I'm not sure if the tweet posted. Check the account: http://twitter.com/Stuffweread"
