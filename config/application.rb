# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# The domain is a plain Ruby library, required here as a gem would be, and
# left out of autoloading: its files load without Rails.
require_relative "../lib/microblog"

module Microblog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
