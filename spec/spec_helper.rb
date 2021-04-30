ENV['RAILS_ENV'] ||= 'test'
require 'rubygems'
require 'rails/all'
require 'bundler/setup'
require 'fast_versioning'
require 'paper_trail'
require 'timecop'
require File.expand_path('app/models/fast_versioning/fast_version.rb')
require File.expand_path('../db/migrate/20160914161314_create_fast_versioning_fast_versions.rb', __dir__)
require File.expand_path('../db/migrate/20190514134359_add_unique_index_to_version_id_name', __dir__)

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.mock_with :rspec
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  PaperTrail.enabled = true

  config.before(:suite) do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Schema.define do
      create_table 'versions', force: :cascade do |t|
        t.string   'item_type'
        t.integer  'item_id'
        t.string   'event'
        t.string   'whodunnit'
        t.text     'object'
        t.datetime 'created_at'
        t.text     'object_changes'
        t.integer  'user_id'
        t.string   'whodunnit_type'
      end

      create_table(:dummy_models) do |t|
        t.string :status
        t.string :complex
        t.integer :number
        t.timestamps :null => false
      end

      CreateFastVersioningFastVersions.new.change
      AddUniqueIndexToVersionIdName.new.change
    end

    # Rails would normally automatically load this.
    require 'paper_trail/frameworks/active_record'

    PaperTrail::Version.module_eval do
      include FastVersioning::PaperTrailExtensions
    end

    class DummyModel < ActiveRecord::Base
      has_paper_trail
      include FastVersioning::FastVersioned

      has_fast_versions(
        :status,
        :number,
        complex: {
          store_me: Proc.new { |dummy_model| dummy_model.get_value },
          other_thing: 'some string'
        }
      )

      def get_value
        versions.count
      end
    end
  end
end
