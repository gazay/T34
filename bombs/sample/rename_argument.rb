# Sample algorithm for removing last argument from each method
#
# source:
#
# class X
#   def test_method(arg1)
#     some logic
#   end
# end
#
# target:
#
# class X
#   def test_method(gra1)
#     some logic
#   end
# end

class Bombs::Sample::RenameArgument < T34::Bomb

  attr_accessor :rename_from, :rename_to

  def rule
    rewrite do
      methods.each do |method|
        method.args.map! do |it|
          it.name = rename_to if it.name == rename_from
          it
        end
      end
    end
  end

end
