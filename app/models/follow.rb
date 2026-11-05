# frozen_string_literal: true

# One user following another: once, and never themselves. These rules
# are relational, so they live here, next to the unique index that
# enforces the first one in the database.
class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", inverse_of: :active_follows
  belongs_to :followed, class_name: "User", inverse_of: :passive_follows

  validates :followed_id, uniqueness: { scope: :follower_id }
  validate :followed_is_someone_else

  private

  def followed_is_someone_else
    errors.add(:followed, :oneself) if followed && followed == follower
  end
end
