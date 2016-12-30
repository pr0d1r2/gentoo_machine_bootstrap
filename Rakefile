desc 'Run test build (to be used on TravisCI)'
task :default do
  IO.popen('bash travis-build.sh') { |f| puts f.gets }
end
