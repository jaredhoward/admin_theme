require 'active_support/concern'

module AdminTheme
  module Settings
    extend ActiveSupport::Concern

    def read_default_setting(name)
      default_settings[name]
    end

    private

    def default_settings
      self.class.default_settings
    end

    module ClassMethods

      def setting(name, default)
        default_settings[name] = default
        attr_accessor(name)

        # Create an accessor that grabs from the defaults
        # if @name has not been set yet
        class_eval <<-EOC, __FILE__, __LINE__ + 1
          def #{name}
            if instance_variable_defined? :@#{name}
              @#{name}
            else
              read_default_setting(:#{name})
            end
          end
        EOC
      end

      def default_settings
        @default_settings ||= {}
      end

    end
  end
end
