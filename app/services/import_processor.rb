# frozen_string_literal: true

require 'csv'

class ImportProcessor
  ALLOWED_HEADERS = %w[email first_name last_name date_of_birth import_id].freeze
  def initialize(import)
    @import_status = ImportStatus.new(import)
    @import = import
  end

  def call
    import_status.start

    with_tmp_file do |file|
      @file_path = file.path
      calculate_total(file.path)
      process(file.path)
    end

    import_status.finish
  end

  private

  attr_reader :import_status, :import

  def with_tmp_file(&block)
    import.file.attachment.open &block
  end

  def calculate_total(file_path)
    total = `wc -l < "#{file_path}"`.to_i - 1
    import_status.set_total(total)
  end

  def process(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      row = row.to_h.with_indifferent_access.merge(import_id: import.id)
      if row_valid?(row)
        Sidekiq.logger.info("Processing row #{row.inspect}")
        process_row(row)
      else
        import_status.increment_errors
        break
      end
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

  # FIXME
  def row_valid?(row)
    row.keys.sort == ALLOWED_HEADERS.sort
  end
end
