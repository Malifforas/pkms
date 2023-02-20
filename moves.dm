// Move objects
obj/Movable/Moves
    ..proc/init()
    ..proc/Destroy()
    ..var/name
    ..var/type
    ..var/category
    ..var/power
    ..var/accuracy
    ..var/pp
    ..var/effect_chance
    ..var/priority
    ..var/effect
    ..var/description
    ..var/move_type = null
    ..var/move_effects = new(list())
    ..var/status_condition = null
    ..var/status_effect_chance = 0
    ..var/secondary_effect_chance = 0
    ..var/secondary_effect = null
    ..var/critical_hit_rate = 1

    // Get the move's type
    proc/GetType()
        return move_type

    // Set the move's type
    proc/SetType(type)
        move_type = type

    // Get the move's effects
    proc/GetEffects()
        return move_effects

    // Add an effect to the move
    proc/AddEffect(effect, effect_args)
        move_effect = new(MoveEffects)
        move_effect.effect_name = effect
        move_effect.Apply(effect_args)
        move_effects.add(move_effect)

    // Get the move's status condition
    proc/GetStatusCondition()
        return status_condition

    // Set the move's status condition
    proc/SetStatusCondition(condition, effect_chance)
        status_condition = condition
        status_effect_chance = effect_chance

    // Get the move's secondary effect
    proc/GetSecondaryEffect()
        return secondary_effect

    // Set the move's secondary effect
    proc/SetSecondaryEffect(effect, effect_chance)
        secondary_effect = effect
        secondary_effect_chance = effect_chance

    // Get the move's critical hit rate
    proc/GetCriticalHitRate()
        return critical_hit_rate

    // Set the move's critical hit rate
    proc/SetCriticalHitRate(rate)
        critical_hit_rate = rate