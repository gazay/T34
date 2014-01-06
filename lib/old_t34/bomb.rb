class T34::Bomb < T34::Rewriter

  def rule
    raise NotImplementedError.new("Should be rule to rewrite")
  end

  def fire!
    rule
    self
  end

  def self.load(name)
    require File.expand_path("../../../bombs/#{name}", __FILE__)
  end

  def inspect
    self.target
  end

end
