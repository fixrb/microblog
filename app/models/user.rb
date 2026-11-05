# frozen_string_literal: true

# A user, named by a handle. What a handle is belongs to the domain,
# Microblog::Handle; this record stores one and keeps it unique.
class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  has_many :active_follows,
           class_name: "Follow", foreign_key: :follower_id, inverse_of: :follower, dependent: :destroy
  has_many :passive_follows,
           class_name: "Follow", foreign_key: :followed_id, inverse_of: :followed, dependent: :destroy

  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  normalizes :handle, with: ->(handle) { Microblog::Handle.new(handle).to_s }

  validates :handle, uniqueness: true
  validate :handle_is_valid

  # The handle names the user in URLs: /users/alice.
  def to_param
    handle
  end

  # @return [Boolean] whether this user follows that one
  def follows?(user)
    active_follows.exists?(followed: user)
  end

  # The posts of this user and of those they follow, newest first.
  def timeline
    Post.newest_first.includes(:user).where(user_id: [id, *following_ids])
  end

  private

  def handle_is_valid
    errors.add(:handle, :invalid) unless Microblog::Handle.new(handle).valid?
  end
end
