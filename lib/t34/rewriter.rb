module T34
  class Rewriter

    attr_reader :source

    def initialize(source)
      @source = Source.new(source)
    end

  end
end
