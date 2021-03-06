module BigCombinatorics

export Fibonacci
export Factorial, DoubleFactorial, FallingFactorial, RisingFactorial, HyperFactorial
export Binomial, Catalan
export Derangements, MultiChoose, Multinomial
export Bell, Stirling1, Stirling2
export IntPartitions, IntPartitionsDistinct
export Euler, PowerSum, Menage

"""
This is where we cache values already computed
"""
_master_table = Dict{Function,Dict}()


"""
    _save(f::Function, x, val::BigInt)

Save the computed value of `f` with argument(s) `x` and value `val`.
"""
function _save(f::Function, x, val::BigInt)
    d = _master_table[f]
    d[x] = val
    nothing
end


"""
    _has(f::Function, x)

Check if argument `x` for function `f` is already in the `_master_table`.
"""
function _has(f::Function, x)::Bool
    d = _master_table[f]
    return haskey(d, x)
end

"""
    _max_arg(f::Function)

Find the largest argument known for `f`. Note that `f` must be a function
of just a single value.
"""
function _max_arg(f::Function)
    tab = _master_table[f]
    return maximum(keys(tab))
end


"""
    _get(f::Function, x)

Retrieve the function value `f(x)` from the `_master_table`.
"""
function _get(f::Function, x)::BigInt
    d = _master_table[f]
    return d[x]
end


"""
    _make(f::Function, T::Type)

Create an entry in the `_master_table` for the function `f`.
"""
function _make(f::Function, T::Type)
    _master_table[f] = Dict{T,BigInt}()
    nothing
end

"""
`BigCombinatorics.cache_report()` reports how many
entries are saved for each function in the `BigCombinatorics`
module.
"""
function cache_report()
    total = 0
    for func in keys(_master_table)
        parse_func = split(string(func), ".")
        func_name = last(parse_func)
        sz = length(_master_table[func])
        total += sz
        println("$sz\t$func_name")
    end
    println()
    println("$total\tTotal entries")
    nothing
end




"""
    BigCombinatorics.cache_clear()
    
Clears all cached values.
"""
function cache_clear()
    for f in keys(_master_table)
        f()
    end
    nothing
end

"""
`Fibonacci(n)` returns the `n`-th Fibonacci number.
We begin with `Fibonacci(0)==0` and `Fibonacci(1)==1`.
See https://oeis.org/A000045
"""
function Fibonacci(n::Integer)::BigInt
    if n < 0
        throw(DomainError(n, "argument must be nonngative"))
    end

    if _has(Fibonacci, n)
        return _get(Fibonacci, n)
    end

    start = _max_arg(Fibonacci) + 1
    for m = start:n
        val = _get(Fibonacci, m - 1) + _get(Fibonacci, m - 2)
        _save(Fibonacci, m, val)
    end

    return _get(Fibonacci, n)
end

function Fibonacci()
    _make(Fibonacci, Integer)
    _save(Fibonacci, 0, big(0))
    _save(Fibonacci, 1, big(1))
end
Fibonacci()

"""
`Factorial(n)` returns `n!` for nonnegative integers `n`.
See https://oeis.org/A000142 

`Factorial(n,k)` returns `n!/k!` (to be consistent with Julia's
`factorial`.) Requires `0 <= k <= n`.

See also `FallingFactorial` and `RisingFactorial`.
"""
function Factorial(n::Integer)::BigInt
    if n < 0
        throw(DomainError(n, "argument must be nonngative"))
    end
    return factorial(big(n))
end

function Factorial(n::Integer, k::Integer)::BigInt
    if k > n
        throw(DomainError((n, k), "$k cannot exceed $n"))
    end
    return div(Factorial(n), Factorial(k))
end

"""
    FallingFactorial(n,k)

returns `n*(n-1)*(n-2)*...*(n-k+1)`
(with a total of `k` factors). Requires `n,k >= 0`.
If `k>n` then `0` is returned.
"""
function FallingFactorial(n::Integer, k::Integer)::BigInt
    if n < 0 || k < 0
        throw(DomainError((n, k), " arguments must be nonnegative"))
    end
    if k > n
        return big(0)
    end
    return Factorial(n, n - k)
end


"""
    RisingFactorial(n,k)

returns `n*(n+1)*(n+2)*...*(n+k-1)`
(with a total of `k` factors). Requires `n,k >= 0`.
"""
function RisingFactorial(n::Integer, k::Integer)::BigInt
    if n < 0 || k < 0
        throw(DomainError((n, k), "arguments must be nonnegative"))
    end
    if k == 0
        return big(1)
    end
    if n == 0
        return big(0)
    end

    return FallingFactorial(n + k - 1, k)
