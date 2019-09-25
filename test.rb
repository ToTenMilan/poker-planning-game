vote = nil
p 'vote at begin'
p vote
until [1,2,3,5,8].include?(vote)
  puts "Pick your vote from: 1 2 3 5 8"
  vote = gets.chomp.to_i
  puts "You voted: #{vote}"
  unless [1,2,3,5,8].include?(vote)
    puts "Wrong. Please be a good citizen"
  end
end
p 'vote at end'
p vote