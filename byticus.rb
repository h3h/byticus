$: << File.expand_path(File.dirname(__FILE__))  

require 'rubygems'
require 'god'
require 'actor'
require 'player'
require 'room'
require 'enemy'

@god = God.new()

# Creates the NPCs (name, health, strength)
@old_lady = Enemy.new('Old Lady', 5, 1 + rand(6))
@goblin = Enemy.new('Goblin', 5, rand(11))

# Creates the rooms (name, n, s, e, w, npc, denarii, item)
@clearing = Room.new('Clearing', nil, nil, nil, nil, nil, 10, 'bottled spring water')
@wall = Room.new('Wall', @clearing, @dark_hallway, nil, nil, @goblin, 0, 'slice of bread')
@dark_hallway = Room.new('Dark Hallway', @wall, nil, nil, nil, @old_lady, 5, nil)

# Creates the player (name, health, denarii, location, inventory)
# FIXME: Let the player put in their own name
$player = Player.new('Ben', 100, 5, @dark_hallway, nil)

# The start of the game
puts 'Welcome to B Y T I C U S !'
puts 'What be your name, oh great adventurer?'

puts 'Greetings, ' + $player.name + '!'
puts 'You have ' + $player.denarii.to_s + ' denarii and ' + $player.health.to_s + ' health.'
@god.wait
puts 'The game will now begin!'
puts ''
@god.wait
puts 'You\'re walking down a ' + $player.location.name + '. There is an ' + $player.location.npc.name + ' in the room. If you go to the north, you will climb a ' + @dark_hallway.n.name.to_s + '. You decide to talk to her. You say:'

@god.accept_command

$player.hurt

puts 'The lady gets angry and kicks your shins. You lose ' + $player.location.npc.strength.to_s + ' health!'

puts 'You now have ' + $player.health.to_s + ' health remaining.'
puts ''
@god.wait
puts 'Ouch, you say. Type in fight to attack the lady!'

@god.accept_command

until $input == 'fight'
	puts 'Time is money! Type in fight to attack'
	@god.input
  @god.check
end

if $input == 'fight'
	puts 'You attack. The poor lady flees in terror.'
end

$player.location = @wall

puts 'You see a wall. It looks like you can climb it. It may be a shortcut. There is a ' + $player.location.npc.name.to_s + ' in the room.'
@god.wait
puts 'There is also a pathway to the north.'
@god.wait
puts 'After a moment\'s hesitation, you decide to try the wall. Type in climb to scale the wall.'	

@god.accept_command

until $input == 'climb'
  puts 'Type in climb to climb theë wall.' 
	@god.accept_command
end

@chance = rand(6)/5

if $input == 'climb' and @chance <= 0.8
	$player.hurt
	puts 'You try to climb the wall, but it is too slippery. you fall and lose ' + $player.location.npc.strength.to_s + ' health!'
  @god.wait
	puts 'You now have ' + $player.health.to_s + ' health remaining.'
  @god.wait
	puts 'After your fall, you decide to either walk along the path or try to climb it again.'
else
  puts 'You\'ve won a million dollars!'
end

$player.heal

until $input == 'walk north'
  puts 'Type in walk north to walk along the path.' 
  @god.accept_command
end  

if $input == 'walk north'
  $player.location = @clearing
	puts 'You walk along the path. You then come into a clearing, and see a lake. You wash yourself in it. It restores ' + $player.healing.to_s + ' health!'
	@god.wait
  puts 'You now have ' + $player.health.to_s + ' health!'
end
@god.wait
puts 'Suddenly, you hear footsteps and a low growl. Do you wish to [flee], or [attack]?'

@god.accept_command

if $input == 'flee'
  $player.infected
  puts 'While attempting to flee your leg gets bitten by an infected dog. You lose ' + $player.infected_hurting.to_s + ' health over the next five minutes and have to rest!'
  sleep 5
  puts 'You awaken with ' + $player.health.to_s + ' health remaining.'
end

if $input == 'attack'
  puts 'You shoot an arrow towards the noise, killing a beast. You skin the beast. and collect its pelt and flesh.'
  $player.location.item = 'beast flesh'
  @god.accept_command
end

while @game_over == false
  @god.accept_command
end

puts 'Goodbye!'