end


"""
    DoubleFactorial(n)

returns `n!!`, i.e., `n*(n-2)*...` with `(-1)!! == 0!! == 1!! == 1`.
See https://oeis.org/A006882
"""
function DoubleFactorial(n::Integer)::BigInt
    if n < -1
        throw(DomainError(n, "argument must be at least -1"))
    end
    if _has(DoubleFactorial, n)
        return _get(DoubleFactorial, n)
    end

    start = _max_arg(DoubleFactorial) + 1
    for m = start:n
        val = m * _get(DoubleFactorial, m - 2)
        _save(DoubleFactorial, m, val)
    end

    return _get(DoubleFactorial, n)
end

function DoubleFactorial()
    _make(DoubleFactorial, Integer)
    _save(DoubleFactorial, -1, big(1))
    _save(DoubleFactorial, 0, big(1))
    _save(DoubleFactorial, 1, big(1))
end
DoubleFactorial()


"""
    HyperFactorial(n)

returns the hyperfactorial of `n`, that is 
`1^1 * 2^2 * 3^3 * ... * n^n`.
See https://oeis.org/A002109
"""
function HyperFactorial(n::Integer)::BigInt
    if n < 0
        throw(DomainError(n, "arument must be nonnegative"))
    end

    if _has(HyperFactorial, n)
        return _get(HyperFactorial, n)
    end
    start = _max_arg(HyperFactorial) + 1
    for m = start:n
        val = (big(m))^m * _get(HyperFactorial, m - 1)
        _save(HyperFactorial, m, val)
    end
    return _get(HyperFactorial, n)
end

function HyperFactorial()
    _make(HyperFactorial, Integer)
    _save(HyperFactorial, 0, big(1))
    _save(HyperFactorial, 1, big(1))
end
HyperFactorial()


"""
    Binomial(n,k)

returns the binomial coefficient `n`-choose-`k`.
This is the number of `k`-element subsets of an `n`-element set.
See https://oeis.org/A007318
"""
Binomial(n::Integer, k::Integer) = binomial(big(n), big(k))::BigInt


"""
    Multinomial(vec)

returns the multinomial coefficient whose
top index is the sum of `vec` (an array of `Int`s) and whose
bottom indices are given by `vec`.

This may also be called with a common-separated list of arguments,
that is, either of `Multinomial([1,2,3])` or `Multinomial(1,2,3)`.
The result is `60` in both cases as these equal `6!/(1! 2! 3!)`.

**Warning**: This is not the same as `MultiChoose`.
"""
function Multinomial(v...)::BigInt
    nv = length(v)
    for i = 1:nv
        typeof(v[i]) <: Integer || throw(DomainError(v, "arguments must be integers"))
        v[i] >= 0 || throw(DomainError(v, "arguments must be nonngative"))
    end
    vals = [t for t in v]
    return Multinomial(vals)
end

Multinomial() = big(1)::BigInt

function Multinomial(vals::Vector{T})::BigInt where {T<:Integer}
    if any([t < 0 for t in vals])
        throw(DomainError(vals, "arguments must be nonnegative"))
    end

    nv = length(vals)
    n = sum(vals)
    # base cases
    if nv <= 1 || n == 0
        return big(1)
    end
    # reduce
    return Binomial(n, vals[end]) * Multinomial(vals[1:nv-1])
end


"""
    MultiChoose(n,k)

returns the number of `k`-element
*multisets* that can be formed using the elements of an
`n`-element set.

**Warning**: This is not the same as `Multinomial`.
"""
function MultiChoose(n::Integer, k::Integer)::BigInt
    return Binomial(n + k - 1, k)
end

"""
    Catalan(n)

returns the `n`-th Catalan number. 
See https://oeis.org/A000108
"""
function Catalan(n::Integer)::BigInt
    n >= 0 || throw(DomainError(n, "argument must be nonnegative"))
    return div(Binomial(2n, n), n + 1)
end


"""
    Derangements(n)

returns the number of permutations of
an `n`-set that have no fixed point.
See https://oeis.org/A000166
"""
function Derangements(n::Integer)::BigInt
    if n < 0
        throw(DomainError(n, "argument must be nonnegative"))
    end
    if _has(Derangements, n)
        return _get(Derangements, n)
    end

    start = _max_arg(Derangements) + 1
    for m = start:n
        s = (m % 2 == 0) ? 1 : -1
        val = m * _get(Derangements, m - 1) + s
        _save(Derangements, m, val)
    end
    return _get(Derangements, n)
