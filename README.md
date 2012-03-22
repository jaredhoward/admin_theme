# AdminTheme
AdminTheme is an Engine based gem that is used to have the same styling of ActiveAdmin without all the clutter.

## Getting Started
AdminTheme is released as a Ruby Gem for Rails 3.1+. To install, simply add the following to your Gemfile:

    gem 'admin_theme', :git => 'git@github.com:jaredhoward/admin_theme.git'

Currently, AdminTheme is not published on RubyGems, so pointing directly to the GitHub repository is necessary.

## Configuring AdminTheme
It may be easiest to configure AdminTheme inside an initializer in your application.

    # config/initializers/admin_theme.rb
    AdminTheme.setup do |config|
      config._______
    end

The configuration options are:

* application_name
  * This is used on each page showing the name of the site.
  * string, default: 'Application Administration'
* footer
  * This is the content that displayed in the footer container.
  * string, default: "&lt;p>Rails is running in the &lt;strong>#{Rails.env}&lt;/strong> environment.&lt;/p>"
* navigation_array
  * This is the array used to set up the navigational menu.
  * array, default: []
  * Each item inside the array must also be an array and follows this format:

            [link name, link url, nested array (optional)]
    The nested array follows the same format as the navigation_array.

## View Helpers

### Methods
The following helper methods allow you to setup your view templates and the data being displayed within the layout styles.

#### `panel_attributes(object, attributes=[], options={})`
This displays a panel with attributes describing an object.

* `object` is the object that is being described in this panel
* `attributes` is an array of attributes to be used. See common variables below for the format.
* `options` is a hash of options that are used to configure the panel
  * `title` is the name of panel. Defaults to the object name.

### Common Variables

#### `attributes` as used in `panel_attributes`
An array of attributes to be used. Each attribute in the array is formatted as follows:

* If the attribute is a string or symbol, then no further object describing is needed and the attribute is simple used.
* If the attribute is an array, it follows the format of:

        [attribute name, attribute hash]
  * `attribute name` is a string or symbol used as mentioned above, or at a minimum use of class values.
  * `attribute hash` can describe the attribute further:
    * `value` can either be the actual value that will be used or a Proc that can be called against the object to produce the value.
    * `collection` can be an array of arrays that will be compared with rassoc() to the value to produce the value to be displayed.
    * `label` is a string to specifically describe the attribute's name.
