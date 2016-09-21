module FastVersioning
  class TrackedAttribute
    attr_reader :name, :meta

    def initialize(name, meta = nil)
      @name = name
      @meta = meta
    end
  end
end
