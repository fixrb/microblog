# frozen_string_literal: true

require "fix"

# The body of a post, built from a text: empty when it has nothing but spaces,
# too long beyond 280 characters, mentioning the handles after an at sign once
# each and in order, and nobody in an address.
Fix :Body do
  let(:text) { "Hello, @Alice and @bob! cc @bob" }

  on :to_s do
    it MUST eq "Hello, @Alice and @bob! cc @bob"
  end

  on :empty? do
    it MUST be_false
  end

  on :too_long? do
    it MUST be_false
  end

  on :valid? do
    it MUST be_true
  end

  on :mentions do
    it MUST eq %w[alice bob]
  end

  on :frozen? do
    it MUST be_true
  end

  with text: "   " do
    on :empty? do
      it MUST be_true
    end

    on :valid? do
      it MUST be_false
    end
  end

  with text: "a" * 280 do
    on :too_long? do
      it MUST be_false
    end

    on :valid? do
      it MUST be_true
    end
  end

  with text: "a" * 281 do
    on :too_long? do
      it MUST be_true
    end

    on :valid? do
      it MUST be_false
    end
  end

  with text: "Write to me@example.com, not to @a_handle_far_too_long" do
    on :mentions do
      it MUST eq []
    end
  end

  with text: "Ask @alicé, or é@bob" do
    on :mentions do
      it MUST eq []
    end
  end

  with text: nil do
    on :to_s do
      it MUST eq ""
    end

    on :empty? do
      it MUST be_true
    end
  end
end
