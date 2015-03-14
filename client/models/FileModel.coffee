global.$ = $ = require 'jquery'
Backbone = require 'backbone'
Request = require 'superagent'

module.exports = class FileModel extends Backbone.Model

	urlRoot : '/api/file'

	defaults : {
		filename : 'NOT-SET'
		tags: []
	}

	addTag : (tag) ->
		self = @
		Request
			.patch("/api/file/#{self.get 'filename'}")
			.send([
				op: 'add'
				path: '/tags/-'
				value: tag
			]).end (err, res) ->
				console.log res
				self.fetch()
