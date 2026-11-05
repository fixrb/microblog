#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../../lib/microblog"
require_relative "../../spec/microblog/body_spec"

exit(Fix[:Body].test { Microblog::Body.new(text) })
