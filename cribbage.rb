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
        cards << Hash[:name => "#{card} of #{suit}", :card => card, :value => (value > 10 ? 10 : value), :suit => suit, :sort => value]
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

class Game
  def initialize(deck = Deck.new)
    @deck = deck
    @hands = {}
  end
  
  def deck
    @deck
  end
  
  def add_player(name)
    @hands[name] = Hand.new @deck
  end
  
  def hands
    @hands
  end
  
  def deal(i)
    for player, hand in @hands do
      hand.draw(i)
    end
  end 
  
  def score(hands = @hands)
    for hand in hands do  
      suits, values, cards, sorts, points, rationale = [], [], [], [], 0, "pts\treason\n"
      for card in hand do
        suits << card[:suit]
        values << card[:value]
        cards << card[:card]
        sorts << card[:sort]
      end
      
      # flushes
      if suits.uniq.count == 2 && suits.count == 5
        rationale += "4\t4 card flush\n"
        points += 4
      elsif suits.uniq.count == 1 && suits.count == 5
        rationale += "5\t5 card flush\n"
        points += 5
      elsif suits.uniq.count == 1 && suits.count == 4
        rationale += "4\t4 card flush\n"
        points += 4
      end
      
      # X of a kind
      case cards.count - cards.uniq.count
      when 1
        rationale += "2\t2 of a kind\n"
        points += 2
      when 2
        rationale += "6\t3 of a kind\n"
        points += 6
      when 3
        rationale += "12\t4 of a kind\n"
        points += 12
      end
      
      # 15s
      values.each_with_index do |card1, key1|
        values.each_with_index do |card2, key2|
          #puts card1.to_s + '+' + card2.to_s
          if card1.to_i + card2.to_i == 15 && key1 != key2
            rationale += "2\t#{card1}+#{card2}==15\n"
            points += 2
          end
        end
      end
    
      # runs
      i = 0
      arr = sorts.sort
      last_value = arr[0]
      finds = 1
      longest_run = 0
      while i < arr.count
        if arr[i] == last_value + 1
          finds += 1
        else
          finds = 1
        end
        last_value = arr[i]
        if finds > longest_run
          longest_run = finds
        end
        i += 1
      end
      if longest_run > 2
        rationale += "#{longest_run}\t#{longest_run}-card run\n"
        points += longest_run
      end
  
      
      puts rationale + "----\n" if options[:rationale] == true
      points
    end
  end
end

class Hand
  def initialize(deck, cards = [])
    @deck = deck
    @hand = cards
  end
  
  def cards
    @hand
  end
  
  def draw(i)
    @hand += @deck.deal(i)
  end
  
  def value
    total = 0
    for card in @hand do
      total += card[:value]
    end
    total
  end

  
  def discard(cards)
    @deck.discard(cards)
    @hand = @hand - cards
  end
end

deck = Deck.new
game = Game.new deck
game.add_player 'Jack'
game.deal(10)
puts game.hands['Jack'].cards.count

#puts deck.contents
#puts deck.contents
#deck.shuffle
#puts deck.contents
#puts Deck.card('10h')
=begin
puts "\n\n"
hands = {'Jack' => nil, 'Emily' => nil, 'Frank' => nil}
for player, hand in hands do
  puts "dealing to #{player}..."
  hands[player] = Hand.new(deck, deck.deal(6))
  puts 'discarding 2...'
  hands[player].discard(hands[player].cards[0..1])
  puts "\n\n"
end

top_score = 0
winner = 'no one'
for player, hand in hands do
  puts "#{player} has #{hand.cards.count}:\n----------------------------------"
  puts hand.cards.map { |c| c[:name] }
  puts "\n"
  puts hand.points({:rationale => true})
  puts "\n\n"
  if hand.points > top_score
    top_score = hand.points
    winner = player
  end
end

puts "#{winner} is winning with #{top_score} points!\n\n\nEND"
=end

#puts "all dealt cards (#{deck.dealt.count})..."
#puts deck.dealt.map { |c| c[:name] }.join(', ')
#puts 'discarded:'
#puts deck.discarded
#puts 'cards in play...'
#puts deck.cards_in_play

























