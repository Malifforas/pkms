// battles.dm
import "type_chart.dm"

// Define types, constants, and variables
//
const MAX_TEAM_SIZE = 6
const MAX_ITEM_QUANTITY = 99

var player_pokemon: array(MAX_TEAM_SIZE, int)
var enemy_pokemon: array(MAX_TEAM_SIZE, int)

var player_items: array(Item, int)
var enemy_items: array(Item, int)

var turn_count = 0

var battle_over = false
var player_won = false

// Define procedures for battle system
//
proc begin_battle(player_team: array[MAX_TEAM_SIZE, Pokemon], enemy_team: array[MAX_TEAM_SIZE, Pokemon])
  # This procedure starts a battle with the given player team and enemy team.
  # It sets the player_pokemon and enemy_pokemon arrays with the IDs of the Pokemon in each team.
  # It also sets the turn count to 0 and the battle_over flag to false.
end_proc

proc end_battle(won: bool)
  # This procedure ends the battle with the given won flag indicating whether the player won.
  # It sets the battle_over flag to true and the player_won flag to the given won flag.
end_proc

proc choose_move(pokemon: Pokemon): Move
  # This procedure allows the player to choose a move for the given Pokemon.
  # It displays the available moves for the Pokemon and waits for the player to choose one.
  # It returns the chosen move.
end_proc

proc choose_item: Item
  # This procedure allows the player to choose an item from their inventory.
  # It displays the available items and waits for the player to choose one.
  # It returns the chosen item.
end_proc

proc use_move(attacker: Pokemon, defender: Pokemon, move: Move)
  # This procedure executes a move by the attacker against the defender.
  # It calculates the damage and updates the defender's HP and status.
  # It also updates the turn count.
end_proc

proc use_item(pokemon: Pokemon, item: Item)
  # This procedure uses the given item on the given Pokemon.
  # It updates the Pokemon's stats or status according to the item.
end_proc

proc switch_pokemon(pokemon: Pokemon)
  # This procedure switches the given Pokemon with the active Pokemon.
  # It updates the player_pokemon or enemy_pokemon array accordingly.
end_proc

proc run_away
  # This procedure allows the player to run away from the battle.
  # It sets the battle_over flag to true and the player_won flag to false.
end_proc

// Define helper procedures for battle system
// Given the ID of a Pokemon species and a level, returns a Pokemon object with the appropriate stats.
proc make_pokemon(species_id: int, level: int) : Pokemon
    var base_stats = get_pokemon_base_stats(species_id)
    var hp = floor(((2 * base_stats.hp + 31 + floor(sqrt(0.25 * level))) * level) / 100) + level + 10
    var attack = floor(((2 * base_stats.attack + 31 + floor(sqrt(0.25 * level))) * level) / 100) + 5
    var defense = floor(((2 * base_stats.defense + 31 + floor(sqrt(0.25 * level))) * level) / 100) + 5
    var sp_atk = floor(((2 * base_stats.sp_atk + 31 + floor(sqrt(0.25 * level))) * level) / 100) + 5
    var sp_def = floor(((2 * base_stats.sp_def + 31 + floor(sqrt(0.25 * level))) * level) / 100) + 5
    var speed = floor(((2 * base_stats.speed + 31 + floor(sqrt(0.25 * level))) * level) / 100) + 5
    return new(Pokemon)
        ..species = species_id
        ..level = level
        ..current_hp = hp
        ..max_hp = hp
        ..attack = attack
        ..defense = defense
        ..sp_atk = sp_atk
        ..sp_def = sp_def
        ..speed = speed

// Given a player and enemy team, prints out information about each team's Pokemon.
proc display_teams(player_team: array(MAX_TEAM_SIZE, int), enemy_team: array(MAX_TEAM_SIZE, int))
    for i in 1..MAX_TEAM_SIZE
        if player_team[i] != 0
            var pkmn = make_pokemon(player_team[i], 50)
            write("Player Pokemon ", i, ": ", get_pokemon_name(pkmn.species), " (Level ", pkmn.level, ")\n")
            write("  HP: ", pkmn.current_hp, "/", pkmn.max_hp, "\n")
            write("  Attack: ", pkmn.attack, "\n")
            write("  Defense: ", pkmn.defense, "\n")
            write("  Sp. Atk: ", pkmn.sp_atk, "\n")
            write("  Sp. Def: ", pkmn.sp_def, "\n")
            write("  Speed: ", pkmn.speed, "\n")
        endif
    endfor
    for i in 1..MAX_TEAM_SIZE
        if enemy_team[i] != 0
            var pkmn = make_pokemon(enemy_team[i], 50)
            write("Enemy Pokemon ", i, ": ", get_pokemon_name(pkmn.species), " (Level ", pkmn.level, ")\n")
            write("  HP: ", pkmn.current_hp, "/", pkmn.max_hp, "\n")
            write("  Attack: ", pkmn.attack, "\n")
            write("  Defense: ", pkmn.defense, "\n")
            write("  Sp. Atk: ", pkmn.sp_atk, "\n")
            write("  Sp. Def: ", pkmn.sp_def, "\n")
            write("  Speed: ", pkmn.speed, "\n")
        endif
    endfor
    // Given an array of attack objects, returns the index of a randomly selected attack.
proc choose_random_attack(attacks: array(4, Attack)) : int
var valid_attacks = new(array, int)
for i in 1..4
if attacks[i].id != 0
valid_attacks.add(i)
endif
endfor
return valid_attacks[random(valid_attacks.len)]

