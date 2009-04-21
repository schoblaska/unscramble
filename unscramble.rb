NETWORK = { 1  => [2,5,6],        2  => [1,3,5,6,7],           3  => [2,4,6,7,8],            4  => [3,7,8],
            5  => [1,2,6,9,10],   6  => [1,2,3,5,7,9,10,11],   7  => [2,3,4,6,8,10,11,12],   8  => [3,4,7,11,12],
            9  => [5,6,10,13,14], 10 => [5,6,7,9,11,13,14,15], 11 => [6,7,8,10,12,14,15,16], 12 => [7,8,11,15,16],
            13 => [9,10,14],      14 => [9,10,11,13,15],       15 => [10,11,12,14,16],       16 => [11,12,15] }
                   
@solutions = []
$dictionary = {}

File.open('dictionary.txt').each_line { |line| 
  $dictionary[line[0,3].to_sym] ||= []
  $dictionary[line[0,3].to_sym] << line.chop
}

class Array
  
  def to_word
    map{ |a| $board[a - 1] }.join
  end

  def possible_moves
    NETWORK[last].reject{ |a| include?(a) }
  end
  
  def substring_dictionary_match?
    ($dictionary[to_word[0,3].to_sym] || []).each do |word|
      return true if (word.index to_word) == 0
    end
    return false
  end
  
  def print
    graph = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]].map{|a| a.map {|b| index(b).nil? ? '.' : index(b).to_s}.join(' ') }.join("\n")
    puts "\n#{graph}\n#{to_word}\n"
  end
  
end

def recurse(path)
  @solutions << path if path.size > 2 and ($dictionary[path.to_word[0,3].to_sym] || []).include?(path.to_word) and !@solutions.map{ |a| a.to_word }.include?(path.to_word)
  path.possible_moves.each{ |move| recurse(path + [move]) } if path.size < 3 or path.substring_dictionary_match?
end

puts 'Input the board (left-to-right, top-to-bottom): '
$board = gets.scan(/qu|[a-z]/)

(1..16).each{ |start| recurse([start]) }

@solutions.sort_by{ |a| a.to_word.size * -1 }.each{ |solution| solution.print }