module Imports
  class Create < BaseOperation
    def initialize(params)
      @params = params
    end

    def call
      import = Import.new(params)

      if import.save
        success(import)
      else
        error(import, import.errors.full_messages)
      end
    end

    private

    attr_reader :params
  end
end