// Given a Pokemon and an attack, returns the amount of damage that the attack would deal.
proc calculate_damage(attacker: Pokemon, defender: Pokemon, attack: Attack) : int
var modifier = calculate_type_effectiveness(attack.type, get_pokemon_type1(defender.species), get_pokemon_type2(defender.species))
var critical = 1.0
if random(16) == 0
critical = 2.0
endif
var random_factor = uniform(0.85, 1.0)
var attack_stat = if attack.category == PHYSICAL then attacker.attack else attacker.sp_atk endif
var defense_stat = if attack.category == PHYSICAL then defender.defense else defender.sp_def endif
var base_power = attack.power
if base_power == 0
return 0
endif
var level = attacker.level
var damage = floor((((2.0 * level + 10.0) / 250.0) * (attack_stat / defense_stat) * base_power + 2.0) * modifier * critical * random_factor)
return damage

// Given a player and enemy team, returns the index of the next Pokemon to send out from the player's team.
proc choose_player_pokemon(player_team: array(MAX_TEAM_SIZE, int), enemy_team: array(MAX_TEAM_SIZE, int)) : int
for i in 1..MAX_TEAM_SIZE
if player_team[i] != 0 and make_pokemon(player_team[i], 50).current_hp > 0
return i
endif
endfor
return 0

// Given a player and enemy team, returns the index of the next Pokemon to send out from the enemy's team.
proc choose_enemy_pokemon(player_team: array(MAX_TEAM_SIZE, int), enemy_team: array(MAX_TEAM_SIZE, int)) : int
for i in 1..MAX_TEAM_SIZE
if enemy_team[i] != 0 and make_pokemon(enemy_team[i], 50).current_hp > 0
return i
endif
endfor
return 0

// Given a Pokemon, returns the number of the highest PP move that the Pokemon knows.
proc get_highest_pp_move(pokemon: Pokemon) : int
var highest_pp = 0
var highest_pp_index = 0
for i in 1..4
if pokemon.known_moves[i] != 0 and pokemon.move_pps[i] > highest_pp
highest_pp = pokemon.move_pps[i]
highest_pp_index = i
endif
endfor
return highest_pp_index
// Given a player and enemy team, returns true if the battle is over.
proc check_battle_over(player_team: array(MAX_TEAM_SIZE, int), enemy_team: array(MAX_TEAM_SIZE, int)) : bool
var player_alive = false
var enemy_alive = false
for i in 1..MAX_TEAM_SIZE
if player_team[i] != 0 and make_pokemon(player_team[i], 50).current_hp > 0
player_alive = true
endif
if enemy_team[i] != 0 and make_pokemon(enemy_team[i], 50).current_hp > 0
enemy_alive = true
endif
endfor
return not (player_alive and enemy_alive)

// Given an array of possible moves for a Pokemon, returns a random move.
proc choose_random_move(possible_moves: seq[Move]) : Move
return possible_moves[rand(1, possible_moves.len)]

// Given a Pokemon and a move, returns the amount of damage the move will do.
proc calculate_damage(attacker: Pokemon, defender: Pokemon, move: Move) : int
var attack_stat: int
var defense_stat: int
if move.move_type == MoveType.PHYSICAL
attack_stat = attacker.attack
defense_stat = defender.defense
else
attack_stat = attacker.sp_atk
defense_stat = defender.sp_def
endif
var effectiveness = get_type_effectiveness(move.move_type, get_pokemon_type(defender.species, 1), get_pokemon_type(defender.species, 2))
var level = attacker.level
var power = move.power
var random_factor = rand(85, 100) / 100.0
var modifier = random_factor * effectiveness * ((2 * level) / 5 + 2) * (attack_stat / defense_stat) * (power / 50) + 2
return floor(modifier)

# Given a player and enemy team, a player move, and an enemy move, executes a turn of the battle and returns a string describing the action.
proc do_battle_turn(player_team: array[MAX_TEAM_SIZE, int], enemy_team: array[MAX_TEAM_SIZE, int], player_move: Move, enemy_move: Move) : string
  const
    PLAYER_TURN = 1
    ENEMY_TURN = 2

  var player_speed = make_pokemon(player_team[1], 50).speed
  var enemy_speed = make_pokemon(enemy_team[1], 50).speed

  var action_order: array[2, int]
  if player_speed >= enemy_speed:
    action_order = [PLAYER_TURN, ENEMY_TURN]
  else:
    action_order = [ENEMY_TURN, PLAYER_TURN]

  var output = ""

  for turn in action_order:
    if turn == PLAYER_TURN:
      var player_pokemon = make_pokemon(player_team[1], 50)
      var enemy_pokemon = make_pokemon(enemy_team[1], 50)
      var damage = calculate_damage(player_pokemon, enemy_pokemon, player_move)
      enemy_pokemon.current_hp -= damage
      if enemy_pokemon.current_hp < 0:
        enemy_pokemon.current_hp = 0
      endif
      output &= "Player's " & get_pokemon_name(player_pokemon.species) & " used " & player_move.move_name & " and did " & damage & " damage!\n"
    else:
      var player_pokemon = make_pokemon(player_team[1], 50)
      var enemy_pokemon = make_pokemon(enemy_team[1], 50)
      var damage = calculate_damage(enemy_pokemon, player_pokemon, enemy_move)
      player_pokemon.current_hp -= damage
      if player_pokemon.current_hp < 0:
        player_pokemon.current_hp = 0
      endif
      output &= "Enemy's " & get_pokemon_name(enemy_pokemon.species) & " used " & enemy_move.move_name & " and did " & damage & " damage!\n"
    endif
  endfor

  return output
