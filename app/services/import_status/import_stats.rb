# frozen_string_literal: true

class ImportStatus
  class ImportStats
    def initialize(import)
      @import = import
      @redis = Redis.new
    end

    %i[processed errors_count].each do |attribute|
      define_method "get_#{attribute}" do
        redis.get("#{redis_key}:#{attribute}").to_i
      end

      define_method "increment_#{attribute}" do
        redis.incr("#{redis_key}:#{attribute}")
      end
    end

    private

    attr_reader :import, :redis

    def redis_key
      "csv_importer:import_stats:#{import.id}"
    end
  end
end
