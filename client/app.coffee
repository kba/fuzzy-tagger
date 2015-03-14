global.$ = global.jQuery = $ = require 'jquery'
jquery_ui = require 'jquery-ui'
require 'bootstrap'
Backbone = require 'backbone'
Backbone.$ = $

Request = require 'superagent'
FileView = require '../client/views/FileView'

class TagAppRouter extends Backbone.Router

	routes : {
		"tag/*filename": 'file'
		"*actions": 'defaultRoute'
	}

$ ->
	appRouter = new TagAppRouter()
	appRouter.on 'route:file', (filename) ->
		console.log filename
		appView = new FileView($("#main"), filename)
	appRouter.on 'route:defaultRoute', (actions) ->
		Request
			.get('/api/file')
			.end (err, res) ->
				appRouter.navigate "tag#{res.body[0]}"
	Backbone.history.start()