// Define mob/monster objects and their behavior

// A monster is a mob that represents a single Pokémon in the game
obj/monster
    var/name = "Unknown" // The name of the monster
    var/type = null      // The type of the monster
    var/hp = 0           // The current hit points of the monster
    var/max_hp = 0       // The maximum hit points of the monster
    var/moves = list()   // The moves that the monster knows
    var/confused = 0     // Whether the monster is confused

    // Initialize the monster's attributes
    New(name as text, type as /type, hp as num, moves as list(/move))
        .name = name
        .type = type
        .hp = hp
        .max_hp = hp
        .moves = moves

    // Use a move on a specified target in a battle
    proc/use_move(target as /mob/monster, move as /move, battle as /battle)
        move.use(battle, self, target)

    // Reduce the monster's hit points by a specified amount
    proc/take_damage(amount as num)
        .hp -= amount
        if (hp <= 0)
            Die()

    // Handle the monster being defeated
    proc/Die()
        // TODO: Implement what happens when a monster is defeated
        // For example, it could be removed from the player's party or sent to a Pokémon Center

// Create a new instance of a monster with the specified attributes
proc/create_monster(name as text, type as /type, hp as num, moves as list(/move))
    var/monster/M = new /monster(name, type, hp, moves)
    return M

// Define a type for each Pokémon type, which includes its strengths and weaknesses
type
    var/name = ""         // The name of the type
    var/weaknesses = list() // The types that this type is weak against
    var/strengths = list()  // The types that this type is strong against

// Define a move, which is an action that a monster can take in a battle
obj/move
    var/name = ""         // The name of the move
    var/type = null       // The type of the move
    var/pp = 0            // The current PP (power points) of the move
    var/max_pp = 0        // The maximum PP of the move
    var/power = 0         // The power of the move (i.e. how much damage it does)
    var/accuracy = 0.0    // The accuracy of the move (i.e. how likely it is to hit the target)
    var/effect = null     // The effect of the move (e.g. raising the user's stats, causing the target to flinch)

    // Initialize the move's attributes
    New(name as text, type as /type, pp as num, power as num, accuracy as num, effect as /effect)
        .name = name
        .type = type
        .pp = pp
        .max_pp = pp
        .power = power
        .accuracy = accuracy
        .effect = effect

    // Use the move in a battle
     proc/use(battle as /battle, user as /mob/monster, target as /mob/monster)
        if (pp > 0)
            pp--
            if (target.type in immunities[type])
                battle.message("%s's %s had no effect on %s's %s!", user.owner.name, user.name, target.owner.name, target.name)
            elif (target.type in resistances[type])
                var/damage = damage_formula(user, target, power, STAB, critical, effectiveness / 2)
                target.hp -= damage
                battle.message("%s's %s did %d damage to %s's %s!", user.owner.name, user.name, damage, target.owner.name, target.name)
            else
                var/damage = damage_formula(user, target, power, STAB, critical, effectiveness)
                target.hp -= damage
                battle.message("%s's %s did %d damage to %s's %s!", user.owner.name, user.name, damage, target.owner.name, target.name)
// Define item objects and their behavior
//
obj/item/usable
    var/name = ""           // The name of the item
    var/description = ""    // The description of the item
    var/use_text = ""       // The text that is displayed when the item is used
    var/use_proc = null     // The procedure that is called when the item is used

    // Initialize the item's attributes
    New(name as text, description as text, use_text as text, use_proc as proc)
        .name = name
        .description = description
        .use_text = use_text
        .use_proc = use_proc

    // Use the item, calling the use procedure and removing it from the player's inventory
    proc/use(player as /mob)
        if (use_proc)
            use_proc(player)
        player.inventory.remove(self)

// A healing item that can restore a player's monster's hit points
obj/item/healing/HP
    inherit usable

    var/amount = 0    // The amount of hit points the item restores

    // Initialize the item's attributes
    New(name as text, description as text, amount as num)
        ..(New(parent, name, description, "You use the " + name + " on your Pokémon!", null))
        .amount = amount

    // Restore the hit points of the targeted monster and display a message to the player
    proc/use(player as /mob)
        var/monster/target = player.owner.select_monster("Select a monster to use the " + name + " on.")
        if (target)
            target.hp += amount
            if (target.hp > target.max_hp)
                target.hp = target.max_hp
            player.client << "You use the " << name << " on " << target.name << "!\n"
        ..(New(parent, name, description, "You use the " + name + " on " + target.name + "!", use_proc))

// A revive item that can revive a fainted monster
obj/item/healing/Revive
    inherit usable

    var/amount = 0    // The amount of hit points the revived monster will have

    // Initialize the item's attributes
    New(name as text, description as text, amount as num)
        ..(New(parent, name, description, "You use the " + name + " on your fainted Pokémon!", null))
        .amount = amount

    // Revive the fainted monster with the specified amount of hit points and display a message to the player
    proc/use(player as /mob)
        var/monster/target = player.owner.select_fainted_monster("Select a fainted monster to revive with the " + name + ".")
        if (target)
            target.hp = amount
            player.client << "You use the " << name << " on " << target.name << "!\n"
        ..(New(parent, name, description, "You use the " + name + " on " + target.name + "!", use_proc))
