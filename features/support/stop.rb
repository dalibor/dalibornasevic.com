# Usage:
#  @wip @stop
#  Scenario: change password
#    ........................
# $ cucumber -p wip
After do |scenario|
  #if scenario.failed? && scenario.source_tag_names.include?("@wip") && scenario.source_tag_names.include?("@stop")
  if scenario.failed? && scenario.source_tag_names.include?("@stop")
    puts
    puts "Scenario failed. You are in rails console because of @run. Type exit when you are done"
    puts '---------------------------------'
    puts scenario.backtrace_line
    puts '---------------------------------'
    puts scenario.exception.backtrace.last
    puts '---------------------------------'
    puts "Exception #{scenario.exception.message}"
    puts '---------------------------------'
    puts scenario.exception.backtrace
    puts '---------------------------------'
    require 'irb'
    require 'irb/completion'
    ARGV.clear
    IRB.start
  end
end

