require 'admin_theme/engine'

module AdminTheme
  autoload :Application, 'admin_theme/application'

  # The instance of the configured application
  @@application = ::AdminTheme::Application.new
  mattr_accessor :application

  class << self

    # Gets called within the initializer
    def setup
      yield(application)
    end

  end

end
