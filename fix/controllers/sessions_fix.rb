#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/controllers/sessions_spec"

# The subject is the response to signing in with the handle, a parameter of
# the specification.
exit(Fix[:SignIn].test do
  empty_database
  browser.post("/session", handle:)
end)
