BaseArenaModel = require './base_arena_model.coffee'
sd = require("sharify").data
moment = require 'moment'
parseDomain = require 'parse-domain'
contractMap = require '../maps/contracts.coffee'
_ = require 'underscore'

module.exports = class Block extends BaseArenaModel

  url: -> "#{sd.ARENA_API_URL}/blocks/#{@id}"

  createdAtAgo:  -> moment(@get('created_at')).fromNow()

  updatedAtAgo:  -> moment(@get('updated_at')).fromNow()

  sourceDomain: ->
    if url = @get('source')?.url
      parsed = parseDomain(url)
      "#{parsed?.domain}.#{parsed?.tld}"

  smartTruncate: (attr, limit=40) ->
    return unless @get(attr)
    size = 0
    textArray = for token in @get(attr).split(' ')
      size += (token.length + 1)
      break if size > limit
      token
    textArray.join(" ") + (if @get(attr).length > limit then "..." else "")

  callSignArray: ->
    if @has('channel_ids')
      callSigns = _.keys contractMap
      contracts = _.filter callSigns, (callSign) =>
        channel_id = contractMap[callSign].channel_id
        _.contains @get('channel_ids'), channel_id
    else
      []

