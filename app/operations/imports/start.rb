# frozen_string_literal: true

module Imports
  class Start < BaseOperation
    def initialize(import)
      @import = import
    end

    def call
      schedule_import_job
      import.pending!
      success(import)
    rescue StandardError => e
      Rails.logger.error("Exception during import start: #{e.message}")
      error(import, [e.message])
    end

    private

    attr_reader :import

    def schedule_import_job
      ImportJob.perform_async(import.id)
    end
  end
end
