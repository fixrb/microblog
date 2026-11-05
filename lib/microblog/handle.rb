# frozen_string_literal: true

module Microblog
  # A handle names a user: one to fifteen lowercase letters, digits or
  # underscores. Surrounding spaces and uppercase letters are forgiven
  # on the way in, so that " Alice " names the same user as "alice".
  #
  #   handle = Microblog::Handle.new(" Alice ")
  #   handle.to_s   # => "alice"
  #   handle.valid? # => true
  class Handle
    # What a handle looks like once normalized.
    PATTERN = /\A[a-z0-9_]{1,15}\z/

    # @param text [#to_s] the handle as typed, or nil
    def initialize(text)
      @text = text.to_s.strip.downcase.freeze

      freeze
    end

    # @return [String] the normalized handle
    def to_s
      @text
    end

    # @return [Boolean] whether the normalized handle may name a user
    def valid?
      PATTERN.match?(@text)
    end
  end
end
