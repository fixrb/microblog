# frozen_string_literal: true

# The domain of the application: what a handle and the body of a post
# are, without Rails, a database or any other dependency. The Rails
# application requires this file; so do the tests of fix/microblog,
# which run on plain Ruby.
module Microblog
end

require_relative "microblog/handle"
require_relative "microblog/body"
