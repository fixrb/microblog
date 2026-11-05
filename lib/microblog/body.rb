# frozen_string_literal: true

module Microblog
  # The text of a post. A body is empty when it has nothing but spaces, too
  # long beyond MAXIMUM characters, and mentions the users whose handle
  # follows an at sign, as "@alice" does, once each and in order of
  # appearance. The at sign of an address, as in "me@example.com", mentions
  # nobody.
  #
  #   body = Microblog::Body.new("Hello, @Alice and @bob! cc @bob")
  #   body.valid?   # => true
  #   body.mentions # => ["alice", "bob"]
  class Body
    # The number of characters a body may have.
    MAXIMUM = 280

    # An at sign, then a handle, with neither a letter nor a digit of any
    # script against them: "me@example.com" and "@alicé" mention nobody.
    MENTION = /(?<![[:alnum:]_])@(\w+)(?![[:alnum:]])/

    # @param text [#to_s] the text of the post, or nil
    def initialize(text)
      @text = text.to_s.freeze

      freeze
    end

    # @return [String] the text as given
    def to_s
      @text
    end

    # @return [Boolean] whether the text has nothing but spaces
    def empty?
      @text.strip.empty?
    end

    # @return [Boolean] whether the text has more than MAXIMUM characters
    def too_long?
      @text.length > MAXIMUM
    end

    # @return [Boolean] whether the text may be posted
    def valid?
      !empty? && !too_long?
    end

    # @return [Array<String>] the valid handles mentioned, once each, in order
    def mentions
      handles = @text.scan(MENTION).flatten.map { |name| Handle.new(name) }

      handles.select(&:valid?).map(&:to_s).uniq
    end
  end
end
