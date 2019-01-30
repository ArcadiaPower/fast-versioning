require File.expand_path('../../db/migrate/20160914161314_create_fast_versioning_fast_versions.rb', __dir__)

describe 'fast_versioned' do
  before do
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
    end

    # Rails would normally automatically load this.
    require 'paper_trail/frameworks/active_record'

    PaperTrail::Version.module_eval do
      include FastVersioning::PaperTrailExtensions
    end

    class DummyModel < ActiveRecord::Base
      has_paper_trail
      include FastVersioning::FastVersioned

      has_fast_versions :status,
                        :number,
                        complex: { store_me: Proc.new { |dummy_model| dummy_model.get_value },
                                   other_thing: 'some string' }

      def get_value
        versions.count
      end
    end
  end

  describe 'injects associations to model' do
    it 'should have fast_versions association' do
      expect(DummyModel.new).to respond_to(:fast_versions)
    end
  end

  describe 'after_commit callback' do
    it 'creates fast versions' do
      item = DummyModel.create(status: 'incomplete')
      expect(FastVersioning::FastVersion.last.value).to eq('incomplete')
      expect(FastVersioning::FastVersion.last.prev_value).to eq(nil)
      expect(FastVersioning::FastVersion.last.version_id).to eq(PaperTrail::Version.last.id)

      item.update(status: 'active')
      expect(FastVersioning::FastVersion.last.value).to eq('active')
      expect(FastVersioning::FastVersion.last.prev_value).to eq('incomplete')
    end

    context 'for numeric value' do
      it 'stores value as string' do
        DummyModel.create(number: 12)
        expect(FastVersioning::FastVersion.last.value).to eq('12')
      end
    end

    context 'for hash argument' do
      it 'stores serialized data' do
        item = DummyModel.create(complex: 'yes')
        expect(FastVersioning::FastVersion.last.meta['store_me']).to eq(1)
        expect(FastVersioning::FastVersion.last.meta['other_thing']).to eq('some string')
        item.update(complex: 'no')
        expect(FastVersioning::FastVersion.last.meta['store_me']).to eq(2)
      end
    end
  end

  describe 'fast_versions_for' do
    it 'returns property versions' do
      item = DummyModel.create(status: 'incomplete', number: 12)
      item.update(status: 'active', number: 15)
      expect(item.fast_versions_for(:number).pluck(:value)).to eq(['12', '15'])
    end
  end
end
