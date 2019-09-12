require_relative 'small_step'

require'pry-byebug';binding.pry

class Scope < Struct.new(:body)
  def to_s
    "{{ #{body} }}"
  end

  def inspect
    "{{#{self}}}"
  end

  def reduce(environment)
    [body, {}]
  end
end

mac = Machine.new(
  Sequence.new(
    Scope.new(
      Sequence.new(
        Assign.new(:x, Number.new(1)),
        Add.new(Number.new(2), Variable.new(:x)))),
    Scope.new(
      If.new(Variable.new(:x),
        Assign.new(:y, Number.new(1)),
        Assign.new(:y, Number.new(2)))
    )
  ), {}
)

true
