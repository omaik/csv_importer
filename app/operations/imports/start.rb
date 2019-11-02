# frozen_string_literal: true

module Imports
  class Start < BaseOperation
    def initialize(import_id)
      @import = Import.find(import_id)
    end

    def call
      import.pending!
      schedule_import_job
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
