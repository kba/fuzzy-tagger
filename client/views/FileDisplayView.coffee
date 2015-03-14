Backbone = require 'backbone'
module.exports = class FileDisplayView extends Backbone.View

	constructor : (@el, @model) ->

	render : () ->
		@el.html($("<img>")
					.attr('src', "/file/#{@model.get 'filename'}"))


