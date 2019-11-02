# frozen_string_literal: true

class ImportProcessor
  def initialize(import)
    @import_status = ImportStatus.build(import)
    @import = import
  end

  def call
    import_status.start

    with_tmp_file do |file|
      count_total(file.path)
      process(file.path)
    end

    import_status.finish
  end

  private

  attr_reader :import_status

  def with_tmp_file(&block)
    import.file.attachment.open &block
  end

  def calculate_total(file_path)
    total = %x[wc -l < "#{file_path}"].to_i - 1
    import_status.set_total(total)
  end

  def process(file_path)
    FastestCSV.foreach(file_path) do |row|
      if row_valid?(row)
        process_row(row)
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
end