// Define attack objects and their behavior
// ...
obj/attack
var/name = "" // The name of the attack
var/type = null // The type of the attack
var/power = 0 // The power of the attack
var/accuracy = 0.0 // The accuracy of the attack
var/pp = 0 // The current PP (power points) of the attack
var/max_pp = 0 // The maximum PP of the attack
var/effect = null // The effect of the attack (e.g. raising the user's stats, causing the target to flinch)
// Initialize the attack's attributes
New(name as text, type as /type, power as num, accuracy as num, pp as num, effect as /effect)
    .name = name
    .type = type
    .power = power
    .accuracy = accuracy
    .pp = pp
    .max_pp = pp
    .effect = effect

// Use the attack in a battle
proc/use(battle as /battle, user as /mob/monster, target as /mob/monster)
    // Decrease the PP of the attack by 1
    .pp -= 1
    // Check if the attack hits the target
    if (Rand.Float(1.0) <= accuracy)
        // Calculate the damage done by the attack
        var STAB = 1.5
        if (user.type == type)
            STAB = 2.0
        var effectiveness = type_effectiveness(target.type, type)
        var critical = 1.0
        if (Rand.Float(1.0) <= user.critical_hit_ratio)
            critical = 2.0
        var damage = damage_formula(user, target, power, STAB, critical, effectiveness)
        // Reduce the target's hit points by the calculated damage
        target.take_damage(damage)
        // Check if the attack has an effect
        if (effect != null)
            effect.use(battle, user, target)
        // Print a message to the battle log
        battle.message("%s's %s used %s!", user.owner.name, user.name, name)
        battle.message("%s's %s took %d damage!", target.owner.name, target.name, damage)
    else
        // Print a message to the battle log if the attack misses
        battle.message("%s's %s used %s, but it missed!", user.owner.name, user.name, name)
// Define battle rounds and their behavior
// ...
obj/battle_round
var/attacker = null // The monster that is attacking
var/defender = null // The monster that is defending
var/attacker_move = null // The move that the attacker is using
var/critical = false // Whether the move lands a critical hit
var/effectiveness = 1.0 // The effectiveness of the move (i.e. how much damage it does)
var/battle = null // The battle that the round is taking place in
// Initialize the round's attributes
New(attacker as /mob/monster, defender as /mob/monster, attacker_move as /move, battle as /battle)
    .attacker = attacker
    .defender = defender
    .attacker_move = attacker_move
    .battle = battle

// Execute the round, performing the move and reducing the defender's HP
proc/execute()
    // Calculate whether the move lands a critical hit
    .critical = critical_hit(attacker_move.accuracy)

    // Calculate the effectiveness of the move against the defender's type(s)
    .effectiveness = type_effectiveness(attacker_move.type, defender.type)

    // Use the move on the defender
    attacker.use_move(defender, attacker_move, battle)

    // Check if the defender has been defeated
    if (defender.hp <= 0)
        battle.defeat(defender)

    // If the attacker is confused, there is a chance that it will hit itself in confusion
    if (attacker.confused)
        var/confusion_damage = max(1, round(attacker.max_hp / 4))
        if (random(1, 100) <= 50)
            battle.message("%s is confused and hurt itself in its confusion!", attacker.name)
            attacker.take_damage(confusion_damage)
        else
            battle.message("%s snapped out of its confusion.", attacker.name)

    // If the defender is confused, there is a chance that it will hit itself in confusion
    if (defender.confused)
        var/confusion_damage = max(1, round(defender.max_hp / 4))
        if (random(1, 100) <= 50)
            battle.message("%s is confused and hurt itself in its confusion!", defender.name)
            defender.take_damage(confusion_damage)
        else
            battle.message("%s snapped out of its confusion.", defender.name)

    // If the defender is not defeated, it will use its own move on the attacker
    if (defender.hp > 0)
        // Choose a random move from the defender's move list
        var/defender_move = defender.moves[random(1, defender.moves.len)]

        // Calculate whether the move lands a critical hit
        .critical = critical_hit(defender_move.accuracy)

        // Calculate the effectiveness of the move against the attacker's type(s)
        .effectiveness = type_effectiveness(defender_move.type, attacker.type)

        // Use the move on the attacker
        defender.use_move(attacker, defender_move, battle)

        // Check if the attacker has been defeated
        if (attacker.hp <= 0)
            battle.defeat(attacker)
            // Define a battle, which represents a battle between two trainers
obj/battle
var/player1 = null // The first trainer in the battle
var/player2 = null // The second trainer in the battle
var/current_turn = null // The monster that is currently taking its turn
var/finished = false // Whether the battle has finished
var/winner = null // The trainer that has won the battle

scss

// Initialize the battle's attributes
New(p1 as /obj/trainer, p2 as /obj/trainer)
.player1 = p1
.player2 = p2
// Set the starting turn to a random monster from one of the trainers
.current_turn = p1.team[random(1, p1.team.len)]

// Start the battle
proc/start()
message_all("%s challenges %s to a battle!", player1.name, player2.name)
message_all("%s sends out %s!", player1.name, player1.team[1].name)
message_all("%s sends out %s!", player2.name, player2.team[1].name)
// Start the first round
.next_round()

// End the battle
proc/end(winner as /obj/trainer)
.finished = true
.winner = winner
message_all("%s has defeated %s!", winner.name, IIF(winner == player1, player2.name, player1.name))
// Remove the monsters from the battlefield
for (var/monster in player1.team)
monster.leave_location()
for (var/monster in player2.team)
monster.leave_location()

