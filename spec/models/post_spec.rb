# frozen_string_literal: true

require "fix"

# A post, built from a body: it mentions the handles of the body, and
# says why an empty or an overlong body is refused.
Fix :Post do
  let(:body) { "Good morning, @bob and @carol." }

  on :valid? do
    it MUST be_true
  end

  on :mentions do
    it MUST eq %w[bob carol]
  end

  with body: "" do
    on :valid? do
      it MUST be_false
    end

    on :errors do
      on :full_messages do
        it MUST eq ["Body can't be blank"]
      end
    end
  end

  with body: "a" * 281 do
    on :valid? do
      it MUST be_false
    end

    on :errors do
      on :full_messages do
        it MUST eq ["Body is too long (maximum is 280 characters)"]
      end
    end
  end
end
