# frozen_string_literal: true

require "fix"

# The response to Alice following the user of the handle: that user's profile,
# or not found.
Fix :FollowUser do
  let(:handle) { "bob" }

  on :status do
    it MUST eq 302
  end

  on :location do
    it MUST eq "http://example.org/users/bob"
  end

  with handle: "nobody" do
    on :status do
      it MUST eq 404
    end
  end
end
