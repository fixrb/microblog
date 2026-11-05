#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/models/follow_spec"

# Alice follows Carol already. The subject is a new follow from Alice to the
# user of the handle, a parameter of the specification, validated.
exit(Fix[:Follow].test do
  empty_database
  %w[alice bob carol].each { |name| User.create!(handle: name) }
  alice = User.find_by!(handle: "alice")
  Follow.create!(follower: alice, followed: User.find_by!(handle: "carol"))
  Follow.new(follower: alice, followed: User.find_by!(handle:)).tap(&:validate)
end)
