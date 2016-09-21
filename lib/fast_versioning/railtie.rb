class FastVersioning::Railtie < Rails::Railtie
  config.to_prepare do
    require 'paper_trail'

    PaperTrail::Version.module_eval do
      include FastVersioning::PaperTrailExtensions
    end
  end
end
