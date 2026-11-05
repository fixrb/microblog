#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/controllers/follows_spec"

# The subject is the response to Alice following the user of the handle, a
# parameter of the specification.
exit(Fix[:FollowUser].test do
  empty_database
  %w[alice bob].each { |name| User.create!(handle: name) }
  browser(as: "alice").post("/users/#{handle}/follow")
end)
