module Entities
  class Entity

    def raise_argument_error(reason)
      klass = self.class.name.split('::').last
      msg = "#{klass} cannot be built: "

      raise ArgumentError, msg + reason
    end
    
  end
end