#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../support/rails"
require_relative "../../spec/controllers/posts_spec"

# The subject is the response to posting the body, for the visitor
# signed in with the handle; both are parameters of the specification.
exit(Fix[:CreatePost].test do
  empty_database
  User.create!(handle: "alice")
  browser(as: handle).post("/posts", post: { body: })
end)
