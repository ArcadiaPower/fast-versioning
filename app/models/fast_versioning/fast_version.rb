module FastVersioning
  class FastVersion < ActiveRecord::Base
    belongs_to :item, polymorphic: true
    belongs_to :whodunnit, polymorphic: true, optional: true
    belongs_to :version, class_name: 'PaperTrail::Version'

    serialize :meta, JSON
  end
end
