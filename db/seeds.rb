# frozen_string_literal: true

# Three users, a few posts and a follow, for a first look at the application:
#
#   bin/rails db:seed
#
alice, bob, carol = %w[alice bob carol].map { |handle| User.find_or_create_by!(handle:) }

Follow.find_or_create_by!(follower: alice, followed: bob)

alice.posts.find_or_create_by!(body: "Hello, world!")
bob.posts.find_or_create_by!(body: "Good morning, @alice.")
carol.posts.find_or_create_by!(body: "Nobody follows me yet.")
