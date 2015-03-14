$ = require 'jquery'
Backbone = require 'backbone'
module.exports = class TagListView extends Backbone.View

	constructor: (@el, @model) ->

	render: () ->
		@el.empty()
		# console.log @model.get('tags')
		for tag in @model.get('tags')
			@el.append($("<li>")
						.attr('class', 'list-group-item')
						.attr('data-tag', tag.tag)
						.html(tag.html))


