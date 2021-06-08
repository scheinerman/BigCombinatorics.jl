using Combinatorics, BigCombinatorics

"""
    distinct(vec)

Check if a list of integers `vec` are all distinct.
"""
function distinct(vec::Vector{Int})::Bool
    list = sort(vec)
    if length(list) < 2
        return true
    end
    d = diff(list)
    return !any(iszero, d)
end

"""
    check(n)

Count all partitions of `n` with distinct parts and check to see 
if the count agrees with the result of `IntPartitionsDistinct(n)`.
"""
function check(n::Int)
    ptns = integer_partitions(n)
    dpts = filter(distinct, ptns)
    a = length(dpts)
    b = IntPartitionsDistinct(n)
    return a == b
end
