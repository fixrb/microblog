# frozen_string_literal: true

# A post: a user and a body. What a body may say belongs to the domain,
# Microblog::Body; this record stores one and asks it before saving.
class Post < ApplicationRecord
  belongs_to :user

  scope :newest_first, -> { order(created_at: :desc, id: :desc) }

  validate :body_is_valid

  # @return [Array<String>] the handles the body mentions
  def mentions
    Microblog::Body.new(body).mentions
  end

  private

  def body_is_valid
    text = Microblog::Body.new(body)

    errors.add(:body, :blank) if text.empty?
    errors.add(:body, :too_long, count: Microblog::Body::MAXIMUM) if text.too_long?
  end
end
