# frozen_string_literal: true

require "fix"

# A handle, built from a text: one to fifteen lowercase letters, digits
# or underscores once spaces and case are forgiven.
Fix :Handle do
  let(:text) { "alice" }

  on :to_s do
    it MUST eq "alice"
  end

  on :valid? do
    it MUST be_true
  end

  on :frozen? do
    it MUST be_true
  end

  with text: " Alice " do
    on :to_s do
      it MUST eq "alice"
    end

    on :valid? do
      it MUST be_true
    end
  end

  with text: "alice_in_wonderland" do
    on :valid? do
      it MUST be_false
    end
  end

  with text: "al-ice" do
    on :valid? do
      it MUST be_false
    end
  end

  with text: "" do
    on :valid? do
      it MUST be_false
    end
  end

  with text: nil do
    on :to_s do
      it MUST eq ""
    end

    on :valid? do
      it MUST be_false
    end
  end
end
