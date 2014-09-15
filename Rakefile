require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

desc "Import quotes"
task :import_quotes do
  require './lib/quotes'

  puts "Importing quotes"
  Tasks::ImportQuotes.new.run
  puts "Quotes imported successfully"
end