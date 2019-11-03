# frozen_string_literal: true

class StartedImportDecorator < ImportDecorator
  def progress
    if total_count.to_i.zero?
      'Calculating'
    else
      "#{percentage_of_done.round(6)} %"
    end
  end

  def errors
    import_status.errors
  end

  def processed
    import_status.processed
  end

  def details
    super + [
      { title: 'Started at', value: started_at },
      { title: 'Processed', value: processed },
      { title: 'Errors', value: errors },
      { title: 'Total', value: total_count },
      { title: 'Progress', value: progress }
    ]
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
