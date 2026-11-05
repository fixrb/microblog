#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/models/post_spec"

# The subject is a new post of Alice with the body, a parameter of the
# specification, validated.
exit(Fix[:Post].test do
  empty_database
  User.create!(handle: "alice").posts.new(body:).tap(&:validate)
end)
