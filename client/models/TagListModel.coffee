Backbone = require 'backbone'
Request = require 'superagent'
module.exports = class TagListModel extends Backbone.Model

	defaults : {
		tags: []
		filter: ''
	}

	fetch : () ->
		self = @
		Request
			.get("/api/tags?filter=#{self.get 'filter'}")
			.end (err, res) ->
				self.set('tags', res.body)


