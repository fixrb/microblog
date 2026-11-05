#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../../lib/microblog"
require_relative "../../spec/microblog/handle_spec"

exit(Fix[:Handle].test { Microblog::Handle.new(text) })
