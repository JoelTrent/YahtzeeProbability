using Random, Distributions

function roll_dice(num_to_roll::Int)
    rand(1:6, num_to_roll)
end

function roll_dice_recursive(dice::Vector{<:Int}, num_to_roll::Int, turns_left::Int)
    if turns_left == 0
        return false
    end
    rolled_dice = roll_dice(num_to_roll)

    for die in rolled_dice
        dice[die] += 1
    end

    # choose which to keep
    keep = argmax(dice)
    dice[keep] == 5 && return true

    for die in setdiff(1:6, keep)
        dice[die] = 0
    end

    return roll_dice_recursive(dice, 5-dice[keep], turns_left-1)
end

function simulate_yahtzee(n)
    successes=0
    for _ in 1:n
        dice = zeros(Int, 6)
        successes += roll_dice_recursive(dice, 5, 3)
    end

    return successes/n
end

# probability of getting a yahtzee in a turn
yahtzee_probability = simulate_yahtzee(10000000)

# probability of getting exactly three yahtzees in six distinct turns
pdf(Binomial(6, yahtzee_probability), 3)

# average number of six turns you'd need to play out to get exactly three 
# yahtzees in those six turns
1 / pdf(Binomial(6, yahtzee_probability), 3)