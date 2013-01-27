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
  
module Games
  class Cribbage < Base
    def score
      for hand in @hands do
        hand.display
        suits, values, cards, sorts, points, rationale = Hash.new(0), [], [], [], 0, "pts\treason\n"
        kinds = Hash.new(0)
        for card in hand.cards do
          suits[card[:suit]] += 1
          values << card[:value]
          cards << card[:card]
          sorts << card[:sort]
          # for scoring x of a kinds
          kinds[card[:card]] += 1
        end
      
        # flushes
        sorted_suits = suits.sort_by { |suit, count| count }
        sorted_suits.each do |suit, count|
          points += count if count > 3
          rationale += "#{count}\t#{count} #{suit}s\n" if count > 3
        end
      
        # x of a kind
        sorted_kinds = kinds.sort_by { |kind, count| count }
        sorted_kinds.each do |kind, count|
          points += count if count > 1
          rationale += "#{count}\t#{count} #{kind}s\n" if count > 1
        end

        # 15s
        values.each_with_index do |card1, key1|
          values.each_with_index do |card2, key2|
            #puts card1.to_s + '+' + card2.to_s
            if card1.to_i + card2.to_i == 15 && key1 != key2
              rationale += "1\t#{card1}+#{card2}==15\n"
              points += 1
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
  
      
        puts rationale + "----\n"
        puts points
      end
    end
  end
end

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

game = Games::Cribbage.new

game.add_player 'Jack'
game.add_player 'Emily'
game.deal(4)
game.score



























