require_relative 'deck'
require_relative 'hand'

module Games
  class Base
    attr_reader :hands, :deck
  
    def initialize
      @deck = Deck.new
      @hands = []
      @deck.shuffle
    end
  
    def add_player(name)
      @hands << Hand.new(name, @deck)
    end
  
    def deal(n)
      for hand in @hands do
        hand.cards += @deck.draw(n)
      end
    end
  end
end