module FastVersioning
  class FastVersion < ActiveRecord::Base
    belongs_to :item, polymorphic: true
    belongs_to :whodunnit, polymorphic: true
    belongs_to :version, class_name: 'PaperTrail::Version'

    validates :version_id, uniqueness: { scope: :name }

    serialize :meta, JSON
  end
end
