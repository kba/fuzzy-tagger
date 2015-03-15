BaseView = require '../BaseView'
module.exports = class FileDisplayView extends BaseView

	constructor : (@el, @model) ->

	render : () ->
		@el.html($("<img>")
					.attr('src', "/file/#{@model.get 'filename'}"))


