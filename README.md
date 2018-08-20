# BigCombinatorics

UNDER CONSTRUCTION!!!

This is an implementation of various combinatorial functions.
These functions *always* return `BigInt` values. This convention
is signaled by the fact that these functions' names begin
with a capital letter.


## The functions

+ `Fibonacci(n)` returns the `n`-th Fibonacci number with `Fibonacci(0)==0`
and `Fibonacci(1)==1`.
+ `Factorial(n)` returns `n!` and `Factorial(n,k)` returns `n!/k!`.
+ `FallingFactorial(n,k)` returns `n*(n-1)*(n-2)*...*(n-k+1)`.
+ `RisingFactorial(n,k)` returns `n*(n+1)*(n+2)*...*(n+k-1)`.
+ `DoubleFactorial(n)` returns `n!!`.
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
+ `PowerSum(n,k)` returns the sum `1^k + 2^k + ... + n^k`.

## Implementation

These function all have nice recursive properties that we
exploit to make the code as simple as possible. To keep
the calculations efficient, we use the `Memoize` module.
This means that no function value is ever evaluated twice;
subsequent calls are simply recalled. By looking up
previously computed values, the code is quite efficient.
