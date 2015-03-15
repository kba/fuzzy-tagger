Fs = require 'fs'
Express = require 'express'
Jade = require 'jade'
BodyParser = require 'body-parser'
Fuzzy = require 'fuzzy'
JsonPatch = require 'json-patch'

module.exports = class TaggingServer

	setupExpress : () ->
		self = @
		@app.set('views', './client/templates')
		@app.set('view engine', 'jade')

		@app.use(Express.static('public'))
		@app.use(BodyParser.json())

		@app.get '/', (req, res, next) ->
			res.render 'index'

		@app.get /^\/file\/(.*)/, (req, res, next) ->
			filename = req.params[0]
			if filename not of self.files
				res.status 404
				return next "No such file: #{filename}"
			res.header 'Content-Type', 'image/png'
			Fs.readFile filename, (err, data) ->
				res.send data

		@app.get '/api/tags', (req, res, next) ->
			filter = req.query.filter
			ret = self.taglist.map (el) -> { html: el, tag: el }
			fuzzyOpts = {
				pre: '<b>'
				post: '</b>'
			}
			if filter
				ret = Fuzzy.filter(filter, self.taglist, fuzzyOpts).map (el) -> { html: el.string, tag: el.original }
			res.send ret

		@app.get '/api/file', (req, res, next) ->
			self.db.find {}, (err, docs) ->
				res.send docs.map (el) -> el._id

		@app.get /\/api\/file\/(.*)/, (req, res, next) ->
			filename = req.params[0]
			self.db.findOne {_id: filename}, (err, found) ->
				if err or not found
					res.status 404
					return next "No such file: #{filename}"
				ret = JSON.parse JSON.stringify found
				ret.tags = ret.tags.map (el) -> {html: el, tag: el}
				res.send ret

		@app.patch /\/api\/file\/(.*)/, (req, res, next) ->
			filename = req.params[0]
			self.db.findOne {_id: filename}, (err, found) ->
				if err or not found
					res.status 404
					return next "No such file: #{filename}"
				patchset = req.body
				console.log patchset
				JsonPatch.apply(self.files[filename], patchset)
				for patch in patchset
					if patch.op is 'add'
						if patch.value not in self.taglist
							self.taglist.push patch.value
				self.db.update {_id: filename}, self.files[filename], (err, newDoc) ->
					console.log newDoc
				res.status 204
				res.end()

	constructor : (@files, @taglist, @db) ->
		@files or= {}
		@taglist or= []
		@app = Express()
		@setupExpress()

	listen : (port) ->
		@app.listen(port)



