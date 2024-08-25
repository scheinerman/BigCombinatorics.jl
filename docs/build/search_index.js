var documenterSearchIndex = {"docs":
[{"location":"#BigCombinatorics","page":"BigCombinatorics","title":"BigCombinatorics","text":"","category":"section"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"This is an implementation of various combinatorial functions. These functions always return BigInt values. This convention is signaled by the fact that these functions' names begin with a capital letter.","category":"page"},{"location":"#Overview-and-Rationale","page":"BigCombinatorics","title":"Overview and Rationale","text":"","category":"section"},{"location":"#Always-big","page":"BigCombinatorics","title":"Always big","text":"","category":"section"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"If we want to calculate 20!, it's easy enough to do this:","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"julia> factorial(20)\n2432902008176640000","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"However, for 100!, we see this:","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"julia> factorial(100)\nERROR: OverflowError: 100 is too large to look up in the table","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"The problem is that 100! is too big to fit in an Int answer. Of course, we could resolve this problem this way:","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"julia> factorial(big(100))\n93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"This limitation on factorials causes problems for functions such as stirlings1 in the Combinatorics package:","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"julia> using Combinatorics\n\njulia> stirlings1(30,1)\nERROR: OverflowError: 29 is too large to look up in the table; consider using `factorial(big(29))` instead","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"We take a different approach. We shouldn't have to worry about how large our arguments may be before a combinatorial function overflows. Instead, let's assume the result is always of type BigInt so the calculation will not be hampered by this problem.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"For example:","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"julia> using BigCombinatorics\n\njulia> Stirling1(30,1)\n-8841761993739701954543616000000","category":"page"},{"location":"#Remember-everything","page":"BigCombinatorics","title":"Remember everything","text":"","category":"section"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"When calculating the n-th Fibonnaci number (or n!), one implicitly calculates all the  Fibonacci numbers (or factorials) up through n. This module saves the results of all those calculations so that subsequent invocations of these functions use the previously stored values.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"In some cases, the built-in Julia functions with similar names are sufficiently speedy that we don't bother saving the results, but rather simply wrap those functions in ours.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"For a single, one-time evaluation of a combinatorial function, the methods in Combinatorics are likely to be the best option. But for repeated calls to the same function, BigCombinatorics may perform better:","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"julia> using Combinatorics, BigCombinatorics\n\njulia> @time x = [bellnum(k) for k=1:1000];\n 50.067243 seconds (333.34 M allocations: 62.504 GiB, 13.83% gc time)\n\njulia> @time y = [Bell(k) for k=1:1000];\n  4.222006 seconds (28.25 M allocations: 914.731 MiB, 3.18% gc time, 3.78% compilation time)\n\njulia> @time x = [bellnum(k) for k=1:1000];  # second time is no faster\n 53.210110 seconds (333.34 M allocations: 62.504 GiB, 14.18% gc time)\n\njulia> @time y = [Bell(k) for k=1:1000];   # values cached so much faster\n  0.000849 seconds (2.20 k allocations: 42.312 KiB)\n\njulia> x == y\ntrue","category":"page"},{"location":"#Using-recursion-wisely","page":"BigCombinatorics","title":"Using recursion wisely","text":"","category":"section"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Functions such as factorial, Stirling numbers, and so forth obey nice recurrence relations that are mathematically elegant but can be computationally problematic. ","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"When we compute values via these recurrence relations we always save previously computed results and thereby avoid combinatorial explosion. For example:","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"julia> using Combinatorics, BigCombinatorics\n\njulia> @time stirlings2(34,17)\n  5.532814 seconds\n1482531184316650855  # this is incorrect because arithmetic was done with Int64 values\n\njulia> @time Stirling2(34,17)\n  0.000920 seconds (3.69 k allocations: 115.836 KiB)\n118144018577011378596484455\n\njulia> @time Stirling2(34,17)   # second call is even faster because value was cached\n  0.000011 seconds (2 allocations: 64 bytes)\n118144018577011378596484455","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"For univariate functions, we do not use recursive code and so we avoid stack overflow. (Multivariate functions may still suffer from stack overflows.)","category":"page"},{"location":"#Light-weight","page":"BigCombinatorics","title":"Light weight","text":"","category":"section"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"This module is self-contained and does not rely on others. In particular, we use neither Combinatorics (which provides many of these functions, but with a different design philosopy) nor Memoize (which also provides caching of previous results but does not give a way to delete stored values).","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"<hr/>","category":"page"},{"location":"#Functions","page":"BigCombinatorics","title":"Functions","text":"","category":"section"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Fibonacci(n) returns the n-th Fibonacci number with Fibonacci(0)==0 and Fibonacci(1)==1.\nFactorial(n) returns n! and Factorial(n,k) returns n!/k!.\nFallingFactorial(n,k) returns n*(n-1)*(n-2)*...*(n-k+1).\nRisingFactorial(n,k) returns n*(n+1)*(n+2)*...*(n+k-1).\nDoubleFactorial(n) returns n!!.\nHyperFactorial(n) returns 1^1 * 2^2 * ... * n^n.\nCatalan(n) returns the n-th Catalan number.\nDerangements(n) returns the number of derangements of","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"an n-element set.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Binomial(n,k) returns the number of k-element subsets","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"of an n-element set.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"MultiChoose(n,k) returns the number of k-element","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"multisets that can be formed using the elements of an n-element set. Warning: This is not the same as Multinomial.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Multinomial(vals) returns the multinomial coefficient where","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"the top index is the sum of vals. Here, vals may either be a vector of integers or a comma separated list of arguments. In other words, both Multinomial([3,3,3]) and Multinomial(3,3,3) return the multinomial coefficient with top index 9 and bottom indices 3,3,3. The result is 1680. Warning: This is not the same as MultiChoose.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Bell(n) returns the n-th Bell number, i.e., the number","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"of partitions of an n-element set.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Stirling1(n,k) returns the signed Stirling number of the","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"first kind.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Stirling2(n,k) returns the Stirling number of the second","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"kind, i.e., the number of partitions of an n-element set into k-parts (nonempty).","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Fibonacci(n) returns the n-th Fibonacci number","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"with Fibonacci(0)==0 and Fibonacci(1)==1.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"IntPartitions(n) returns the number of partitions of the integer n","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"and IntPartitions(n,k) returns the number of partitions of the integer n with exactly k parts.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"IntPartitionsDistinct(n) returns the number of partitions of n into","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"distinct parts and IntPartitionsDistinct(n,k) returns the number of partitions of n into k distinct parts.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Euler(n) returns the n-th Euler number.\nEulerian(n,k) returns the number of permutations of 1:n with k","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"ascents.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"PowerSum(n,k) returns the sum 1^k + 2^k + ... + n^k.\nMenage(n) returns the number of solutions to the Menage problem with n male/female couples. ","category":"page"},{"location":"#Managing-Stored-Values","page":"BigCombinatorics","title":"Managing Stored Values","text":"","category":"section"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"For most of these functions we save the values we have computed and often values for smaller arguments. For example, when we compute Fibonacci(10) we have computed and saved the value of Fibonacci(n) for all values of n up to 10. ","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"Calling one of these functions with no arguments reinitializes the table of stored values for that function. Most of the stored values are lost.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"The function BigCombinatorics.cache_clear() reinitializes all the tables.","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"The function BigCombinatorics.cache_report() prints out the number of values stored  for each function. (Note that some functions don't save any values.)","category":"page"},{"location":"","page":"BigCombinatorics","title":"BigCombinatorics","text":"julia> Bell(10)\n115975\n\njulia> Fibonacci(20)\n6765\n\njulia> BigCombinatorics.cache_report()\n2       Derangements\n0       Stirling2\n0       Eulerian\n1       Euler\n3       DoubleFactorial\n0       Stirling1\n0       PowerSum\n2       HyperFactorial\n11      Bell\n0       IntPartitions\n21      Fibonacci\n\n40      Total entries\n\njulia> Fibonacci()\n\njulia> BigCombinatorics.cache_report()\n2       Derangements\n0       Stirling2\n0       Eulerian\n1       Euler\n3       DoubleFactorial\n0       Stirling1\n0       PowerSum\n2       HyperFactorial\n11      Bell\n0       IntPartitions\n2       Fibonacci\n\n21      Total entries","category":"page"}]
}