#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/controllers/users_spec"

# Alice follows Bob, who posted; Carol exists. The subject is the response to
# the profile of the handle, a parameter of the specification, for Alice.
exit(Fix[:Profile].test do
  empty_database
  alice, bob = %w[alice bob].map { |name| User.create!(handle: name) }
  User.create!(handle: "carol")
  Follow.create!(follower: alice, followed: bob)
  bob.posts.create!(body: "From Bob")
  browser(as: "alice").get("/users/#{handle}")
end)
