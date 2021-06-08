# BigCombinatorics


[![Build Status](https://travis-ci.com/scheinerman/BigCombinatorics.jl.svg?branch=master)](https://travis-ci.com/scheinerman/BigCombinatorics.jl)



This is an implementation of various combinatorial functions.
These functions *always* return `BigInt` values. This convention
is signaled by the fact that these functions' names begin
with a capital letter.

## Overview and Rationale


### Always big

If we want to calculate 20!, it's easy enough to do this:
```julia
julia> factorial(20)
2432902008176640000
```
However, for 100!, we see this:
```julia
julia> factorial(100)
ERROR: OverflowError: 100 is too large to look up in the table
Stacktrace:
 [1] factorial_lookup(::Int64, ::Array{Int64,1}, ::Int64) at ./combinatorics.jl:19
 [2] factorial(::Int64) at ./combinatorics.jl:27
 [3] top-level scope at none:0
```
The problem is that 100! is too big to fit in an `Int` answer. Of course,
we could resolve this problem this way:
```julia
julia> factorial(big(100))
93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000
```

We take a different approach. We shouldn't have to worry about how large
our arguments may be before a combinatorial function overflows. Instead,
let's assume the result is *always* of type `BigInt` so the calculation
will not be hampered by this problem.

### Remember everything

When calculating the `n`-th Fibonnaci number (or `n!`), one implicitly calculates all the 
Fibonacci numbers (or factorials) up through `n`. This module saves the results of all those calculations so that subsequent invocations of these functions use the previously stored values.

In some cases, the built-in Julia functions with similar names are sufficiently speedy that we don't bother saving the results, but rather simply wrap those functions in ours.

For a single, one-time evaluation of a combinatorial function, the methods in `Combinatorics` are likely to be the best option. But for repeated calls to the same function, `BigCombinatorics` may perform better:
```julia
julia> using Combinatorics, BigCombinatorics

julia> @time x = [bellnum(k) for k=1:1000];
 50.067243 seconds (333.34 M allocations: 62.504 GiB, 13.83% gc time)

julia> @time y = [Bell(k) for k=1:1000];
  4.222006 seconds (28.25 M allocations: 914.731 MiB, 3.18% gc time, 3.78% compilation time)

julia> @time x = [bellnum(k) for k=1:1000];  # second time is no faster
 53.210110 seconds (333.34 M allocations: 62.504 GiB, 14.18% gc time)

julia> @time y = [Bell(k) for k=1:1000];   # values cached so much faster
  0.000849 seconds (2.20 k allocations: 42.312 KiB)

julia> x == y
true
```

### Avoid recursive calls

Functions such as factorial, Stirling numbers, and so forth obey nice recurrence relations that are mathematically elegant but can be computationally problematic. 

When we compute values via these recurrence relations we always save previously computed results and thereby avoid combinatorial explosion. For univariate functions, we do not use recursive code and so we avoid stack overflow. (Multivariate functions may still suffer from stack overflows.)



### Light weight

This module is self-contained and does not rely on others. In particular, we use neither `Combinatorics` (which provides many of these functions, but with a different design philosopy) nor `Memoize` (which also provides caching of previous results but does not give a way to delete stored values).

<hr/>

## Functions

+ `Fibonacci(n)` returns the `n`-th Fibonacci number with `Fibonacci(0)==0` and `Fibonacci(1)==1`.
+ `Factorial(n)` returns `n!` and `Factorial(n,k)` returns `n!/k!`.
+ `FallingFactorial(n,k)` returns `n*(n-1)*(n-2)*...*(n-k+1)`.
+ `RisingFactorial(n,k)` returns `n*(n+1)*(n+2)*...*(n+k-1)`.
+ `DoubleFactorial(n)` returns `n!!`.
+ `HyperFactorial(n)` returns `1^1 * 2^2 * ... * n^n`.
+ `Catalan(n)` returns the `n`-th Catalan number.
+ `Derangements(n)` returns the number of derangements of
an `n`-element set.
+ `Binomial(n,k)` returns the number of `k`-element subsets
of an `n`-element set.
+ `MultiChoose(n,k)` returns the number of `k`-element
*multisets* that can be formed using the elements of
an `n`-element set. **Warning**: This is not the same
as `Multinomial`.
+ `Multnomial(vals)` returns the multinomial coefficient where
the top index is the sum of `vals`. Here, `vals` may either be a
vector of integers or a comma separated list of arguments.
In other words, both `Multinomial([3,3,3])` and `Multinomial(3,3,3)`
return the multinomial coefficient with top index `9` and bottom
indices `3,3,3`. The result is `1680`. **Warning**: This is
not the same as `MultiChoose`.
+ `Bell(n)` returns the `n`-th Bell number, i.e., the number
of partitions of an `n`-element set.
+ `Stirling1(n,k)` returns the *signed* Stirling number of the
first kind.
+ `Stirling2(n,k)` returns the Stirling number of the second
kind, i.e., the number of partitions of an `n`-element set into
`k`-parts (nonempty).
+ `Fibonacci(n)` returns the `n`-th Fibonacci number
with `Fibonacci(0)==0` and `Fibonacci(1)==1`.
+ `IntPartitions(n)` returns the number of partitions of the integer `n`
and `IntPartitions(n,k)` returns the number of partitions of the integer
`n` with exactly `k` parts.
+ `IntPartitionsDistinct(n)` returns the number of partitions of `n` into
*distinct* parts and `IntPartitionsDistinct(n,k)` returns the number of
partitions of `n` into `k` *distinct* parts.
+ `Euler(n)` returns the `n`-th Euler number.
+ `Eulerian(n,k)` returns the number of permutations of `1:n` with `k`
ascents.
+ `PowerSum(n,k)` returns the sum `1^k + 2^k + ... + n^k`.

## Managing Stored Values

For most of these functions we save the values we have computed and often values for smaller arguments. For example, when we compute `Fibonacci(10)` we have computed and saved the value of `Fibonacci(n)` for all values of `n` up to 10. 

**Calling one of these functions with no arguments reinitializes the table of stored values for that function.** Most of the stored values are lost.

The function `BigCombinatorics.cache_clear()` reinitializes all the tables.

The function `BigCombinatorics.cache_report()` prints out the number of values
stored  for each function. (Note that some functions don't save any values.)
```julia
julia> Bell(10)
115975

julia> Fibonacci(20)
6765

julia> BigCombinatorics.cache_report()
2       Derangements
0       Stirling2
0       Eulerian
1       Euler
3       DoubleFactorial
0       Stirling1
0       PowerSum
2       HyperFactorial
11      Bell
0       IntPartitions
21      Fibonacci

40      Total entries

julia> Fibonacci()

julia> BigCombinatorics.cache_report()
2       Derangements
0       Stirling2
0       Eulerian
1       Euler
3       DoubleFactorial
0       Stirling1
0       PowerSum
2       HyperFactorial
11      Bell
0       IntPartitions
2       Fibonacci

21      Total entries
```