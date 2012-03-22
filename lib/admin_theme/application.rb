require 'admin_theme/helpers/settings'

module AdminTheme
  class Application
    include Settings

    # The name of the application to be used in the page title and in the header.
    setting :application_name, "Application Administration"

    # The content in the footer area.
    setting :footer, "<p>Rails is running in the <strong>#{Rails.env}</strong> environment.</p>"

    setting :navigation_array, []

  end
end
