$ = require 'jquery'
BaseView = require '../BaseView'

module.exports = class TagInputView extends BaseView

	close : () ->
		$("form", @el).off()
		$("input", @el).off()
		super()
	
	focus : () ->
		$("input", @el).focus()

	constructor : (@el, @model, @filterModel) ->
		self = @
		console.log @el
		$("form", @el).on 'submit', (event) ->
			event.preventDefault()
		input = $("input", @el)
		input.on 'keydown', (event) ->
			if event.keyCode == 9
				event.preventDefault()
				self.trigger('loseFocus')
		input.on 'keyup', (event) ->
			val = input.val()
			# if it's a comma or enter
			if event.keyCode in [13, 188]
				self.model.addTag(val)
				input.val('')
				self.filterModel.set('filter', '')
			else
				self.filterModel.set('filter', val)
			self.filterModel.fetch()
