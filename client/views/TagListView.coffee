$ = require 'jquery'
BaseView = require '../BaseView'

possibleKeys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split('')

module.exports = class TagListView extends BaseView

	constructor: (@el, @model, @fileModel) ->
		self = @
		@el.on 'keydown', (event) ->
			if event.keyCode == 9
				event.preventDefault()
				self.trigger('loseFocus')
			else
				key = String.fromCharCode(event.keyCode)
				matchingTag = $("li[data-key='#{key}'").first()
				if matchingTag
					self.fileModel.addTag matchingTag.attr('data-tag')
		@el.on 'focus', (event) ->
			self.render(true)
		@el.on 'focusout', (event) ->
			self.render(false)

	close : () ->
		@el.off()

	render: (withKeys) ->
		@el.empty()
		# console.log @model.get('tags')
		idx = 0
		for tag in @model.get('tags')
			if @model.get('exclude') and tag.tag in @model.get('exclude')
				continue
			li = $("<li>")
					.addClass('tag')
					.addClass('list-group-item')
					.attr('data-tag', tag.tag)
			if withKeys and idx < possibleKeys.length
				li.append $("<b>").append(possibleKeys[idx])
				li.attr "data-key", possibleKeys[idx]
			li.append tag.html
			@el.append li
			idx++
