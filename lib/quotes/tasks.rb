require 'quotes/tasks/task'
Dir.glob('./lib/quotes/tasks/*.rb') { |f| require f }

module Tasks
end