class AddUniqueIndexToVersionIdName < ActiveRecord::Migration[5.0]
  def change
    add_index :fast_versioning_fast_versions, %i[version_id name], unique: true
  end
end
