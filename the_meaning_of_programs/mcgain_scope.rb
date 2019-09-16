require_relative 'small_step'


class Scope < Struct.new(:body)
  def to_s
    "{{ #{body} }}"
  end

  def inspect
    "{{#{self}}}"
  end

  def reducible?
    true
  end

  def reduce(environment)
    [body, Environment.new(environment)]
  end
end

class Environment
  def initialize(parent_environment)
    @parent_environment = parent_environment
    @this_environment = {}
  end

  def [](key)
    @this_environment[key] || @parent_environment[key]
  end

  def []=(key, value)
    if @parent_environment.exist?(key)
      @parent_environment[key] = value
    else
      @this_environment[key] = value
    end
  end

  def merge(env)
    @this_environment.merge!(env)
  end

  def inspect
    "ENV: #{@parent_environment.inspect} | #{@this_environment.inspect}"
  end

  alias_method :to_s, :inspect
end

mac = Machine.new(
  Sequence.new(
    Assign.new(:x, Number.new(1)),
    Scope.new(
        If.new(LessThan.new(Variable.new(:x), Number.new(2)),
        Assign.new(:y, Number.new(1)),
        Assign.new(:y, Number.new(2)))
    )
  ), {}
)

mac2 = Machine.new(
  Sequence.new(
    Scope.new(
      Assign.new(:x, Number.new(1)),
    ),
    Scope.new(
      If.new(LessThan.new(Variable.new(:x), Number.new(10)),
        Boolean.new(true),
        Boolean.new(false)
      )
    )
  ), {}
)

puts '------------------------------'
puts 'MAC RUN'
puts '------------------------------'
mac.run
puts '------------------------------'
puts 'MAC2 RUN'
mac2.run
puts '------------------------------'

true
