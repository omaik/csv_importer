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

  def details
    super + [
      { title: 'Started at', value: started_at },
      { title: 'Completed at', value: completed_at },
      { title: 'Duration', value: duration },
      { title: 'Processed', value: processed },
      { title: 'Errors', value: errors_count }
    ]
  end
end
