class Deck
  def initialize
    @deck = Deck.cards.shuffle
    @dealt = []
    @discard = []
    # sanity check
    raise 'There are too many cards in play...' unless @deck.count + @dealt.count + @discard.count == 52
  end
  
  def self.cards
    cards = []
    for suit in ['Spades', 'Hearts', 'Diamonds', 'Clubs'] do
      for card, value in Hash['Ace' => 1, 'King' => 13, 'Queen' => 12, 'Jack' => 11, '10' => 10, '9' => 9, '8' => 8, '7' => 7, '6' => 6, '5' => 5, '4' => 4, '3' => 3, '2' => 2] do
        cards << Hash[:name => "#{card} of #{suit}", :value => value, :suit => suit]
      end
    end
    return cards
  end
  
  def contents
    @deck
  end
  
  def dealt
    @dealt
  end
  
  def discarded
    @discard
  end
  
  def shuffle
    @deck = @deck.shuffle
  end
  
  def self.card(input)
    if input.length < 4
      Deck.cards[input[-1]][input[0..-2]]
    end
  end
  
  def deal(count)
    deal = []
    count.times do
      deal << @deck.pop
    end
    @dealt += deal
    raise 'Too many cards in play...' unless @deck.count + @dealt.count == 52
    deal
  end
  
  def discard(cards)
    @discard += cards
  end
  
  def cards_in_play
    @dealt - @discard
  end
end

class Hand
  def initialize(deck, seeds = [])
    @deck = deck
    @hand = seeds
  end
  
  def cards
    @hand
  end
  
  def value
    total = 0
    for card in @hand do
      total += card[:value]
    end
    total
  end
  
  def points
    suits, values, points = [], [], 0
    for card in @hand do
      suits << card[:suit]
      values << card[:value]
    end
    if suits.uniq.count == 1
      points += 4
    end
    case values.uniq.count
    when 1
      points += 10
    when 2
      points += 6
    when 3
      points += 2
    end
    points
  end
  
  def discard(cards)
    @deck.discard(cards)
    @hand = @hand - cards
  end
end

deck = Deck.new

#puts deck.contents
#puts deck.contents
#deck.shuffle
#puts deck.contents
#puts Deck.card('10h')
puts "\n\n"
hands = {'Jack' => nil, 'Emily' => nil, 'Frank' => nil}
for player, hand in hands do
  puts "dealing to #{player}..."
  hands[player] = Hand.new(deck, deck.deal(6))
  puts 'discarding 2...'
  hands[player].discard(hands[player].cards[0..1])
  puts "\n\n"
end

for player, hand in hands do
  puts "#{player} has #{hand.cards.count}:\n-----------"
  puts hand.cards.map { |c| c[:name] }
  puts "\ntotal points are:"
  puts hand.points
  puts "\n\n"
end

puts "all dealt cards (#{deck.dealt.count})..."
puts deck.dealt.map { |c| c[:name] }.join(', ')
puts 'discarded:'
puts deck.discarded
puts 'cards in play...'
puts deck.cards_in_play

























