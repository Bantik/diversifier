require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'debugger'
require 'mongoid'
require 'active_support'
require 'active_support/core_ext'

Bundler.require

Mongoid.load!("mongoid.yml", :development)

module Diversifier
  
  require_relative 'diversifier/group'
  require_relative 'diversifier/iteration'
  require_relative 'diversifier/project'
  require_relative 'diversifier/simulator'

end
