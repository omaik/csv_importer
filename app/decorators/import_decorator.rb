# frozen_string_literal: true

class ImportDecorator < Draper::Decorator
  delegate_all

  class << self
    def decorate_collection(collection, *_)
      collection.map do |element|
        decorate_one(element)
      end
    end

    def decorate_one(element)
      decorator_for(element.status).decorate(element)
    end

    private

    def decorator_for(status)
      Module.const_get("#{status.capitalize}ImportDecorator")
    end
  end

  def details
    [
      { title: 'Title', value: title },
      { title: 'Status', value: status },
      { title: 'Filename', value: filename },
      { title: 'Created at', value: created_at }
    ]
  end

  def filename
    file.attachment.blob.filename.to_s if file
  end

  def created_at
    in_relevant_time_representation(:created_at)
  end

  def started_at
    in_relevant_time_representation(:started_at)
  end

  private

  def in_relevant_time_representation(attribute)
    read_attribute(attribute) &&
      "#{h.time_ago_in_words(read_attribute(attribute))} ago"
  end
end