// Choose the next monster to take a turn and start a new round
proc/next_round()
// Switch to the other player's turn
if (current_turn in player1.team)
.current_turn = player2.team[random(1, player2.team.len)]
else
.current_turn = player1.team[random(1, player1.team.len)]
// Start a new round
var/round = new /obj/battle_round(current_turn, IIF(current_turn in player1.team, player2.team[1], player1.team[1]), null, src)
round.execute()

// Handle a monster being defeated
proc/defeat(monster as /mob/monster)
// Remove the defeated monster from its trainer's team
if (monster in player1.team)
player1.team -= monster
else
player2.team -= monster
// Check if the battle has been won by the other trainer
if (player1.team.len == 0)
.end(player2)
else if (player2.team.len == 0)
.end(player1)
else
// Start the next round
.next_round()

// Broadcast a message to all players in the battle
proc/message_all(text as string)
player1.message(text)
player2.message(text)

// Broadcast a message to all players in the battle, with substitutions for the trainers' names
proc/message_all(text as string, p1_name as string, p2_name as string)
player1.message(text, p1_name, p2_name)
player2.message(text, p1_name, p2_name)

// Check whether a move lands a critical hit
proc/critical_hit(accuracy as num)
if (random(1, 100) <= accuracy)
return (random(1, 100) <= 6) // 6% chance of a critical hit
return false

// Calculate the effectiveness of a move against a monster's type(s)
proc/type_effectiveness(move_type as /type, monster_type as /list)
var/effectiveness = 1
for (var/type in monster_type)
effectiveness *= move_type.effectiveness[type]
return effectiveness

// Calculate the damage a move deals to a target monster
proc/calculate_damage(move as /obj/move, target as /mob/monster)
// Calculate the base damage using the attacker's attack stat and the defender's defense stat
var/base_damage = (2 * current_turn.stats.attack * move.power) / target.stats.defense
// Adjust the base damage by a random factor between 0.85 and 1.00
var/random_factor = random(85, 100) / 100
base_damage *= random_factor
// Calculate the effectiveness of the move against the target monster's type(s)
var/effectiveness = type_effectiveness(move.type, target.types)
// Apply the effectiveness to the base damage
base_damage *= effectiveness
// Apply a critical hit if the move lands one
if (critical_hit(move.accuracy))
base_damage *= 2
// Apply the damage to the target monster's HP
target.stats.hp -= base_damage
// Broadcast a message about the damage dealt
message_all("%s used %s and dealt %d damage to %s!", current_turn.name, move.name, base_damage, target.name)
// Check if the target monster has been defeated
if (target.stats.hp <= 0)
defeat(target)

// Execute a monster's turn in the battle
proc/execute_turn(move as /obj/move, target as /mob/monster)
// Broadcast a message about the move being used
message_all("%s used %s!", current_turn.name, move.name)
// Calculate the damage dealt by the move
calculate_damage(move, target)
// Check if the battle has been won by the other trainer
if (finished)
return
// Switch to the next monster's turn
next_round()

// Object representing a round of the battle, in which each monster gets to take a turn
obj/battle_round
var/attacker = null // The monster that is taking its turn
var/defender = null // The monster that is being attacked
var/move_used = null // The move being used in this round
var/source = null // The source of the battle round (optional)

// Initialize the battle round's attributes
New(attacker as /mob/monster, defender as /mob/monster, move as /obj/move, src as /client/null)
.attacker = attacker
.defender = defender
.move_used = move
.source = src

// Execute the round
proc/execute()
// Broadcast a message that the attacker is taking its turn
message_all("%s is taking its turn!", attacker.name)
// Let the attacker choose a move to use
var/move = attacker.controller.choose_move(attacker, defender, src)
// Execute the attacker's turn
execute_turn(move, defender)

// Let's also add a choose_move() proc to the /obj/player controller to allow them to select a move during a battle:

obj/player
// Choose a move to use during a battle
proc/choose_move(attacker as /mob/monster, defender as /mob/monster, src as /client)
// Display the moves to the player and let them choose one
var/moves = attacker.moves
for (var/i in moves.len)
src << " [i+1]: [moves[i].name] ([moves[i].type.name])"
src << "Choose a move: "
var/choice = input(src, moves.len)
// Return the chosen move
return moves[choice - 1]

// Define battle start and end behavior
// ...
obj/battle

    // The two monsters battling each other
    var/attacker = null
    var/defender = null

    // Whether the battle has ended
    var/ended = 0

    // Start the battle between the attacker and defender
    proc/start(attacker as /mob/monster, defender as /mob/monster)
        .attacker = attacker
        .defender = defender
        battle.message("%s sent out %s!", attacker.owner.name, attacker.name)
        battle.message("%s sent out %s!", defender.owner.name, defender.name)

    // End the battle
    proc/end()
        .ended = 1

    // Handle the attacker using a move on the defender
    proc/attack(move as /move)
        battle.message("%s used %s!", .attacker.name, move.name)
        move.use(self, .attacker, .defender)
        if (.defender.hp <= 0)
            battle.message("%s fainted!", .defender.name)
            battle.end()
// Define helper procedures for battle start and end behavior
// ...
/proc/start_battle(src, target)
    // Start a new battle between the source and target Pokémon
    var /battle = new(/obj/battle)
    battle.add_pokemon(src, BATTLE_SIDE_PLAYER)
    battle.add_pokemon(target, BATTLE_SIDE_OPPONENT)
    battle.start()

/proc/end_battle(battle, winner)
    // End the given battle with the given winner
    battle.end(winner)
    battle.remove()
    if (winner)
        winner.win()
    else
        battle.get_other_pokemon(winner).win()
// Define the AI behavior for computer-controlled monsters in battles

