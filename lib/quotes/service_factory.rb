module Quotes
  class ServiceFactory < ServiceRegistration

    ServiceRegistration.register :quotes_backend do
      raise "\n\n~~~~~{[  implement me  ]}~~~~~\n\n"
    end

    ServiceRegistration.register :publications_backend do
      raise "\n\n~~~~~{[  implement me  ]}~~~~~\n\n"
    end

  end
end
