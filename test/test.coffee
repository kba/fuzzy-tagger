test  = require 'tapes'
Fuzzy = require 'fuzzy'
Fs    = require 'fs'

TaggingServer = require '../src/TaggingServer'

# DEBUG=false
DEBUG=true

testFunc = (t) ->
	list = Fs.readFileSync('data/tags.list', 'utf8').split("\n")
	list.pop()
	console.log list
	results = Fuzzy.filter 'an', list
	console.log results
	t.end()

testServer = (t) ->
	srv = new TaggingServer()
	srv.listen 3000

# test "Basic async each test", testFunc
test "TagginServer", testServer

# ALT: src/index.coffee
