// type_chart.dm

type enum PokemonType
    Normal
    Fire
    Water
    Electric
    Grass
    Ice
    Fighting
    Poison
    Ground
    Flying
    Psychic
    Bug
    Rock
    Ghost
    Dragon
    Dark
    Steel
    Fairy
end

type struct TypeEffectiveness
    neutral: list(PokemonType)
    superEffective: list(PokemonType)
    notVeryEffective: list(PokemonType)
    immune: list(PokemonType)
end

global const TYPE_CHART: array(PokemonType, TypeEffectiveness) = [
    Normal: TypeEffectiveness(neutral=[Rock, Steel], superEffective=[], notVeryEffective=[Ghost], immune=[]),
    Fire: TypeEffectiveness(neutral=[Fire, Water, Rock, Dragon], superEffective=[Grass, Ice, Bug, Steel], notVeryEffective=[Fire, Water, Rock, Dragon], immune=[]),
    Water: TypeEffectiveness(neutral=[Water, Grass, Dragon], superEffective=[Fire, Ground, Rock], notVeryEffective=[Water, Grass, Dragon], immune=[]),
    Electric: TypeEffectiveness(neutral=[Electric, Flying, Steel], superEffective=[Water, Flying], notVeryEffective=[Electric, Grass, Dragon], immune=[Ground]),
    Grass: TypeEffectiveness(neutral=[Fire, Grass, Poison, Flying, Bug, Dragon, Steel], superEffective=[Water, Ground, Rock], notVeryEffective=[Fire, Grass, Poison, Flying, Bug, Dragon, Steel], immune=[]),
    Ice: TypeEffectiveness(neutral=[Ice, Water, Flying, Dragon], superEffective=[Grass, Ground, Flying, Dragon], notVeryEffective=[Fire, Water, Ice, Steel], immune=[]),
    Fighting: TypeEffectiveness(neutral=[Bug, Rock, Dark], superEffective=[Normal, Ice, Rock, Dark, Steel], notVeryEffective=[Poison, Flying, Psychic, Bug, Fairy], immune=[Ghost]),
    Poison: TypeEffectiveness(neutral=[Grass, Fighting, Poison, Bug, Fairy], superEffective=[Grass, Fairy], notVeryEffective=[Poison, Ground, Rock, Ghost], immune=[Steel]),
    Ground: TypeEffectiveness(neutral=[Poison, Rock, Steel], superEffective=[Fire, Electric, Poison, Rock, Steel], notVeryEffective=[Grass, Bug], immune=[Flying]),
    Flying: TypeEffectiveness(neutral=[Grass, Fighting, Bug], superEffective=[Grass, Fighting, Bug], notVeryEffective=[Electric, Rock, Steel], immune=[]),
    Psychic: TypeEffectiveness(neutral=[Fighting, Psychic], superEffective=[Poison, Dark], notVeryEffective=[Psychic, Steel], immune=[Dark]),
    Bug: TypeEffectiveness(neutral=[Grass, Fighting, Ground], superEffective=[Grass, Psychic, Dark], notVeryEffective=[Fire, Fighting, Poison, Flying, Ghost, Steel, Fairy], immune=[]),
    Rock: TypeEffectiveness(neutral=[Normal, Fire, Poison, Flying], superEffective=[Fire, Ice, Flying, Bug], notVeryEffective=[Fighting, Ground, Steel], immune=[]),
    Ghost: TypeEffectiveness(neutral=[Poison, Bug], superEffective=[Psychic, Ghost], notVeryEffective=[Dark, Normal], immune=[Normal])
    Dragon: TypeEffectiveness(neutral=[Fire, Water, Electric, Grass], superEffective=[Dragon], notVeryEffective=[Steel], immune=[Fairy]),
    Dark: TypeEffectiveness(neutral=[Ghost, Psychic], superEffective=[Ghost, Dark], notVeryEffective=[Fighting, Dark, Fairy], immune=[]),
    Steel: TypeEffectiveness(neutral=[Normal, Grass, Ice, Flying, Psychic, Bug, Rock, Dragon, Steel, Fairy], superEffective=[Ice, Rock, Fairy], notVeryEffective=[Fire, Water, Electric, Steel], immune=[]),
    Fairy: TypeEffectiveness(neutral=[Fighting, Bug, Dark], superEffective=[Fighting, Dragon, Dark], notVeryEffective=[Fire, Poison, Steel], immune=[Dragon])