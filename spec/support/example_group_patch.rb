class RSpec::Core::Example
  def passed?
    RSpec.current_example.instance_variable_get(:@exception).nil?
  end

  def failed?
    !passed?
  end
end
