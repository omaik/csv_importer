# frozen_string_literal: true

class ImportStatus
  def initialize(import)
    @import = import
  end

  def self.build(import)
    new(import).tap(&:build_import_stats)
  end

  def self.find(import)
    new(import)
  end

  def start
    import.started!
  end

  def finish
    import.completed!
    import.update(processed: import_stats.get_processed, errors_count: import_stats.get_errors_count)
  end

  def set_total(total)
    import.update_attribute(:total_count, total)
  end

  def increment
    import_stats.increment_processed
  end

  def build_import_stats
    @import_stats = ImportStats.new(import)
  end

  def increment_errors
    import_stats.increment_errors_count
  end

  private

  attr_reader :import_stats, :import
end
