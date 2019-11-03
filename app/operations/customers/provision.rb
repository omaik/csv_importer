# frozen_string_literal: true

module Customers
  class Provision < BaseOperation
    def initialize(params)
      @params = params
    end

    def call
      if customer.update(params)
        success(customer)
      else
        error(customer, customer.errors.full_messages)
      end
    end

    private

    attr_reader :import, :params

    def customer
      @customer ||= existing_customer || new_customer
    end

    def existing_customer
      Customer.where(email: params[:email])
              .where.not(import_id: params[:import_id])
              .first
    end

    def new_customer
      Customer.new
    end
  end
end
