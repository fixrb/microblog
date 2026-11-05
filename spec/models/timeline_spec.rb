# frozen_string_literal: true

require "fix"

# The bodies of Alice's timeline, when she follows Bob but not Carol and
# the three of them posted, Bob first and Carol last: hers and Bob's,
# newest first.
Fix :Timeline do
  it MUST eq ["From Alice", "From Bob"]

  on :first do
    it MUST eq "From Alice"
  end

  on :include?, "From Carol" do
    it MUST be_false
  end
end
