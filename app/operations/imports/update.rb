module Imports
  class Update < BaseOperation
    def initialize(import, params)
      @import = import
      @params = params
    end

    def call
      if import.update(params)
        success(import)
      else
        error(import, import.errors.full_messages)
      end
    end

    private

    attr_reader :import, :params
  end
end
