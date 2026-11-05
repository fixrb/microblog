# frozen_string_literal: true

# Loads the application in its test environment, for the tests of the models
# and of the controllers. Those of the domain, in fix/microblog, need none of
# this: they run on plain Ruby. The specifications, in spec, need nothing but
# Fix.
#
# The tests empty the database, so they run in the test environment and
# nowhere else, whatever the shell says.
ENV["RAILS_ENV"] = "test"

require_relative "../../config/environment"
require "rack/test"

# Keeps the test database in step with db/schema.rb, as rails/test_help does.
ActiveRecord::Migration.maintain_test_schema!

# Fix builds the subject anew for every expectation, in a child process of its
# own, which gets a connection of its own: Active Record forgets the pool of
# the parent after a fork. The database itself is outside the processes, so a
# subject starts by emptying it. Nothing is rolled back; nothing needs to be.
def empty_database
  Follow.delete_all
  Post.delete_all
  User.delete_all
end

# A browser for the application, with its cookies, signed in as the user of
# that handle when one is given. Its requests return a Rack::MockResponse,
# with a status, a body and a location.
def browser(as: nil)
  visitor = Rack::Test::Session.new(Rails.application)
  visitor.post("/session", handle: as) if as
  visitor
end
