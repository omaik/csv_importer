# frozen_string_literal: true

class EnvironmentSettings < Settingslogic
  source "#{File.expand_path('.')}/config/environment.yml"
end
