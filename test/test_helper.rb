require 'bundler'; Bundler.require :development, :test
require "active_support/test_case"
require 'coveralls'
Coveralls.wear!

require 'rails-force-reload'
require 'fixtures/active_record'

class RFRTestCase < ActiveSupport::TestCase

  include Fixtures::ActiveRecord

  def setup
    setup_schema
    Firm.connection
  end

end

