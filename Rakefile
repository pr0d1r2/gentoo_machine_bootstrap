desc 'Run test build (to be used on TravisCI)'
task :default do
  output = `travis_wait bash travis-build.sh`
  status = $?.exitstatus
  puts output
  exit status
end
