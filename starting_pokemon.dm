// Define starting Pokemon choices
#define STARTER_CHIKORITA  1
#define STARTER_CYNDIQUIL  2
#define STARTER_TOTODILE   3

// Create a proc to handle player's selection of starting Pokemon
/proc/select_starter(src, starter)
    var/mob/l = src
    var/starter_name

    // Assign chosen starter based on input value
    switch(starter)
        STARTER_CHIKORITA:
            starter_name = "Chikorita"
        STARTER_CYNDIQUIL:
            starter_name = "Cyndaquil"
        STARTER_TOTODILE:
            starter_name = "Totodile"
        else:
            return

    // Spawn the chosen starter Pokemon
    var/pokemon = spawn(starter_name, l.loc)

    // Add the Pokemon to the player's party
    l.party += pokemon
    l.add_to_pokedex(pokemon)
    pokemon.owner = l
    l.pokemon_spawned(pokemon)
    l.client.ShowMessage("You chose " + starter_name + "!")
    del(src.ui_start)
    return
