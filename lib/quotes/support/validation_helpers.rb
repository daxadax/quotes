module Support
  module ValidationHelpers

    def raise_argument_error(reason, action = :build)
      klass = self.class.name.split('::').last
      msg = "#{klass} #{action_message(action)}"

      raise ArgumentError, msg + reason
    end

    private

    def action_message(action)
      return "can't be built: " if action == :build
      return "cannot run: "     if action == :run 
    end
    
  end
end
