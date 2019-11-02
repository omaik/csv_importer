module Imports
  class BaseOperation
    private

    def success(object)
      {object: object, success: true, errors: []}
    end

    def error(object,errors)
      {object: object, success: false, errors: errors}
    end
  end
end
