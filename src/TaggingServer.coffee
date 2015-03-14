Fs = require 'fs'
Express = require 'express'
Jade = require 'jade'
BodyParser = require 'body-parser'
Fuzzy = require 'fuzzy'
JsonPatch = require 'json-patch'

module.exports = class TaggingServer

	setupExpress : () ->
		self = @
		@app.set('views', './templates')
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
			res.send Object.keys self.files

		@app.get /\/api\/file\/(.*)/, (req, res, next) ->
			filename = req.params[0]
			if filename not of self.files
				res.status 404
				return next "No such file: #{filename}"
			ret = JSON.parse JSON.stringify self.files[filename]
			ret.tags = ret.tags.map (el) -> {html: el, tag: el}
			res.send ret

		@app.patch /\/api\/file\/(.*)/, (req, res, next) ->
			filename = req.params[0]
			if filename not of self.files
				res.status 404
				return next "No such file: #{filename}"
			patchset = req.body
			JsonPatch.apply(self.files[filename], patchset)
			for patch in patchset
				if patch.op is 'add'
					if patch.value not in self.taglist
						self.taglist.push patch.value
			res.status 204
			res.end()

	constructor : (@files, @taglist) ->
		@files or= {}
		@taglist or= []
		# @db = @files.map{
		@app = Express()
		@setupExpress()

	listen : (port) ->
		@app.listen(port)