end


function Derangements()
    _make(Derangements, Integer)
    _save(Derangements, 0, big(1))
    _save(Derangements, 1, big(0))
end
Derangements()



"""
    Bell(n)

gives the `n`-th Bell number, that is,
the number of partitions of an `n`-element set.
See https://oeis.org/A000110
"""
function Bell(n::Integer)::BigInt
    if n < 0
        throw(DomainError(n, "argument must be nonnegative"))
    end

    if _has(Bell, n)
        return _get(Bell, n)
    end

    start = _max_arg(Bell) + 1
    for m = start:n
        val = big(0)
        for k = 0:m-1
            val += Binomial(m - 1, k) * Bell(k)
        end
        _save(Bell, m, val)
    end

    return _get(Bell, n)
end

function Bell()
    _make(Bell, Integer)
    _save(Bell, 0, big(1))
    _save(Bell, 1, big(1))
end
Bell()

"""
    Stirling2(n,k)

gives the Stirling number of the second kind,
that is, the number of paritions of an `n`-set into `k`-parts."
See https://oeis.org/A008277
"""
function Stirling2(n::Integer, k::Integer)::BigInt
    # special cases
    if k < 0 || n < 0
        throw(DomainError((n, k), "arguments must be nonnegative"))
    end

    if k > n
        return big(0)
    end

    if n == 0  # and by logic, k==0
        return big(1)
    end

    if k == 0
        return big(0)
    end

    if n == k
        return big(1)
    end
    # END OF SPECIAL CASES, invoke recursion
    if _has(Stirling2, (n, k))
        return _get(Stirling2, (n, k))
    end

    val = Stirling2(n - 1, k - 1) + Stirling2(n - 1, k) * k
    _save(Stirling2, (n, k), val)
    return val
end
function Stirling2()
    _make(Stirling2, Tuple{Integer,Integer})
end
Stirling2()


"""
    Stirling1(n,k)

gives the (signed) Stirling number
of the first kind, that is, the coefficient of `x^k`
in the poynomial `x(x-1)(x-2)...(x-n+1)`.
See https://oeis.org/A008275
"""
function Stirling1(n::Integer, k::Integer)::BigInt
    # special cases
    if k < 0 || n < 0
        throw(DomainError((n, k), "arguments must be nonnegative"))
    end

    if k > n
        return big(0)
    end

    if n == 0  # and, by logic, k==0
        return big(1)
    end

    if k == 0  # and, by logic, n>0
        return big(0)
    end

    if _has(Stirling1, (n, k))
        return _get(Stirling1, (n, k))
    end

    # end of special cases, invoke recursion

    val = Stirling1(n - 1, k - 1) - (n - 1) * Stirling1(n - 1, k)
    _save(Stirling1, (n, k), val)
    return val
end
function Stirling1()
    _make(Stirling1, Tuple{Integer,Integer})
end
Stirling1()

"""
`IntPartitions(n)` is the number of partitions of the integer `n`.
See https://oeis.org/A000041

`IntPartitions(n,k)` is the number of partitions of the integer
`n` with exactly `k` (nonzero) parts.
"""
function IntPartitions(n::Integer, k::Integer)::BigInt
    if n < 0 || k < 0
        throw(DomainError((n, k), "arguments must be nonnegative"))
    end
    # lots of special cases
    if k > n
        return big(0)
    end
    if n == 0
        return big(1)
    end
    if k == 0
        return big(0)
    end
    if k == n || k == 1
        return big(1)
    end
    if _has(IntPartitions, (n, k))
        return _get(IntPartitions, (n, k))
    end

    val = sum([IntPartitions(n - k, i) for i = 0:k])
    _save(IntPartitions, (n, k), val)
    return val
end

function IntPartitions(n::Integer)::BigInt
    if n < 0
        throw(DomainError(n, "argument must be nonnegative"))
    end
    if _has(IntPartitions, n)
        return _get(IntPartitions, n)
    end
    val = sum([IntPartitions(n, k) for k = 0:n])
    _save(IntPartitions, n, val)
    return val
end
function IntPartitions()
    _make(IntPartitions, Union{Tuple{Integer,Integer},Integer})
end
IntPartitions()

