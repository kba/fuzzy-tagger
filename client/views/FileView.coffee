$ = require 'jquery'
Request = require 'superagent'
BaseView = require '../BaseView'

FileModel       = require '../models/FileModel'
TagListModel    = require '../models/TagListModel'
TagListView     = require '../views/TagListView'
TagInputView    = require '../views/TagInputView'
FileDisplayView = require '../views/FileDisplayView'

module.exports = class FileView extends BaseView

	render : () ->
		self = @
		$("#navigation").empty()
		# next = @model.get('next')
		# prev = @model.get('prev')
		for pn in ['prev', 'next']
			href = self.model.get(pn)
			link = $("<a>").html(pn)
			if href
				link.on('click', ->
					self.close()
					window.location.hash = "tag/#{href}")
				link.attr('href', "#tag/#{href}")
				link.addClass('active')
			else
				link.addClass('disabled')
			$("#navigation").append(link)
		$("input", self.inputView.el).focus()
	
	close : () ->
		self = @
		self.model.off()
		self.tagCompleteModel.off()
		self.inputView.close()
		# self.displayView.close()
		# self.tagCompleteView.close()
		# self.tagListView.close()
		self.off()

	constructor: (el, filename) ->
		self = @
		self.el = el

		self.model = new FileModel(id: filename, filename: filename)
		self.model.on 'change', -> self.render()
		self.model.fetch()

		self.displayView = new FileDisplayView($("#main"), self.model)
		self.model.on 'change', () -> self.displayView.render()

		self.tagCompleteModel = new TagListModel()
		self.tagCompleteView = new TagListView($("ul#tag-complete-list"), self.tagCompleteModel, self.model)
		self.tagCompleteModel.on 'change', -> self.tagCompleteView.render()
		self.tagCompleteModel.fetch()

		self.tagListView = new TagListView($("ul#tag-list"), self.model)
		self.model.on 'change', () ->
			self.tagListView.render()
			self.tagCompleteModel.set 'exclude', self.model.get('tags').map((el) -> el.tag)

		self.inputView = new TagInputView($("#input"), self.model, self.tagCompleteModel)
		self.inputView.on 'loseFocus', ->
			self.tagCompleteView.focus()
		self.tagCompleteView.on 'loseFocus', ->
			self.inputView.focus()
