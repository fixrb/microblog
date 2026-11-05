# frozen_string_literal: true

require "fix"

# A user, built from a handle, when "bob" is taken already: the handle
# is normalized, must be valid, and must be free.
Fix :User do
  let(:handle) { "alice" }

  on :valid? do
    it MUST be_true
  end

  on :handle do
    it MUST eq "alice"
  end

  on :to_param do
    it MUST eq "alice"
  end

  with handle: " Alice " do
    on :handle do
      it MUST eq "alice"
    end

    on :valid? do
      it MUST be_true
    end
  end

  with handle: "al ice" do
    on :valid? do
      it MUST be_false
    end
  end

  with handle: "bob" do
    on :valid? do
      it MUST be_false
    end

    on :errors do
      on :full_messages do
        it MUST eq ["Handle has already been taken"]
      end
    end
  end
end
