# frozen_string_literal: true

require "fix"

# The response to signing in with the handle: home when it is valid, the
# form again when it is not.
Fix :SignIn do
  let(:handle) { "alice" }

  on :status do
    it MUST eq 302
  end

  on :location do
    it MUST eq "http://example.org/"
  end

  with handle: "Al Ice" do
    on :status do
      it MUST eq 422
    end

    on :body do
      it MUST match(/Handle is invalid/)
    end
  end
end