/proc/AI_monster_turn(mob/monster/M, mob/battle/B)
    // Select a move to use based on the monster's moveset and the current battle situation
    var/move/MV = get_move_to_use(M, B)

    // Use the selected move
    use_move(M, B, MV)

/proc/get_move_to_use(mob/monster/M, mob/battle/B)
    // Choose a random move if the monster is confused or there are no remaining PP for any moves
    if (M.confused || !has_moves_with_remaining_pp(M))
        return choose_random_move(M)

    // Determine the most effective move to use against the player's active monster
    var/move/MV = choose_most_effective_move(M, B)

    // If there is no effective move, choose a random move
    if (!MV)
        return choose_random_move(M)

    return MV

/proc/has_moves_with_remaining_pp(mob/monster/M)
    for (var/move/M in M.moves)
        if (M.pp_left(M) > 0)
            return 1
    return 0

/proc/choose_most_effective_move(mob/monster/M, mob/battle/B)
    var/list[effectiveness] effective_moves = list()

    // Check each move for its effectiveness against the player's active monster
    for (var/move/MV in M.moves)
        var/effectiveness/E = MV.type.effectiveness(B.players_active_monster.type)

        // If the move is effective, add it to the list of effective moves
        if (E > 1)
            effective_moves += E

    // Choose the most effective move from the list
    if (effective_moves.len)
        var/effectiveness/MV_E = effective_moves[1]
        for (var/effectiveness/E in effective_moves)
            if (E > MV_E)
                MV_E = E
        return choose_random_move_with_effectiveness(M, B.players_active_monster.type, MV_E)

    return null

/proc/choose_random_move_with_effectiveness(mob/monster/M, type/Type, effectiveness/E)
    var/list[mob/move] moves = list()

    // Add each move with the specified effectiveness to the list
    for (var/move/MV in M.moves)
        if (MV.type.effectiveness(Type) == E)
            moves += MV

    // Choose a random move from the list
    if (moves.len)
        return choose_random(moves)

    return null

/proc/choose_random_move(mob/monster/M)
    // Choose a random move from the monster's moveset
    if (M.moves.len)
        return choose_random(M.moves)

    return null

/proc/use_move(mob/monster/M, mob/battle/B, mob/move/MV)
    // Use the selected move
    M.use_move(B, MV)
    B.message("%s used %s!", M.name, MV.name)

    // If the move has a target, select a target for it
    if (MV.target)
        var/mob/monster/T = B.get_random_opponent(M)
        if (T)
            MV.use(B, M, T)
            B.message("%s's %s hit %s's %s!", M.owner.name, M.name, T.owner.name, T.name)
        else        B.message("%s's %s failed!", M.owner.name, M.name)
    } else { // The move failed, so skip to the next move
        continue
    }
}

// If none of the moves succeeded, just use Struggle
if (!move_used)
    B.message("%s's %s has no moves left!", M.owner.name, M.name)
    var/mob/monster/T = B.get_random_opponent(M)
    if (T)
        M.use_move(B, T, MOVE_Struggle)
        B.message("%s's %s used Struggle!", M.owner.name, M.name)
        B.message("%s's %s hit %s's %s!", M.owner.name, M.name, T.owner.name, T.name)
    else
        B.message("%s's %s has no target!", M.owner.name, M.name)

// Define battle interface and display behavior
// ...
/proc/battle_interface(src, target, src_move, targets)
    // Show the current turn and player status
    var current_turn = 1
    var player_status = "normal"
    var opponent_status = "normal"
    if(src)
        current_turn = src.battle.current_turn
        player_status = src.battle.status
    if(target)
        opponent_status = target.battle.status
    src << "[Battle] Turn " .. current_turn .. ": " .. player_status .. " vs " .. opponent_status

    // Show the moves available to the player
    var src_moves = src.battle.get_moves()
    var move_text = ""
    for(var/move in src_moves)
        move_text = move_text .. "\n" .. move.name .. " (" .. move.pp .. "/" .. move.max_pp .. ")"

    // Show the targets available to the player
    var target_text = ""
    for(var/targ in targets)
        target_text = target_text .. "\n" .. targ.name

    // Show the battle log
    var battle_log = src.battle.get_log()
    for(var/log_entry in battle_log)
        src << log_entry

    // Display the battle interface
    src << "[Battle] Select a move:" .. move_text
    if(targets)
        src << "[Battle] Select a target:" .. target_text

    // Display the move result
    if(src_move)
        var result_text = src_move.use(targets)
        for(var/result_entry in result_text)
            src << result_entry
    src.battle.reset_log()
/proc/battle_end(src, target, result)
    if(src)
        src.battle.reset()
    if(target)
        target.battle.reset()
    src << "[Battle] " .. result
// Define helper procedures for battle interface and display behavior
// ...
// Helper procedure to clear the battle screen
proc/battle_clear_screen()
    for(var i=1; i<=BATTLE_SCREEN_HEIGHT; i++)
        battle_screen << "\n"

// Helper procedure to display the player's Pokemon information
proc/battle_display_player_pokemon(pokemon as /datum/pokemon/pokemon_type)
    battle_screen << "[b]Player's Pokemon:[/b] [color=green]" << pokemon.name << "[/color]\n"
    battle_screen << "HP: [color=green]" << pokemon.hp << "[/color]/" << pokemon.max_hp << "\n"
    battle_screen << "Status: [color=green]" << pokemon.status << "[/color]\n"

