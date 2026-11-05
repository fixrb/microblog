#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/models/user_spec"

# Bob exists already. The subject is a new user with the handle, a parameter
# of the specification, validated.
exit(Fix[:User].test do
  empty_database
  User.create!(handle: "bob")
  User.new(handle:).tap(&:validate)
end)
