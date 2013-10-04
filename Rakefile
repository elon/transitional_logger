require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.name = "spec"
  t.libs.push ["lib", "test"]
  t.test_files = FileList['test/**/*_spec.rb']
  t.verbose = true
  t.warning = false
end
