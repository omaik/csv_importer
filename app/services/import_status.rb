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

  def increment
    import_stats.increment
  end

  def increment_errors
    import_stats.increment_errors
  end
end
