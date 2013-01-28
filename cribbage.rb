require_relative 'games/base'

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

game = Games::Cribbage.new

game.add_player 'Jack'
game.add_player 'Emily'
game.deal(4)
game.score



























