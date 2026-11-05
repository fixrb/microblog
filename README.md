# Microblog

A small Ruby on Rails application, specified and tested with [Fix](https://github.com/fixrb/fix). Users pick a handle, post short texts, follow one another and read a timeline: enough of a microblog to show Fix at work on the three layers of a Rails application, and nothing more.

## Running it

Ruby 3.3 or later, on a system with `fork`.

```console
$ bundle install
$ bin/rails db:prepare
$ bundle exec fix
```

`bin/rails db:prepare` creates the development and the test databases. `fix` then runs every `*_fix.rb` file of the `fix` directory, each in a process of its own, writes one line per expectation, pointing at its line in the specification, and exits with 0 when every file is met. `bundle exec rake` does the same. The files are executable, so one of them runs on its own: `fix/models/follow_fix.rb`.

For a look at the application itself, `bin/rails db:seed` creates three users and a few posts, and `bin/rails server` serves it at `http://localhost:3000`. Signing in is picking a handle: there are no passwords in this example.

## Specifications and tests

With Fix, a specification says what a subject MUST, SHOULD or MAY do, and nothing about how the subject is made; a test builds a subject and tests it against the specification. This application keeps the two apart:

- `spec/` holds the specifications, one per file, each a `Fix :Name do … end` document. They require Fix and nothing else: no Rails, no database, not even the code they specify. `spec` is the word of Fix here, not of RSpec, which this application does not use.
- `fix/` holds the tests, the `*_fix.rb` files the `fix` command runs. Each loads what its subject needs, requires its specification, and ends with `exit(Fix[:Name].test { … })`, the block building the subject.

The `let` of a specification is a parameter of the subject: the specification declares it, with a default and the `with` that vary it, and the block of the test reads it by name. So the same words serve a plain Ruby object, an Active Record model and an HTTP response; only the test changes.

### The domain, without Rails

`lib/microblog` is the domain: two value objects, immutable and deterministic, with no dependency at all. `Microblog::Handle` says what a handle is, and normalizes the one typed; `Microblog::Body` says what a post may say, and finds the users it mentions.

```ruby
# spec/microblog/body_spec.rb, abridged
require "fix"

Fix :Body do
  let(:text) { "Hello, @Alice and @bob! cc @bob" }

  on :valid? do
    it MUST be_true
  end

  on :mentions do
    it MUST eq %w[alice bob]
  end

  with text: "a" * 281 do
    on :valid? do
      it MUST be_false
    end
  end
end
```

```ruby
# fix/microblog/body_fix.rb
require_relative "../../lib/microblog"
require_relative "../../spec/microblog/body_spec"

exit(Fix[:Body].test { Microblog::Body.new(text) })
```

Neither file loads Rails or a database: the test runs in a tenth of a second. The library is required by `config/application.rb` as a gem would be, and left out of autoloading, so that its files stay loadable on their own.

### The models

`app/models` holds three Active Record models. `User` and `Post` delegate to the domain what belongs to it: a handle is normalized by `Microblog::Handle` and a body judged by `Microblog::Body`. What is relational stays in the models, next to the database that enforces it: a handle is unique, a user follows another once and never themselves, and a timeline is a query.

Their tests load the application in its test environment through `fix/support/rails.rb`. Fix builds the subject anew for every expectation, in a child process; Active Record forgets the connections of the parent after a fork, so each child gets a connection of its own. The database is outside the processes, though, so a subject begins by emptying it. Nothing is wrapped in a transaction, and nothing is rolled back.

```ruby
# spec/models/follow_spec.rb, abridged
Fix :Follow do
  let(:handle) { "bob" }

  on :valid? do
    it MUST be_true
  end

  with handle: "alice" do
    on :errors do
      on :full_messages do
        it MUST eq ["This user is you"]
      end
    end
  end
end
```

```ruby
# fix/models/follow_fix.rb
require_relative "../support/rails"
require_relative "../../spec/models/follow_spec"

exit(Fix[:Follow].test do
  empty_database
  %w[alice bob carol].each { |name| User.create!(handle: name) }
  alice = User.find_by!(handle: "alice")
  Follow.create!(follower: alice, followed: User.find_by!(handle: "carol"))
  Follow.new(follower: alice, followed: User.find_by!(handle:)).tap(&:validate)
end)
```

### The controllers

The subject of a controller test is a response. `browser(as: "alice")` gives a `Rack::Test::Session` for the application, signed in; its requests return a `Rack::MockResponse`, with a status, a body and a location. Rack::Test is a dependency of Action Pack, so nothing else is needed.

```ruby
# spec/controllers/posts_spec.rb, abridged
Fix :CreatePost do
  let(:handle) { "alice" }
  let(:body) { "Hello, world!" }

  on :status do
    it MUST eq 302
  end

  with body: "a" * 281 do
    on :status do
      it MUST eq 422
    end
  end

  with handle: nil do
    on :location do
      it MUST eq "http://example.org/session/new"
    end
  end
end
```

```ruby
# fix/controllers/posts_fix.rb
require_relative "../support/rails"
require_relative "../../spec/controllers/posts_spec"

exit(Fix[:CreatePost].test do
  empty_database
  User.create!(handle: "alice")
  browser(as: handle).post("/posts", post: { body: })
end)
```

## Layout

```text
lib/microblog/           the domain: Handle, Body
app/models/              User, Post, Follow
app/controllers/         Sessions, Timelines, Posts, Users, Follows
spec/microblog/          specifications of the domain
spec/models/             specifications of the models
spec/controllers/        specifications of the controllers
fix/microblog/           tests of the domain, on plain Ruby
fix/models/              tests of the models
fix/controllers/         tests of the controllers
fix/support/rails.rb     loads the application for the last two
```

## What this example leaves out

Passwords, pagination, JavaScript, CSS beyond a few lines in the layout, and any test framework other than Fix. A Rails application that needs Minitest alongside Fix can have it: `fix` reads its own directory and nothing else.

## License

The code is available as open source under the terms of the [MIT License](https://github.com/fixrb/microblog/raw/main/LICENSE.md).

## Sponsors

This project is sponsored by [Sashité](https://sashite.com/).
