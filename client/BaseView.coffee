$ = require 'jquery'
Backbone = require 'backbone'

module.exports = class BaseView extends Backbone.View

	close : () ->
		@off
		@remove()
	
	focus : () ->
		@el.focus()

