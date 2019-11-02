# frozen_string_literal: true

module Customers
  class Provision < BaseOperation
    def initialize(import, params)
      @import = import
      @params = params
    end

    def call
      customer.update(params) ? success(customer) : error(customer, customer.errors.full_messages)
    end

    private

    attr_reader :import, :params

    def customer
      @customer ||=
        Customer.where(email: params[:email]).where.not(import_id: import.id).first || Customer.new
    end
  end
end
