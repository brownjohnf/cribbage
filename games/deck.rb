module Games
  class Deck
    attr_reader :contents, :dealt, :discard
  
    def initialize
      @contents = Deck.cards.shuffle
      @dealt = []
      @discard = []
      # sanity check
      raise 'There are too many cards in play...' unless @contents.count + @dealt.count + @discard.count == 52
    end
  
    def self.cards
      cards = []
      for suit in ['Spades', 'Hearts', 'Diamonds', 'Clubs'] do
        for card, value in Hash['Ace' => 1, 'King' => 13, 'Queen' => 12, 'Jack' => 11, '10' => 10, '9' => 9, '8' => 8, '7' => 7, '6' => 6, '5' => 5, '4' => 4, '3' => 3, '2' => 2] do
          cards << Hash[:name => "#{card} of #{suit}", :card => card, :value => (value > 10 ? 10 : value), :suit => suit, :sort => value]
        end
      end
      return cards
    end
  
    def self.card(input)
      if input.length < 4
        Deck.cards[input[-1]][input[0..-2]]
      end
    end
  
    def shuffle
      @contents = @contents.shuffle
    end
  
    def draw(count)
      drawn = []
      count.times do
        drawn << @contents.pop
      end
      @dealt += drawn
      raise 'Too many cards in play...' unless @contents.count + @dealt.count + @discard.count == 52
      drawn
    end
  
    def discard(cards)
      @discard += cards
      @dealt -= cards
    end
  end
end