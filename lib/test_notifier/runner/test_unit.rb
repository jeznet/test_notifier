require "test_notifier"
require "test/unit/ui/console/testrunner"

class Test::Unit::UI::Console::TestRunner
  alias finished_original finished

  def finished(elapsed_time)
    finished_original(elapsed_time)

    begin
      re = /(\d+) tests, (\d+) assertions, (\d+) failures, (\d+) errors/
      _, tests, assertions, failures, errors = *@result.to_s.match(re)
      return if tests.to_i.zero?


      stats = TestNotifier::Stats.new(:test_unit, :total => tests, :assertions => assertions, :fail => failures, :error => errors)
      TestNotifier.notify(:status => stats.status, :message => stats.message)
    rescue
    end
  end
end
