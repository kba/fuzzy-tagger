$ = require 'jquery'
Request = require 'superagent'
Backbone = require 'backbone'

FileModel       = require '../models/FileModel'
TagListModel    = require '../models/TagListModel'
TagListView     = require '../views/TagListView'
TagInputView    = require '../views/TagInputView'
FileDisplayView = require '../views/FileDisplayView'

module.exports = class FileView extends Backbone.View

	render : () ->
		self = @

	constructor: (el, filename) ->
		self = @
		self.el = el
		console.log filename

		self.model = new FileModel(id: filename, filename: filename)
		self.model.on 'change', -> self.render()
		self.model.fetch()

		self.displayView = new FileDisplayView($("#main"), self.model)
		self.model.on 'change', () -> self.displayView.render()

		self.tagListView = new TagListView($("ul#tag-list"), self.model)
		self.model.on 'change', () -> self.tagListView.render()

		self.tagCompleteModel = new TagListModel()
		self.tagCompleteView = new TagListView($("ul#tag-complete-list"), self.tagCompleteModel)
		self.tagCompleteModel.on 'change', -> self.tagCompleteView.render()
		self.tagCompleteModel.fetch()

		self.inputView = new TagInputView($("#input"), self.model, self.tagCompleteModel)
		self.inputView.el.focus()
