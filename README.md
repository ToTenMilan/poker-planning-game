#### Planning Poker

tested on ruby 2.6.0

###### Requirements
```
ruby
bundler
```

###### First:
```
bundle
```

###### Usage:

As a host start a planning poker server:
```
./poker start 2 127.0.0.1 3939
```
arguments:

1: 'start' (the server)

2: number of players

3: host

4: port

now players can vote:
```
./poker vote 3 127.0.0.1 3939 Jan
```

arguments:

1: 'vote' for estimate

2: vote value (possible values 1, 2, 3, 5, 8)

3: host

4: port

5: player name

enjoy!