require 'bundler'; Bundler.require :development, :test
require "active_support/test_case"

require 'rails-force-reload'
require 'fixtures/active_record'
require 'minitest/autorun'

class RFRTestCase < ActiveSupport::TestCase

  include Fixtures::ActiveRecord

  def setup
    setup_schema
    Firm.connection
  end

end