// Helper procedure to display the opponent's Pokemon information
proc/battle_display_opponent_pokemon(pokemon as /datum/pokemon/pokemon_type)
    battle_screen << "[b]Opponent's Pokemon:[/b] [color=red]" << pokemon.name << "[/color]\n"
    battle_screen << "HP: [color=red]" << pokemon.hp << "[/color]/" << pokemon.max_hp << "\n"
    battle_screen << "Status: [color=red]" << pokemon.status << "[/color]\n"

// Helper procedure to display the battle menu
proc/battle_display_menu()
    battle_screen << "\n[b]Choose an action:[/b]\n"
    battle_screen << "1. Fight\n"
    battle_screen << "2. Bag\n"
    battle_screen << "3. Pokemon\n"
    battle_screen << "4. Run\n"

// Helper procedure to display the move menu
proc/battle_display_move_menu(pokemon as /datum/pokemon/pokemon_type)
    battle_screen << "\n[b]Choose a move for [color=green]" << pokemon.name << "[/color]:[/b]\n"
    for(var i=1; i<=pokemon.num_moves; i++)
        battle_screen << i << ". " << pokemon.moves[i].name << "\n"


// Define player input behavior and interaction with battle interface
// ...
/ proc/input_loop(src, player, action)
    // Loop until the player either selects an action or forfeits
    while (TRUE)
        // Display the available options and prompt the player for input
        var /options = "1. Fight, 2. Bag, 3. Pokemon, 4. Run"
        var /message = "What will " .. player.name .. " do?\n" .. options
        var /input = input(src, message)

        // Parse the player's input and perform the appropriate action
        if (input == "1")
            // The player has chosen to fight, so prompt them to select a move
            // and target, and then execute the move
            var /move = select_move(src, player)
            var /target = select_target(src, player)
            execute_move(player, target, move)
            break
        else if (input == "2")
            // The player has chosen to access their bag, but that feature
            // is not yet implemented, so display an error message
            view(src, "Sorry, the Bag is not yet implemented.")
        else if (input == "3")
            // The player has chosen to switch Pokemon, so prompt them to
            // select a new active Pokemon and then switch it in
            var /new_pokemon = select_pokemon(src, player)
            switch_pokemon(player, new_pokemon)
            break
        else if (input == "4")
            // The player has chosen to run, so check if they can escape
            // and then end the battle if they can
            if (can_escape(player))
                end_battle(player, "escaped")
            else
                view(src, player.name .. " can't escape!")
        else
            // The player has entered invalid input, so display an error message
            view(src, "Invalid input. Please enter a number between 1 and 4.")
    . = 0 // Return control to the caller

// Define overall behavior of battle system
// ...

// Initialize battle and display initial interface
proc/new_battle(mob/player, mob/opponent)
    // Create new battle object and set initial properties
    battle = new("battle")
    battle.player = player
    battle.opponent = opponent
    battle.player_turn = true
    battle.winner = null

    // Display initial interface and information
    display_battle_interface(battle)
    display_battle_info(battle)

    // Begin main battle loop
    while (not battle.winner)
        if (battle.player_turn)
            // Handle player input and interaction with interface
            handle_player_input(battle)
        else
            // Handle opponent input and interaction with interface
            handle_opponent_input(battle)

        // Check if battle has ended
        if (battle.player.fainted or battle.opponent.fainted)
            end_battle(battle)

// Handle player input and interaction with interface
proc/handle_player_input(battle)
    // Display available actions and prompt for input
    display_battle_actions(battle)
    input = get_player_input(battle)

    // Parse and execute player action
    if (input == "fight")
        // Display available attacks and prompt for input
        display_battle_attacks(battle)
        input = get_player_input(battle)

        // Execute attack and update battle state
        execute_attack(battle, battle.player, battle.opponent, input)
        battle.player_turn = false
    elif (input == "bag")
        // Display available items and prompt for input
        display_battle_items(battle)
        input = get_player_input(battle)

        // Use item and update battle state
        use_item(battle, battle.player, input)
        battle.player_turn = false
    elif (input == "run")
        // Attempt to flee from battle and update battle state
        attempt_flee(battle, battle.player)
        battle.player_turn = false
    elif (input == "pokemon")
        // Switch to another available pokemon and update battle state
        switch_pokemon(battle, battle.player)
        battle.player_turn = false
    else
        // Invalid input, prompt again for valid input
        display_invalid_input_message(battle)

// Handle opponent input and interaction with interface
proc/handle_opponent_input(battle)
    // Determine and execute opponent action
    action = determine_opponent_action(battle)
    execute_opponent_action(battle, action)
    battle.player_turn = true

// Execute attack and update battle state
proc/execute_attack(battle, attacker, defender, attack_name)
    // Determine attack properties and calculate damage
    attack = get_attack_properties(attack_name)
    damage = calculate_damage(attacker, defender, attack)

    // Apply damage to defender and update battle state
    apply_damage(defender, damage)
    update_battle_state(battle)

    // Display attack information and results
    display_attack_info(battle, attacker, defender, attack, damage)

// Use item and update battle state
proc/use_item(battle, user, item_name)
    // Determine item properties and apply effect
    item = get_item_properties(item_name)
    apply_item_effect(user, item)

    // Update battle state
    update_battle_state(battle)
    return winner
    /proc/battle_get_moves(player)
    /* Returns a list of the moves of the player's active Pokemon. */
    var/moves = list()
    for(move in player.pokemon.active.get_moves())
        moves += move.name
    return moves

/proc/battle_get_items(player)
    /* Returns a list of the items in the player's bag. */
    var/items = list()
    for(item in player.bag.get_items())
        items += item.name
    return items

