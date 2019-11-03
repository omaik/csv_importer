# frozen_string_literal: true

class CompletedImportDecorator < ImportDecorator
  def completed_at
    "#{h.time_ago_in_words(read_attribute(:completed_at))} ago"
  end

  def duration
    h.distance_of_time_in_words(
      read_attribute(:started_at),
      read_attribute(:completed_at)
    )
  end
end
