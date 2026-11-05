# frozen_string_literal: true

require "fix"

# The response to the home page for the visitor signed in with the
# handle, when Alice follows Bob but not Carol and the three of them
# posted: Alice reads her posts and Bob's; a visitor who is not signed
# in is sent to sign in.
Fix :Home do
  let(:handle) { "alice" }

  on :status do
    it MUST eq 200
  end

  on :body do
    it MUST match(/From Alice/)
    it MUST match(/From Bob/)
    it MUST_NOT match(/From Carol/)
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
