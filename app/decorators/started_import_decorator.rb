# frozen_string_literal: true

class StartedImportDecorator < ImportDecorator
  def percentage
    if pending?
      'pending'
    else
      "#{percentage_of_done.round(6)} %"
    end
  end

  def errors
    import_status.errors
  end

  def started_at
    "#{h.time_ago_in_words(read_attribute(:started_at))} ago"
  end

  private

  def import_status
    @import_status ||= ImportStatus.new(self)
  end

  def percentage_of_done
    (import_status.processed + import_status.errors)
      .fdiv(total_count.to_i) * 100
  end
end
