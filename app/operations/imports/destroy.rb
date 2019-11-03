# frozen_string_literal: true

module Imports
  class Destroy < BaseOperation
    def initialize(import)
      @import = import
    end

    def call
      if import.destroy
        # handle customers deprovisioning?
        success(import)
      else
        error(import, import.errors.full_messages)
      end
    end

    private

    attr_reader :import
  end
end
