# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def index; end

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end
end
