# Simple Combinatorics

This is an implementation of various combinatorial functions.
These functions *always* return `BigInt` values. This convention
is signaled by the fact that these functions' names begin
with a capital letter.


## The functions

Use Julia's help utility for more detail on all of these.

+ `Factorial(n)` returns `n!`.
+ `Factorial(n,k)` returns `n!/(n-k)!`.
+ `DoubleFactorial(n)` returns `n!!`.
+ `Catalan(n)` returns the `n`-th Catalan number.
+ `Derangements(n)` returns the number of derangements of
an `n`-element set.
+ `Binomial(n,k)` returns the number of `k`-element subsets
of an `n`-element set.
+ `MultiChoose(n,k)` returns the number of `k`-element
*multisets* that can be formed using the elements of
an `n`-element set.
+ `Bell(n)` returns the `n`-th Bell number, i.e., the number
of partitions of an `n`-element set.
+ `Stirling1(n,k)` returns the *signed* Stirling number of the
first kind.
+ `Stirling2(n,k)` returns the Stirling number of the second
kind, i.e., the number of partitions of an `n`-element set into
`k`-parts (nonempty).
+ `Fibonacci(n)` returns the `n`-th Fibonacci number
with `Fibonacci(0)==0` and `Fibonacci(1)==1`.


## Implementation

These function all have nice recursive properties that we
exploit to make the code as simple as possible. To keep
the calculations efficient, we use the `Memoize` module.
This means that no function value is ever evaluated twice;
subsequent calls are simply recalled. By looking up
previously computed values, the code is quite efficient.

For example, here we compare `Factorial` from this module
versus `factorial` from the `Combinatorics` module.
```julia
julia> tic(); e1 = sum([1/factorial(big(k)) for k=0:100]); toc();
elapsed time: 0.077007934 seconds

julia> tic(); e2 = sum([1/Factorial(k) for k=0:100]); toc();
elapsed time: 0.066950058 seconds

julia> e1==e2
true
```

## TODO

+ Multinomial coefficients
+ Integer partition counts
