_ = require 'underscore'
fs = require 'fs'
path = require 'path'
Resolver = require './resolver'

module.exports = class ScriptResolver extends Resolver

  constructor: (path) -> super path
  
  _load: (event) ->
    self = @
    
    if not path.existsSync self._path
      self._destroy()
    else
      require.cache[self._path] = undefined
      imports = require self._path

      previous = Object.keys self
      current = Object.keys imports

      # current - previous = added
      current.forEach (member) ->
        self._set member, -> imports[member]
      
      # previous - current = removed
      _.without(previous,current).forEach (member) ->
        self._unset member
  