#!/usr/bin/env ruby

require 'socket'
require 'highline'

class Poker
  attr_reader :cli
  def initialize
    @cli = HighLine.new
  end

  def final_result(votes)
    # average = votes.values.map(&:to_i).sum.fdiv(votes.size)
    average = votes.values.sum.fdiv(votes.size)
    <<-HEREDOC
      Final note: #{average.to_i}
      ----------------------
      1 #{join_votes(votes, 1) }
      2 #{join_votes(votes, 2) }
      3 #{join_votes(votes, 3) }
      5 #{join_votes(votes, 5) }
      8 #{join_votes(votes, 8) }
    HEREDOC
  end

  def join_votes(votes, vote_label)
    votes.select { |_k, v| v == vote_label}.keys.join(', ') || ' -'
  end

  def planning_poker_round(average)
    case average
    when 1; 1
    when 1..2; 2
    when 2..3; 3
    when 3..5; 5
    when 5..8; 8
    end
  end
  # break unless ARGV.to_i

  def start
    cli.say "Poker started now"
    s = TCPServer.new(ARGV[1])
    players = []
    votes = {}
    while (player = s.accept)
      # vote = nil
      Thread.new(player) do |conn|
        players << player
        
        if players.size <= ARGV[0].to_i
          # name = nil
          # while players.keys.include?(name)
          name = welcome(player)
          # end
          broadcast("#{name} joined", players)
          begin
            while votes.length < ARGV[0].to_i do
              vote = 0
              until [1,2,3,5,8].include?(vote) #^ vote == 0 #&& votes.length == ARGV[0].to_i
                # conn.puts "vote at begin: #{vote}"
                # conn.puts [1,2,3,5,8].include?(vote)
                conn.puts "Pick your vote from: 1 2 3 5 8" unless [1,2,3,5,8].include?(vote) || vote == 0
                vote = conn.gets.chomp.to_i
                if [1,2,3,5,8].include?(vote)
                  votes[name] = vote
                  conn.puts "Thanks. You voted: #{vote}"
                  next
                else
                  conn.puts "Wrong. Please be a good citizen"
                end
                conn.puts "votes given in until: #{votes.length}"
              end
              # broadcast("#{name} voted: #{line}", vote)
              
              conn.puts "votes given: #{votes.length}"
              # broadcast(votes.join(', '), players)
            end
            # conn.puts "vote ends: #{votes}"
            # puts final_result(votes)
            cli.say final_result(votes)
            exit
          rescue EOFError, SystemExit, Interrupt
            conn.close
            players.delete(conn)
            broadcast("#{name} has left", players)
            exit!
          end
        else
          conn.puts 'Sorry, maximum nmber of players reached'
          conn.close
        end
        cli.say 'Someone tried to access over limit'
      end
    end
  end

  private

  def welcome(player)
    player.print "name please: "
    player.readline.chomp
  end

  def broadcast(message, players)
    players.each do |player|
      player.puts message
    end
  end
end

Poker.new.start

puts 'end of ifle'








# #!/usr/bin/env ruby

# require 'socket'
# require 'highline'

# class Poker
#   attr_reader :cli
#   def initialize
#     @cli = HighLine.new
#   end

#   def final_result(votes)
#     # average = votes.values.map(&:to_i).sum.fdiv(votes.size)
#     average = votes.values.sum.fdiv(votes.size)
#     <<-HEREDOC
#       Final note: #{average.to_i}
#       ----------------------
#       1 #{join_votes(votes, 1) }
#       2 #{join_votes(votes, 2) }
#       3 #{join_votes(votes, 3) }
#       5 #{join_votes(votes, 5) }
#       8 #{join_votes(votes, 8) }
#     HEREDOC
#   end

#   def join_votes(votes, vote_label)
#     votes.select { |_k, v| v == vote_label}.keys.join(', ') || ' -'
#   end

#   def planning_poker_round(average)
#     case average
#     when 1; 1
#     when 1..2; 2
#     when 2..3; 3
#     when 3..5; 5
#     when 5..8; 8
#     end
#   end
#   # break unless ARGV.to_i

#   def start
#     cli.say "Poker started now"
#     s = TCPServer.new(ARGV[1])
#     players = []
#     votes = {}
#     while (player = s.accept)
#       Thread.new(player) do |conn|
#         players << player
        
#         if players.size <= ARGV[0].to_i
#           # name = nil
#           # while players.keys.include?(name)
#           name = welcome(player)
#           broadcast("#{name} joined", players)
#           begin
#             while votes.length <= ARGV[0].to_i do
#               vote = 0
#               until [1,2,3,5,8].include?(vote) #^ vote == 0 #&& votes.length == ARGV[0].to_i
#                 # conn.puts "vote at begin: #{vote}"
#                 # conn.puts [1,2,3,5,8].include?(vote)
#                 conn.puts "Pick your vote from: 1 2 3 5 8" unless [1,2,3,5,8].include?(vote) || vote == 0
#                 vote = conn.gets.chomp.to_i
#                 if [1,2,3,5,8].include?(vote)
#                   votes[name] = vote
#                   conn.puts "Thanks. You voted: #{vote}"
#                   next
#                 else
#                   conn.puts "Wrong. Please be a good citizen"
#                 end
#                 conn.puts "votes given in until: #{votes.length}"
#               end
#               conn.puts "votes given: #{votes.length}"
#             end
#             cli.say final_result(votes)
#             exit
#           rescue EOFError
#             conn.close
#             players.delete(conn)
#             broadcast("#{name} has left", players)
#           ensure
#             conn.puts 'Youre out'
#             exit
#           end
#         else
#           conn.puts 'Sorry, maximum nmber of players reached'
#           conn.close
#         end
#         cli.say 'Someone tried to access over limit'
#       end
#     end
#   # ensure
#   #   cli.say "exiting..."
#   #   exit
#   end

#   private

#   def welcome(player)
#     player.print "name please: "
#     player.readline.chomp
#   end

#   def broadcast(message, players)
#     players.each do |player|
#       player.puts message
#     end
#   end
# end

# Poker.new.start

# puts 'end of ifle'



# require 'socket'
# def welcome(chatter)
#  chatter.print "Welcome! Please enter your name: "
# chatter.readline.chomp
# end
# def broadcast(message, chatters)
#  chatters.each do |chatter|
#  chatter.puts message
#  end
# end
# s = TCPServer.new(3939)
#  chatters = []
# while (chatter = s.accept)
#  Thread.new(chatter) do |c|
#  name = welcome(chatter)
#  broadcast("#{name} has joined", chatters)
#  chatters << chatter
#  begin
#  loop do
#  line = c.readline
#  broadcast("#{name}: #{line}", chatters)
#  end
#  rescue EOFError
#  c.close
#  chatters.delete(c)
#  broadcast("#{name} has left", chatters)
#  end
#  end
# end