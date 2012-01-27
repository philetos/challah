# Coverage reporting, needs to be loaded first to capture all code coverage stats
require 'simplecov'

# Setup a sample rails app for testing rails modules
sample_root = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp', 'sampleapp'))
FileUtils.rm_rf(sample_root) if File.exists?(sample_root)
`rails new #{sample_root} --skip-bundle --skip-sprockets`

# Setup environment variables for the Rails instance
ENV['RAILS_ENV'] = 'test'
ENV['BUNDLE_GEMFILE'] ||= File.join(sample_root, 'Gemfile')

# Load the newly created rails instance environment
require "#{sample_root}/config/environment"

# Some other dependencies for testing w/ shoulda and factory girl
require 'shoulda/rails'
require 'mocha'
require 'factory_girl'
require 'factories'

# Load the auth libraries
require 'auth'

# Setup the auth app, including running migrations within the rails app
`rake --rakefile #{ File.join(sample_root, 'Rakefile')} auth:setup`

# Monkey patch fix for shoulda and Rails 3.1+.
module Shoulda
  module ActiveRecord
    module Matchers
      class AssociationMatcher
        protected
          def foreign_key
            reflection.foreign_key
          end
      end
    end
  end
end