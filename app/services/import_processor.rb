# frozen_string_literal: true

require 'csv'

class ImportProcessor
  ALLOWED_HEADERS = %w[
    email
    first_name
    last_name
    date_of_birth
  ].freeze
  def initialize(import)
    @import_status = ImportStatus.new(import)
    @import = import
  end

  def call
    import_status.start

    perform_import

    import_status.finish
  end

  private

  attr_reader :import_status, :import, :file_path

  def perform_import
    with_tmp_file do |file|
      @file_path = file.path
      if valid_headers?
        calculate_total
        process
      else
        import_status.increment_errors
      end
    end
  end

  def with_tmp_file(&block)
    import.file.attachment.open(&block)
  end

  def valid_headers?
    headers = CSV.foreach(file_path).first

    headers.sort == ALLOWED_HEADERS.sort
  end

  def calculate_total
    total = `wc -l < "#{file_path}"`.to_i - 1
    import_status.total(total)
  end

  def process
    CSV.foreach(file_path, headers: true) do |row|
      row = row.to_h.with_indifferent_access.merge(import_id: import.id)
      Sidekiq.logger.info("Processing row #{row.inspect}")
      process_row(row)
    end
  end

  def process_row(row)
    result = Customers::Provision.new(row).call

    if result[:success]
      import_status.increment
    else
      import_status.increment_errors
    end
  end
end
