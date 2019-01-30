class CreateFastVersioningFastVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :fast_versioning_fast_versions do |t|
      t.references :item, polymorphic: true, index: { name: 'fast_version_item_index' }
      t.references :whodunnit, polymorphic: true, index: { name: 'fast_version_whodunnit_index' }
      t.integer :version_id, index: { name: 'fast_version_version_id_index' }
      t.string :name, index: { name: 'fast_version_name_index' }
      t.string :prev_value, index: { name: 'fast_version_prev_value_index' }
      t.string :value, index: { name: 'fast_version_value_index' }
      t.text :meta
      t.datetime :created_at, index: { name: 'fast_version_created_at_index' }
    end
  end
end
