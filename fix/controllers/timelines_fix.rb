#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/controllers/timelines_spec"

# Alice follows Bob, not Carol, and the three of them posted. The subject is
# the response to the home page, for the visitor signed in with the handle, a
# parameter of the specification.
exit(Fix[:Home].test do
  empty_database
  alice, bob, carol = %w[alice bob carol].map { |name| User.create!(handle: name) }
  Follow.create!(follower: alice, followed: bob)
  alice.posts.create!(body: "From Alice")
  bob.posts.create!(body: "From Bob")
  carol.posts.create!(body: "From Carol")
  browser(as: handle).get("/")
end)
