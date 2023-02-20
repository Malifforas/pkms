obj/Movable/MoveTypes
	..var/name
	..var/weaknesses
	..var/resistances

// Move categories
enum
	MOVE_PHYSICAL
	MOVE_SPECIAL
	MOVE_STATUS

// Define the move types and categories
const
	MOVE_TYPE_NORMAL = new /Movable/MoveTypes
		name = "Normal"
		weaknesses = [] // No weaknesses
		resistances = [] // No resistances

	MOVE_TYPE_FIRE = new /Movable/MoveTypes
		name = "Fire"
		weaknesses = [MOVE_TYPE_WATER, MOVE_TYPE_ROCK] // Weak to water and rock moves
		resistances = [MOVE_TYPE_FIRE, MOVE_TYPE_GRASS, MOVE_TYPE_ICE, MOVE_TYPE_BUG] // Resists fire, grass, ice, and bug moves

	MOVE_TYPE_WATER = new /Movable/MoveTypes
		name = "Water"
		weaknesses = [MOVE_TYPE_GRASS, MOVE_TYPE_ELECTRIC] // Weak to grass and electric moves
		resistances = [MOVE_TYPE_FIRE, MOVE_TYPE_WATER, MOVE_TYPE_ICE, MOVE_TYPE_STEEL] // Resists fire, water, ice, and steel moves

	MOVE_TYPE_ELECTRIC = new /Movable/MoveTypes
		name = "Electric"
		weaknesses = [MOVE_TYPE_GROUND] // Weak to ground moves
		resistances = [MOVE_TYPE_ELECTRIC, MOVE_TYPE_FLYING, MOVE_TYPE_STEEL] // Resists electric, flying, and steel moves

	MOVE_TYPE_GRASS = new /Movable/MoveTypes
		name = "Grass"
		weaknesses = [MOVE_TYPE_FIRE, MOVE_TYPE_ICE, MOVE_TYPE_FLYING, MOVE_TYPE_BUG, MOVE_TYPE_POISON] // Weak to fire, ice, flying, bug, and poison moves
		resistances = [MOVE_TYPE_WATER, MOVE_TYPE_GRASS, MOVE_TYPE_ELECTRIC, MOVE_TYPE_GROUND] // Resists water, grass, electric, and ground moves

	MOVE_TYPE_ICE = new /Movable/MoveTypes
		name = "Ice"
		weaknesses = [MOVE_TYPE_FIRE, MOVE_TYPE_FIGHTING, MOVE_TYPE_ROCK, MOVE_TYPE_STEEL] // Weak to fire, fighting, rock, and steel moves
		resistances = [MOVE_TYPE_ICE] // Resists ice moves

	MOVE_TYPE_FIGHTING = new /Movable/MoveTypes
		name = "Fighting"
		weaknesses = [MOVE_TYPE_FLYING, MOVE_TYPE_PSYCHIC, MOVE_TYPE_FAIRY] // Weak to flying, psychic, and fairy moves
		resistances = [MOVE_TYPE_BUG, MOVE_TYPE_ROCK, MOVE_TYPE_DARK] // Resists bug, rock, and dark moves

	MOVE_TYPE_POISON = new /Movable/MoveTypes
		name = "Poison"
		weaknesses = [MOVE_TYPE_GROUND, MOVE_TYPE_PSYCHIC] // Weak to ground and psychic moves
		resistances = [MOVE_TYPE_GRASS, MOVE_TYPE_FIGHTING, MOVE_TYPE_POISON, MOVE_TYPE_BUG, MOVE_TYPE_FAIRY] // Resists grass, fighting, poison, bug, and fairy moves

	MOVE_TYPE_GROUND = new /Movable/MoveTypes
		name = "Ground"
		weaknesses = [MOVE_TYPE_WATER, MOVE_TYPE_GRASS, MOVE_TYPE_ICE] // Weak to water, grass, and ice moves
		resistances = [MOVE_TYPE_POISON, MOVE_TYPE_ROCK] // Resists poison and rock moves
		// Immune to electric moves

	MOVE_TYPE_FLYING = new /Movable/MoveTypes
		name = "Flying"
		weaknesses = [MOVE_TYPE_ELECTRIC, MOVE_TYPE_ICE, MOVE_TYPE_ROCK] // Weak to electric, ice, and rock moves
		resistances = [MOVE_TYPE_GRASS, MOVE_TYPE_FIGHTING, MOVE_TYPE_BUG] // Resists grass, fighting, and bug moves

	MOVE_TYPE_PSYCHIC = new /Movable/MoveTypes
		name = "Psychic"
		weaknesses = [MOVE_TYPE_BUG, MOVE_TYPE_GHOST, MOVE_TYPE_DARK] // Weak to bug, ghost, and dark moves
		resistances = [MOVE_TYPE_FIGHTING, MOVE_TYPE_PSYCHIC] // Resists fighting and psychic moves

	MOVE_TYPE_BUG = new /Movable/MoveTypes
		name = "Bug"
		weaknesses = [MOVE_TYPE_FIRE, MOVE_TYPE_FLYING, MOVE_TYPE_ROCK] // Weak to fire, flying, and rock moves
		resistances = [MOVE_TYPE_GRASS, MOVE_TYPE_FIGHTING, MOVE_TYPE_GROUND] // Resists grass, fighting, and ground moves

	MOVE_TYPE_ROCK = new /Movable/MoveTypes
		name = "Rock"
		weaknesses = [MOVE_TYPE_WATER, MOVE_TYPE_GRASS, MOVE_TYPE_FIGHTING, MOVE_TYPE_GROUND, MOVE_TYPE_STEEL] // Weak to water, grass, fighting, ground, and steel moves
		resistances = [MOVE_TYPE_NORMAL, MOVE_TYPE_FIRE, MOVE_TYPE_POISON, MOVE_TYPE_FLYING] // Resists normal, fire, poison, and flying moves

	MOVE_TYPE_GHOST = new /Movable/MoveTypes
		name = "Ghost"
		weaknesses = [MOVE_TYPE_GHOST, MOVE_TYPE_DARK] // Weak to ghost and dark moves
		resistances = [MOVE_TYPE_POISON, MOVE_TYPE_BUG] // Resists poison and bug moves
		// Immune to normal and fighting moves

	MOVE_TYPE_DRAGON = new /Movable/MoveTypes
		name = "Dragon"
		weaknesses = [MOVE_TYPE_ICE, MOVE_TYPE_DRAGON, MOVE_TYPE_FAIRY] // Weak to ice, dragon, and fairy moves
		resistances = [MOVE_TYPE_FIRE, MOVE_TYPE_WATER, MOVE_TYPE_GRASS, MOVE_TYPE_ELECTRIC] // Resists fire, water, grass, and electric moves
		MOVE_TYPE_DARK = new /Movable/MoveTypes
	name = "Dark"
	weaknesses = [MOVE_TYPE_FIGHTING, MOVE_TYPE_BUG, MOVE_TYPE_FAIRY] // Weak to fighting, bug, and fairy moves
	resistances = [MOVE_TYPE_GHOST, MOVE_TYPE_DARK] // Resists ghost and dark moves

MOVE_TYPE_STEEL = new /Movable/MoveTypes
	name = "Steel"
	weaknesses = [MOVE_TYPE_FIRE, MOVE_TYPE_FIGHTING, MOVE_TYPE_GROUND] // Weak to fire, fighting, and ground moves
	resistances = [MOVE_TYPE_NORMAL, MOVE_TYPE_GRASS, MOVE_TYPE_ICE, MOVE_TYPE_FLYING, MOVE_TYPE_PSYCHIC, MOVE_TYPE_BUG, MOVE_TYPE_ROCK, MOVE_TYPE_DRAGON, MOVE_TYPE_STEEL, MOVE_TYPE_FAIRY] // Resists normal, grass, ice, flying, psychic, bug, rock, dragon, steel, and fairy moves
	// Define the move categories
const
MOVE_CATEGORY_PHYSICAL = new /Movable/MoveCategories
name = "Physical"

java

MOVE_CATEGORY_SPECIAL = new /Movable/MoveCategories
	name = "Special"

MOVE_CATEGORY_STATUS = new /Movable/MoveCategories
	name = "Status"

