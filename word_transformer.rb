module Words
  class Word
    def initialize(value)
      @value = value
      @mark = false
    end

    def marked?
      @mark
    end

    def mark
      @mark = true
    end

    def value
      @value
    end

    def to_s
      @value
    end

    class << self
      def neighbor?(first, second)
        raise "Invalid!" if first.class != self or second.class != self

        diferences = 0
        first.value.each_char.each_with_index do |char, index|
          diferences += 1 if second.value[index] != char
        end
        diferences == 1
      end
    end
  end

  class Dictionary
    def initialize(arr)
        @dictionary = []
        arr.each do |elem|
          @dictionary << Word.new(elem)
        end
      @dictionary.sort! { |x, y| x.value <=> y.value }
    end

    def get_word (value)
      result = @dictionary.select { |word| word.value == value }
      result.first
    end

    def get_neighbors (word)
      @dictionary.select do |w|
        Word.neighbor?(word, w)
      end
    end
  end
end

module WordLadder
  class BreadthFirst
    class << self
      def run (dictionary, initial_word, goal_word)
        initial_word.mark
        queue = [ [ initial_word ] ]

        last_stack_size = -1
        while !queue.empty?
          stack = queue.first
          queue = queue[1, queue.size - 1]

          if last_stack_size != stack.size
            puts "Breadth-first depth: #{stack.size}."
            last_stack_size = stack.size
          end

          return stack if stack[-1].value == goal_word.value

          dictionary.get_neighbors(stack[-1]).each do |neighbor|
            if !neighbor.marked?
              neighbor.mark
              queue << [ stack, neighbor ].flatten
            end
          end
        end
      end
    end
  end
end

class Application
  class << self
    def main (arg0,arg1,arg2)
      dictionary = Words::Dictionary.new(arg2)
      initial_word = dictionary.get_word(arg0)
      goal_word = dictionary.get_word(arg1)

      if initial_word.nil?
        puts "#{ arg0 } does not exist in the dictionary."
        return
      end

      if goal_word.nil?
        puts "#{ arg1 } does not exist in the dictionary."
        return
      end

      ladder = WordLadder::BreadthFirst.run(dictionary, initial_word, goal_word)

      unless ladder.nil?
        puts "Ladder found! : #{ ladder.map(&:value) }"
      end
    end
  end
end

Application.main('hot','cog',['hot','dot','dog','lot','log','cog'])