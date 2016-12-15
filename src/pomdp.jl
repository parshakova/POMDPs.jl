# POMDP model functions
"""
Abstract base type for a partially observable Markov decision process.

    S: state type
    A: action type
    O: observation type
"""
abstract POMDP{S,A,O}

"""
Abstract base type for a fully observable Markov decision process.

    S: state type
    A: action type
"""
abstract MDP{S,A}

"""
Abstract type for a probability distribution.

    T: type over which distribution is over (state, action, or observation)
"""
abstract AbstractDistribution{T}

"""
    n_states(problem::POMDP)
    n_states(problem::MDP)

Return the number of states in `problem`. Used for discrete models only.
"""
function n_states end

"""
    n_actions(problem::POMDP)
    n_actions(problem::MDP)

Return the number of actions in `problem`. Used for discrete models only.
"""
function n_actions end

"""
    n_observations(problem::POMDP)

Return the number of actions in `problem`. Used for discrete models only.
"""
function n_observations end

"""
    discount(problem::POMDP)
    discount(problem::MDP)

Return the discount factor for the problem.
"""
discount(::Union{MDP,POMDP}) = 1.0

"""
    transition{S,A,O}(problem::POMDP{S,A,O}, state::S, action::A)
    transition{S,A}(problem::MDP{S,A}, state::S, action::A)

Return the transition distribution from the current state-action pair
"""
function transition end

"""
    observation{S,A,O}(problem::POMDP{S,A,O}, action::A, statep::S)

Return the observation distribution for the a-s' tuple (action and next state) and returns it
"""
function observation end

"""
    observation{S,A,O}(problem::POMDP{S,A,O}, state::S, action::A, statep::S)

Return the observation distribution for the s-a-s' tuple (state, action, and next state)
"""
observation{S,A,O}(problem::POMDP{S,A,O}, s::S, a::A, sp::S) = observation(problem, a, sp) 
function implemented{P<:POMDP,S,A}(f::typeof(observation), TT::Type{Tuple{P,S,A,S}})
    m = which(f,TT)
    if m.module == POMDPs && !implemented(f, Tuple{P, A, S})
        return false
    else # a more specific implementation exists
        return true
    end
end

"""
    reward{S,A,O}(problem::POMDP{S,A,O}, state::S, action::A)
    reward{S,A}(problem::MDP{S,A}, state::S, action::A)

Return the immediate reward for the s-a pair
"""
function reward end

"""
    reward{S,A,O}(problem::POMDP{S,A,O}, state::S, action::A, statep::S)
    reward{S,A}(problem::MDP{S,A}, state::S, action::A, statep::S)

Return the immediate reward for the s-a-s' triple
"""
reward{S,A}(problem::Union{POMDP{S,A},MDP{S,A}}, s::S, a::A, sp::S) = reward(problem, s, a)
function implemented{P<:POMDP,S,A}(f::typeof(reward), TT::Type{Tuple{P,S,A,S}})
    m = which(f,TT)
    if m.module == POMDPs && !implemented(f, Tuple{P, S, A})
        return false
    else # a more specific implementation exists
        return true
    end
end

"""
    isterminal_obs{S,A,O}(problem::POMDP{S,A,O}, observation::O)

Check if an observation is terminal.
"""
isterminal_obs{S,A,O}(problem::POMDP{S,A,O}, observation::O) = false

"""
    isterminal{S,A,O}(problem::POMDP{S,A,O}, state::S)
    isterminal{S,A}(problem::MDP{S,A}, state::S)

Check if state s is terminal
"""
isterminal{S,A}(problem::Union{POMDP{S,A},MDP{S,A}}, state::S) = false

"""
    state_index{S,A,O}(problem::POMDP{S,A,O}, s::S)
    state_index{S,A}(problem::MDP{S,A}, s::S)

Return the integer index of state `s`. Used for discrete models only.
"""
function state_index end

"""
    action_index{S,A,O}(problem::POMDP{S,A,O}, a::A)
    action_index{S,A}(problem::MDP{S,A}, a::A)

Return the integer index of action `a`. Used for discrete models only.
"""
function action_index end

"""
    obs_index{S,A,O}(problem::POMDP{S,A,O}, o::O)

Return the integer index of observation `o`. Used for discrete models only.
"""
function obs_index end

"""
    vec{SO}(problem::Union{MDP{SO},POMDP{SO}}, so::S)

Convert a state or observaton to vectorized form of floats.
"""
Base.vec
