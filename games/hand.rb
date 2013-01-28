class Hand
  attr_accessor :cards
  
  def initialize(owner, deck)
    @owner = owner
    @deck = deck
    @cards = []
  end
  
  def draw(n)
    @hand += @deck.draw(n)
  end
  
  def discard(cards)
    @deck.discard(cards)
    @hand = @hand - cards
  end
  
  def display
    puts "===============\n= " + @owner + "\n================"
    @cards.each do |card|
      puts card[:name]
    end
    puts "---------------"
  end
end























