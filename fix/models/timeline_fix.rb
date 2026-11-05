#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/models/timeline_spec"

# Alice follows Bob, not Carol; the three of them posted, Bob first and Carol
# last. The subject is the bodies of Alice's timeline.
exit(Fix[:Timeline].test do
  empty_database
  alice, bob, carol = %w[alice bob carol].map { |name| User.create!(handle: name) }
  Follow.create!(follower: alice, followed: bob)
  bob.posts.create!(body: "From Bob", created_at: Time.utc(2026, 11, 5, 9, 0))
  alice.posts.create!(body: "From Alice", created_at: Time.utc(2026, 11, 5, 9, 1))
  carol.posts.create!(body: "From Carol", created_at: Time.utc(2026, 11, 5, 9, 2))
  alice.timeline.map(&:body)
end)
