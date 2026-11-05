# frozen_string_literal: true

require "fix"

# A follow from Alice, who follows Carol already, to the user of the handle:
# not herself, and not Carol twice.
Fix :Follow do
  let(:handle) { "bob" }

  on :valid? do
    it MUST be_true
  end

  with handle: "alice" do
    on :valid? do
      it MUST be_false
    end

    on :errors do
      on :full_messages do
        it MUST eq ["This user is you"]
      end
    end
  end

  with handle: "carol" do
    on :valid? do
      it MUST be_false
    end

    on :errors do
      on :full_messages do
        it MUST eq ["This user is already followed"]
      end
    end
  end
end
