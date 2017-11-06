module FastVersioning
  class Engine < ::Rails::Engine
    isolate_namespace FastVersioning

    PaperTrail.config.track_associations = false
  end
end
