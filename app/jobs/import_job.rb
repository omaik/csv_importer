# frozen_string_literal: true

class ImportJob
  include Sidekiq::Worker

  def perform(import_id)
    import = Import.find(import_id)
  end
end