"""
`IntPartitionsDistinct(n,k)` is the number of partitions of
the integer `n` into exactly `k` *distinct* parts.

`IntPartitionsDistinct(n)` is the number of partitions of `n`
into *distinct* parts.
"""
function IntPartitionsDistinct(n::Integer, k::Integer)::BigInt
    if n < 0 || k < 0
        throw(DomainError((n, k), "arguments must be nonnegative"))
    end
    Ck2 = div(k * (k - 1), 2)
    if n < Ck2
        return big(0)
    end
    return IntPartitions(n - Ck2, k)
end

function IntPartitionsDistinct(n::Integer)::BigInt
    if n < 0
        throw(DomainError(n, "argument must be nonngative"))
    end
    result = big(0)
    for k = 1:n
        s = IntPartitionsDistinct(n, k)
        if s == 0
            break
        end
        result += s
    end
    return result
end

"""
    Euler(n)

returns the `n`-th Euler number. Starting with `n=0`
this is the sequence
1, 0, -1, 0, 5, 0, -61, 0, 1385 and so on. 
See https://oeis.org/A122045

Not to be confused with `Eulerian`.
"""
function Euler(n::Integer)::BigInt
    n >= 0 || throw(DomainError(n, "argument must be nonngative"))
    if n % 2 == 1
        return big(0)
    end

    if _has(Euler, n)
        return _get(Euler, n)
    end

    start = _max_arg(Euler) + 2

    for m = start:2:n
        last = div(m, 2) - 1
        val = -sum([Binomial(m, 2k) * Euler(2k) for k = 0:last])
        _save(Euler, m, val)
    end

    return _get(Euler, n)
end

function Euler()
    _make(Euler, Integer)
    _save(Euler, 0, big(1))
end
Euler()



"""
    PowerSum(n,k)

returns the sum of the `k`-th powers of the
integers `1` through `n`, i.e.,
`1^k + 2^k + 3^k + ... + n^k`.
"""
function PowerSum(n::Integer, k::Integer)::BigInt
    (n >= 0 && k >= 0) || throw(DomainError((n, k), "arguments must be nonngative"))
    # Base and special cases
    if n == 0
        return big(0)
    end
    if k == 0
        return big(n)
    end
    if k == 1
        return Binomial(n + 1, 2)
    end
    if _has(PowerSum, (n, k))
        return _get(PowerSum, (n, k))
    end

    val = big(n)^k + PowerSum(n - 1, k)
    _save(PowerSum, (n, k), val)
    return val
end
function PowerSum()
    _make(PowerSum, Tuple{Integer,Integer})
end
PowerSum()

export Eulerian
"""
    Eulerian(n,k)

returns the number of permutations of `{1,2,...,n}`
with `k` ascents. See https://oeis.org/A008292

Not to be confused with `Euler`.
"""
function Eulerian(n::Integer, k::Integer)::BigInt
    @assert (n >= 0 && k >= 0) "$n,$k must both be nonnegative"

    if n == 0
        return big(0)
    end

    if k > n || k == 0
        return big(0)
    end

    if n < 2
        return big(1)
    end

    if k == n      # includes the case n=k=0
        return big(1)
    end

    if k == 1
        return big(1)
    end

    if _has(Eulerian, (n, k))
        return _get(Eulerian, (n, k))
    end

    val = (n - k + 1) * Eulerian(n - 1, k - 1) + k * Eulerian(n - 1, k)
    _save(Eulerian, (n, k), val)
    return val
end
function Eulerian()
    _make(Eulerian, Tuple{Integer,Integer})
end
Eulerian()

"""
    Menage(n)

Number of solutions to the Menage problem with `n` male/female couples. 
See https://oeis.org/A059375 
"""
function Menage(n::Int)::BigInt
    if n < 0
        throw(DomainError(n, "Argument must be nonnegative"))
    end
    if _has(Menage, n)
        return _get(Menage, n)
    end
    start = _max_arg(Menage) + 1
    for m = start:n
        s = (m % 2 == 0) ? -1 : 1
        a1 = _get(Menage, m - 1) ÷ (2 * Factorial(m - 1))
        a2 = _get(Menage, m - 2) ÷ (2 * Factorial(m - 2))

        am = m * a1 + (m * a2 + 4s) ÷ (m - 2)
        val = 2 * Factorial(m) * am

        _save(Menage, m, val)
    end
    return _get(Menage, n)
end
function Menage()
    _make(Menage, Int)
    _save(Menage, 0, big(1))
    _save(Menage, 1, big(0))
    _save(Menage, 2, big(0))
    _save(Menage, 3, big(12))
end
Menage()

end  #end of module
