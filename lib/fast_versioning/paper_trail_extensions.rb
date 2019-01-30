module FastVersioning
  module PaperTrailExtensions
    extend ActiveSupport::Concern

    included do
      after_create :create_fast_versions
      has_many :fast_versions, class_name: 'FastVersioning::FastVersion'
    end

    def create_fast_versions
      if item.respond_to?(:fast_version_for, true)
        value_change = FastVersioning::ValueChange.new(version: self)

        item.send(:fast_version_for).each do |tracked_attribute|
          name = tracked_attribute.name
          new_value = value_change.value_became(name)
          prev_value = value_change.value_was(name)

          # Skip if value unchanged.
          next if prev_value == new_value

          fast_versions.create(
            item_id: item_id,
            item_type: item_type,
            whodunnit_id: whodunnit&.to_i,
            whodunnit_type: whodunnit_type,
            name: name,
            value: new_value,
            prev_value: prev_value,
            meta: tracked_attribute.meta,
            created_at: created_at
          )
        end
      end
      true
    end

    def recreate_fast_versions!
      fast_versions.destroy_all
      create_fast_versions
    end
  end
end
