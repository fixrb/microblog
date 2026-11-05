# frozen_string_literal: true

require_relative "config/application"

Rails.application.load_tasks

desc "Run the tests of the fix directory"
task(:fix) { sh "fix" }

task default: :fix
