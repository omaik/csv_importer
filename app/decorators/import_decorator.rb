class ImportDecorator < Draper::Decorator
  delegate_all


  def percentage
    if pending?
      'pending'
    else
      "#{((import_status.processed + import_status.errors).fdiv(total_count.to_i) * 100).round(6)} %"
    end
  end



  def errors
    import_status.errors
  end

  private

  def import_status
    @import_status ||= ImportStatus.new(self)
  end
end
