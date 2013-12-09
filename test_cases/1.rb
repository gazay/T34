CODE =<<EOF
class TestCase1

  def meth(param1, param2 = nil)
    param1, param2
  end

end

class Modified1 < TestCase1

  def meth(param1)
    param1
  end

end

tc1 = TestCase1.new
m1 = Modified1.new

puts tc1.meth('abc', 'def') == m1.meth('abc')
EOF

# rewriting

# test
