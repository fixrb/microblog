# frozen_string_literal: true

require "fix"

# The response to posting the body, for the visitor signed in with the handle:
# home when the post is saved, the form again with the reason when it is not,
# the sign-in page for a visitor who is not signed in.
Fix :CreatePost do
  let(:handle) { "alice" }
  let(:body) { "Hello, world!" }

  on :status do
    it MUST eq 302
  end

  on :location do
    it MUST eq "http://example.org/"
  end

  with body: "a" * 281 do
    on :status do
      it MUST eq 422
    end

    on :body do
      it MUST match(/Body is too long/)
    end
  end

  with handle: nil do
    on :status do
      it MUST eq 302
    end

    on :location do
      it MUST eq "http://example.org/session/new"
    end
  end
end