/proc/battle_display_interface(player, battle)
    /* Displays the battle interface for the player. */
    client = player.client

    // Display player's Pokemon and its health
    client << "[b]Your Pokemon:[/b]"
    client << "[b]{player.pokemon.active.name} ({player.pokemon.active.level})[/b]"
    client << "[b]HP:[/b] {player.pokemon.active.current_hp}/{player.pokemon.active.max_hp}"

    // Display opponent's Pokemon and its health
    client << "[b]Opponent's Pokemon:[/b]"
    client << "[b]{battle.opponent_pokemon.name} (Lv. {battle.opponent_pokemon.level})[/b]"
    client << "[b]HP:[/b] {battle.opponent_pokemon.current_hp}/{battle.opponent_pokemon.max_hp}"

    // Display menu options for player's turn
    client << "[b]What will you do?[/b]"
    client << "1. Fight"
    client << "2. Bag"
    client << "3. Pokemon"
    client << "4. Run"

   // Display the list of moves for the player's active Pokemon
    client << "[b]Moves:[/b]"
    for(move in battle_get_moves(player))
        client << move

    // Display the list of items in the player's bag
    client << "[b]Items:[/b]"
    for(item in battle_get_items(player))
        client << item

    // Display status conditions for player's active Pokemon
    if(player.pokemon.active.status != null)
        client << "[b]{player.pokemon.active.name} is {player.pokemon.active.status}[/b]"
  // Display status conditions for opponent's active Pokemon
    if(battle.opponent_pokemon.status != null)
        client << "[b]{battle.opponent_pokemon.name} is {battle.opponent_pokemon.status}[/b]"

/proc/battle_display_turn_summary(player, move, damage, opponent_pokemon)
    /* Displays a summary of the player's turn. */
    client = player.client

    // Display the player's Pokemon and the move used
    client << "[b]{player.pokemon.active.name} used {move.name}![/b]"

    // Display the damage dealt to the opponent's Pokemon
    if(damage > 0)
        client << "[b]{opponent_pokemon.name} took {damage} damage![/b]"
    else
        client << "[b]But it failed![/b]"
        /proc/battle_get_moves(player)
    /* Returns a list of the moves of the player's active Pokemon. */
    var/moves = list()
    for(move in player.pokemon.active.get_moves())
        moves += move.name
    return moves

/proc/battle_get_items(player)
    /* Returns a list of the items in the player's bag. */
    var/items = list()
    for(item in player.bag.get_items())
        items += item.name
    return items

/proc/battle_display_interface(player, battle)
    /* Displays the battle interface for the player. */
    client = player.client

    // Display player's Pokemon and its health
    client << "[b]Your Pokemon:[/b]"
    client << "[b]{player.pokemon.active.name} ({player.pokemon.active.level})[/b]"
    client << "[b]HP:[/b] {player.pokemon.active.current_hp}/{player.pokemon.active.max_hp}"

    // Display opponent's Pokemon and its health
    client << "[b]Opponent's Pokemon:[/b]"
    client << "[b]{battle.opponent_pokemon.name} (Lv. {battle.opponent_pokemon.level})[/b]"
    client << "[b]HP:[/b] {battle.opponent_pokemon.current_hp}/{battle.opponent_pokemon.max_hp}"

    // Display menu options for player's turn
    client << "[b]What will you do?[/b]"
    client << "1. Fight"
    client << "2. Bag"
    client << "3. Pokemon"
    client << "4. Run"

    // Display the list of moves for the player's active Pokemon
    client << "[b]Moves:[/b]"
    for(move in battle_get_moves(player))
        client << move

    // Display the list of items in the player's bag
    client << "[b]Items:[/b]"
    for(item in battle_get_items(player))
        client << item

    // Display status conditions for player's active Pokemon
    if(player.pokemon.active.status != null)
        client << "[b]{player.pokemon.active.name} is {player.pokemon.active.status}[/b]"

    // Display status conditions for opponent's active Pokemon
    if(battle.opponent_pokemon.status != null)
        client << "[b]{battle.opponent_pokemon.name} is {battle.opponent_pokemon.status}[/b]"

/proc/battle_display_turn_summary(player, move, damage, opponent_pokemon)
    /* Displays a summary of the player's turn. */
    client = player.client

    // Display the player's Pokemon and the move used
    client << "[b]{player.pokemon.active.name} used {move.name}![/b]"

    // Display the damage dealt to the opponent's Pokemon
    if(damage > 0)
        client << "[b]{opponent_pokemon.name} took {damage} damage![/b]"
    else
        client << "[b]But it failed![/b]"
            // Display status conditions for player's active Pokemon
    if(player.pokemon.active.status)
        client << "[b]{player.pokemon.active.name} is {player.pokemon.active.status}[/b]"

    // Display status conditions for opponent's active Pokemon
    if(battle.opponent_pokemon.status)
        client << "[b]{battle.opponent_pokemon.name} is {battle.opponent_pokemon.status}[/b]"

/proc/battle_display_victory(player, battle)
    /* Displays the victory screen for the player. */
    client = player.client
    client << "[b]You won the battle![/b]"
    client << "[b]{player.character.name} gained ${battle.reward}[/b]"

/proc/battle_display_defeat(player, battle)
    /* Displays the defeat screen for the player. */
    client = player.client
    client << "[b]You were defeated![/b]"
    client << "[b]You blacked out and were brought to the Pokemon Center.[/b]"
    player.pokemon.heal_all()
