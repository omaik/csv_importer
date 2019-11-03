# frozen_string_literal: true

class ImportStatus
  def initialize(import)
    @import = import
    @import_stats = build_import_stats
  end

  def start
    import.update(
      status: :started,
      started_at: Time.zone.now
    )
  end

  def finish
    import.update(
      status: :completed,
      processed: import_stats.get_processed,
      errors_count: import_stats.get_errors_count,
      completed_at: Time.zone.now
    )
  end

  def total(total)
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

  def errors
    import_stats.get_errors_count
  end

  def processed
    import_stats.get_processed
  end

  private

  attr_reader :import_stats, :import
end
