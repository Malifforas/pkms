/*// File: johto_mud.dm
// Main game loop and initialization

// Include files
#include "maps.dm"
#include "character.dm"
#include "pokemon.dm"
#include "npcs.dm"
#include "items.dm"
#include "evolutions.dm"
#include "moves.dm"
#include "abilities.dm"
#include "stats.dm"
#include "status_effects.dm"
#include "pokeballs.dm"
#include "badges.dm"
#include "trading.dm"
#include "battles.dm"
#include "multiplayer_battles.dm"
#include "story.dm"
#include "weather.dm"
#include "save_load.dm"

// Initialize game variables
world
	var
	// Player variables
		client as /mob/proc
		client_id as text
		player as /mob/Player
	// Game variables
		game_start as datum
		game_end as datum
	// Battle variables
		enemy as /mob/Enemy
		enemy_pokemon as /obj/Pokemon
		player_pokemon as /obj/Pokemon
		player_team as /list
	// Map variables
		cur_map as /datum/map
		cur_pos as /turf
	// Item variables
		item_choice as /obj/Item
		item_target as /mob
		item_target_pos as /turf
	// Trading variables
		trade_partner as /mob/Player
		trade_request as /mob/Player
		trade_partner_name as text
		trade_request_name as text
		trade_status as text
	// Save variables
		save_data as /savefile
		save_slot as text
		save_exists as num

// Load the game
proc /world/LoadGame()
	LoadMaps()
	LoadItems()
	LoadAbilities()
	LoadMoves()
	LoadStats()
	LoadStatusEffects()
	LoadPokeballs()
	LoadBadges()
	LoadEvolutions()
	LoadStory()
	LoadNPCs()
	LoadPokemon()
	LoadTrading()

// Initialize the game
proc /world/NewGame()
	world.game_start = world.time
	player = New(/mob/Player)
	player.client = world.client
	player.pokemon = New(/obj/Pokemon)
	player.pokemon.InitStats(5, "Totodile")
	player_team = NewList()
	player_team.Add(player.pokemon)
	player.pokemon.AddExp(1)
	player.cur_map = "New Bark Town"
	player.cur_pos = locate("player_start", player.cur_map)
	player.Move(player.cur_pos)
	Broadcast("Welcome to the world of Pokémon!")
	Broadcast("Press H for help.")
	Broadcast("Your journey through the Johto region begins now!")
	save_data = New(/savefile)
	save_exists = 0

// Main game loop
world
	var
		action as text

NewGame()

while (!IsGameEnded())
	world.client = null
	world.client_id = ""
	while (world.client == null)
		sleep(1)
		world.client_id = world.client.key
		world.client << "Welcome to Johto MUD!"
		world.client << "Please enter your character name: "
	player.name = world.client.locate(world.client_id).Read()
	world.client.locate(world.client_id).Clear()
	while (!player.IsDead())
		action = player.GetAction()
		if (action != "")
			switch (action)
			// Movement commands
case "n":
	player.Move(player.cur_pos.north)
case "s":
	player.Move(player.cur_pos.south)
case "e":
	player.Move(player.cur_pos.east)
case "w":
	player.Move(player.cur_pos.west)

// Player interaction commands
case "talk":
	if(player.cur_pos.has_npc)
		var/npc = player.cur_pos.npc
		// Display the NPC's dialogue to the player
		player << npc.dialogue
	else
		player << "There's no one to talk to here."
case "search":
	if(player.cur_pos.has_item)
		var/item = player.cur_pos.item
		// Add the item to the player's inventory
		player.inventory += item
		player.cur_pos.has_item = false
		player << "You found a " + item.name + "!"
	else
		player << "There's nothing to find here."

// Inventory management commands
case "inventory":
	player.ShowInventory()

// Battle commands
case "fight":
	if(player.cur_pos.has_wild_pokemon)
		var/wild_pokemon = player.cur_pos.wild_pokemon
		// Start a battle with the wild Pokemon
		player.StartBattle(wild_pokemon)
	else
		player << "There's no Pokemon to battle here."

// Trading commands
case "trade":
	if(player.cur_pos.has_trade_center)
		var/trade_center = player.cur_pos.trade_center
		// Open the trade center menu
		player.OpenTradeMenu(trade_center)
	else
		player << "There's no trade center here."

// Help command
case "h":
	player.ShowHelp()

// Save command
case "save":
	SaveGame()

// Quit command
case "q":
	if (player.IsInBattle())
		player << "You can't quit during a battle!"
	else
		Broadcast(player.name + " has left the game.")
		Quit()

// Unknown command
default:
	player << "Unknown command. Type H for help."
		}
		sleep(1)
	}

// End the game
world.game_end = world.time
Broadcast("Thanks for playing!")
Quit()