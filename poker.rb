#!/usr/bin/env ruby

require 'socket'
require 'highline'

class Poker# < HighLine
  attr_reader :cli
  def initialize
    @cli = HighLine.new
  end

  def broadcast(message, players)
    players.each do |player|
      player.puts message
    end
  end

  def start
    cli.say "Poker started now"

    s = TCPServer.new(3939)
    players = []
    votes = {}
    while (player = s.accept)
      Thread.new(player) do |conn|
        players << player

        if players.size <= ARGV[0].to_i
          name = player.print "Your name please: "
          player.readline.chomp
        end
      end
    end
  end
end

Poker.new.start