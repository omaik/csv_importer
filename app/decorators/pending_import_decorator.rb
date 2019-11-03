# frozen_string_literal: true

class PendingImportDecorator < ImportDecorator
  def progress
    'pending'
  end

  def errors; end
end
