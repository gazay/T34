# Sample algorithm for removing last argument from each method
#
# source:
#
# class X
#   def test_method(arg1, arg2)
#     some logic
#   end
#
#   def test_method2(arg1)
#     some logic
#   end
# end
#
# target:
#
# class X
#   def test_method(arg1)
#     some logic
#   end
#
#   def test_method2
#     some logic
#   end
# end

class Bombs::Sample::RemoveArgument < T34::Bomb

  def rule
    rewrite do
      methods.each do |method|
        method.args = method.args[0...-1]
      end
    end
  end

end
