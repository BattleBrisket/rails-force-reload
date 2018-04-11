module Fixtures
  module ActiveRecord

    private

    def setup_schema
      ::ActiveRecord::Base.class_eval do
        connection.instance_eval do

          create_table :firms, force: true do |t|
            t.string :name
            t.timestamps
          end

          create_table :clients, force: true do |t|
            t.integer :firm_id
            t.string :name
            t.timestamps
          end

          create_table :users, force: true do |t|
            t.integer :firm_id
            t.string :name
            t.timestamps
          end

        end
      end
    end

    class Firm < ::ActiveRecord::Base
      has_many :clients
      has_one :user
    end

    class Client < ::ActiveRecord::Base
      belongs_to :firm
    end

    class User < ::ActiveRecord::Base
      belongs_to :firm
    end

  end
end

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
