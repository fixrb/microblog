# frozen_string_literal: true

require "fix"

# The response to the profile of the handle, for Alice, who follows Bob: his
# posts and a button to unfollow him, a button to follow Carol, no button on
# her own profile, not found for nobody.
Fix :Profile do
  let(:handle) { "bob" }

  on :status do
    it MUST eq 200
  end

  on :body do
    it MUST match(/@bob/)
    it MUST match(/From Bob/)
    it MUST match(/Unfollow/)
  end

  with handle: "carol" do
    on :body do
      it MUST match(/>Follow</)
    end
  end

  with handle: "alice" do
    on :body do
      it MUST_NOT match(/Follow</)
    end
  end

  with handle: "nobody" do
    on :status do
      it MUST eq 404
    end
  end
end
