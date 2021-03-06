module Challah
  require 'abstract_controller/rendering'

  class Engine < Rails::Engine
    initializer 'challah.router' do |app|
      app.routes_reloader.paths.insert(0, File.expand_path(File.join(File.dirname(__FILE__), 'routes.rb')))
    end

    initializer 'challah.active_record' do |app|
      ActiveSupport.on_load :active_record do
        Challah::Engine.setup_active_record!
      end
    end

    initializer 'challah.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        Challah::Engine.setup_action_controller!
      end
    end

    class << self
      # Set up controller methods
      def setup_action_controller!
        if defined?(ActionController)
          ActionController::Base.send(:include, Challah::Controller)
          ActionController::Base.send(:helper_method,
            :current_user_session,
            :current_user,
            :current_user?,
            :logged_in?,
            :signed_in?
          )
        end
      end

      # Set up active record with Challah methods
      def setup_active_record!
        if defined?(ActiveRecord)
          Challah.options[:logger] = ActiveRecord::Base.logger

          ActiveRecord::Base.send(:extend, Challah::User)
          ActiveRecord::Base.send(:include, Challah::Audit)
        end
      end
    end
  end
end