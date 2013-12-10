class T34::Chain

  include Enumerable

  attr_accessor :source, :bombs, :target

  def initialize(source, bomb_types)
    unless bomb_types.all? { |b| b.superclass == T34::Bomb }
      raise 'Chain only for bombs'
    end
    @bombs = bomb_types
    @source = source
  end

  def reaction!
    @target = @source

    @bombs.each do |bt|
      @target = bt.new(@target).fire!.target
    end

    target
  end

  def each
    bombs.each { |b| yield b }
  end

end
