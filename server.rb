# require 'socket'                 # Get sockets from stdlib
# people = 5
# server = TCPServer.open(2000)    # Socket to listen on port 2000
# puts 'Poker started now'
# loop {                           # Servers run forever
#   Thread.start(server.accept) do |client|
#     # client.puts(Time.now.ctime)   # Send the time to the client
#     # client.close                  # Disconnect from the client
#     vote = client.gets.chomp
#     client.puts vote
#   end
# }

require 'socket'
s = TCPServer.new(2000)
votes = []
while (conn = s.accept)
  Thread.new(conn) do |c|
    c.print "What's your vote? "
    vote = c.gets.chomp.to_i
    votes << vote
    conn.puts votes
    # c.close
  end
end