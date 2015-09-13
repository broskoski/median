Backbone = require 'backbone'
{ KERNAL_API_URL } = require '../config.coffee'
transactionMap = require '../maps/transactions'
_ = require 'underscore'

module.exports = class Account extends Backbone.Model

  url: ->
    "#{KERNAL_API_URL}/accounts/#{@idOr_id()}"

  idOr_id: ->
    @id or @get('_id')

  holdsPosition: (contract) ->
    _.any @get('open_positions'), (position) ->
      position.contract is contract.get('id')

  makeTransaction: ({ transaction, contract, block_id }, options) ->
    order = new Backbone.Model
    order.url = "#{@url()}/#{transaction}/#{contract.id}/block_id/1"
    order.save null, options

  canMakeTransaction: (transaction, contract) ->
    return { success: false, reason: 'Contract not found.' } unless contract

    switch transaction
      # check that user has enough account balance
      when 'buy'
        amount = contract.get transactionMap[transaction]
        if amount > @get('balance')
          return {
            success: false
            reason: "You don't have enough cåin to purchase #{contract.id}"
          }
        else
          return {
            success: true
          }
      # check that user holds this contract
      when 'sell'
        if @holdsPosition contract
          return {
            success: true
          }
        else
          return {
            success: false
            reason: "You don't hold any contracts for this future."
          }