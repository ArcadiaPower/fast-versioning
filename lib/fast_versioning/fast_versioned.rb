module FastVersioning
  module FastVersioned
    extend ActiveSupport::Concern

    included do
      has_many :fast_versions, class_name: 'FastVersioning::FastVersion', as: :item
    end

    module ClassMethods
      def has_fast_versions(*attributes, **meta)
        define_method :fast_version_for do
          processed_meta = *meta.deep_dup.tap do |item|
            item.values.each do |v|
              v.each { |i,j| v[i] = j.call(self) if j.respond_to?(:call) }
            end
          end

          (attributes + processed_meta).map do |tracked|
            FastVersioning::TrackedAttribute.new(*tracked)
          end
        end
      end
    end

    def fast_versions_for(name)
      fast_versions.where(name: name)
    end
  end
end
