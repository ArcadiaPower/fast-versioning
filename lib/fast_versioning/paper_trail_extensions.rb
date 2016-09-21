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
          if value_change.value_was(tracked_attribute.name) != value_change.value_became(tracked_attribute.name)
            fast_versions.create(
              item_id: item_id,
              item_type: item_type,
              whodunnit_id: whodunnit.to_i,
              whodunnit_type: whodunnit_type,
              name: tracked_attribute.name,
              value: value_change.value_became(tracked_attribute.name),
              prev_value: value_change.value_was(tracked_attribute.name),
              meta: tracked_attribute.meta,
              created_at: created_at
            )
          end
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
