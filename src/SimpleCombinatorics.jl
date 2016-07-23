module SimpleCombinatorics

using Memoize

export Fibonacci, Factorial, DoubleFactorial, Binomial, Catalan
export Derangements, MultiChoose, Multinomial
export Bell, Stirling1, Stirling2
export IntPartitions, Euler 


@memoize function Fibonacci(n::Integer)
  if n<0
    throw(DomainError())
  end
  if n==0
    return big(0)
  end
  if n==1
    return big(1)
  end
  return Fibonacci(n-1)+Fibonacci(n-2)
end
@doc """
`Fibonacci(n)` returns the `n`-th Fibonacci number.
We begin with `Fibonacci(0)==0` and `Fibonacci(1)==1`.
""" Fibonacci

@memoize function Factorial(n::Integer)
  if n<0
    throw(DomainError())
  end
  if n==0 || n==1
    return big(1)
  end
  return n * Factorial(n-1)
end

@memoize function Factorial(n::Integer,k::Integer)
  if n<0 || k<0
    throw(DomainError())
  end
  if k>n
    return big(0)
  end
  if k==0
    return big(1)
  end
  return n*Factorial(n-1,k-1)
end
@doc """
`Factorial(n)` returns `n!` for nonnegative integers `n`.

`Factorial(n,k)` returns `n*(n-1)*...*(n-k+1)`.
""" Factorial


@memoize function DoubleFactorial(n::Integer)
  if n<0
    throw(DomainError())
  end
  if n==0 || n==1
    return big(1)
  end
  return n*DoubleFactorial(n-2)
end
@doc """
`DoubleFactorial(n)` returns `n!!`, i.e.,
`n*(n-2)*...` with `0!! == 1!! == 1`.
""" DoubleFactorial

@memoize function Binomial(n::Integer, k::Integer)
  if n<0 || k<0
    throw(DomainError())
  end
  if k>n
    return big(0)
  end
  if k==0 || k==n
    return big(1)
  end

  return Binomial(n-1,k-1)+Binomial(n-1,k)
end
@doc """
`Binomial(n,k)` returns the binomial coefficient `n`-choose-`k`.
This is the number of `k`-element subsets of an `n`-element set.
""" Binomial

"""
`Multinomial(vec)` returns the multinomial coefficient whose
top index is the sum of `vec` (an array of `Int`s) and whose
bottom indices are given by `vec`.

This may also be called with a common-separated list of arguments,
that is, either of `Multinomial([1,2,3])` or `Multinomial(1,2,3)`.
The result is `60` in both cases as these equal `6!/(1! 2! 3!)`.

**Warning**: This is not the same as `MultiChoose`.
"""
function Multinomial(v...)
  nv = length(v)
  for i=1:nv
    typeof(v[i])<:Integer || throw(DomainError())
  end
  vals = [t for t in v]
  return Multinomial(vals)
end

Multinomial() = big(1)

function Multinomial{T<:Integer}(vals::Vector{T})
  if any([t<0 for t in vals])
    throw(DomainError())
  end

  nv = length(vals)
  n  = sum(vals)
  # base cases
  if nv<=1 || n==0
    return big(1)
  end
  # reduce
  return Binomial(n,vals[end]) * Multinomial(vals[1:nv-1])
end


"""
`MultiChoose(n,k)` returns the number of `k`-element
*multisets* that can be formed using the elements of an
`n`-element set.

**Warning**: This is not the same as `Multinomial`.
"""
function MultiChoose(n::Integer,k::Integer)
  return Binomial(n+k-1,k)
end


"""
`Catalan(n)` returns the `n`-th Catalan number.
"""
function Catalan(n::Integer)
  return div(Binomial(2n,n),n+1)
end


@memoize function Derangements(n::Integer)
  if n<0
    throw(DomainError())
  end
  if n==0
    return big(1)
  end
  if n==1
    return big(0)
  end

  return (n-1)*(Derangements(n-1)+Derangements(n-2))
end




@memoize function Bell(n)
  if n<0
    throw(DomainError())
  end
  if n==1 || n==0
    return big(1)
  end
  N1 = n-1
  result = big(0)
  for k=0:n-1
    result += Binomial(n-1,k) * Bell(k)
  end
  return result
end
@doc """
`Bell(n)` gives the `n`-th Bell number, that is,
the number of partitions of an `n`-element set.
""" Bell

@memoize function Stirling2(n::Integer,k::Integer)
  # special cases
  if k<0 || n<0
    throw(DomainError())
  end

  if k>n
    return big(0)
  end

  if n==0  # and by logic, k==0
    return big(1)
  end

  if k==0
    return big(0)
  end

  if n==k
    return big(1)
  end
  # END OF SPECIAL CASES, invoke recursion

  return Stirling2(n-1,k-1) + Stirling2(n-1,k)*k
end
@doc """
`Stirling2(n,k)` gives the Stirling number of the second kind,
that is, the number of paritions of an `n`-set into `k`-parts."
""" Stirling2

@memoize function Stirling1(n::Integer,k::Integer)
  # special cases
  if k<0 || n<0
    throw(DomainError())
  end

  if k>n
    return big(0)
  end

  if n==0  # and, by logic, k==0
    return big(1)
  end

  if k==0  # and, by logic, n>0
    return big(0)
  end

  # end of special cases, invoke recursion

  return Stirling1(n-1,k-1) - (n-1)*Stirling1(n-1,k)
end
@doc """
`Stirling1(n,k)` gives the (signed) Stirling number
of the first kind, that is, the coefficient of `x^k`
in the poynomial `x(x-1)(x-2)...(x-n+1)`.
""" Stirling1




@memoize function IntPartitions(n::Integer,k::Integer)
  if n<0 || k<0
    throw(DomainError())
  end
  # lots of special cases
  if k>n
    return big(0)
  end
  if n==0
    return big(1)
  end
  if k==0
    return big(0)
  end
  if k==n || k==1
    return big(1)
  end

  return sum([IntPartitions(n-k,i) for i=0:k])
end

@memoize function IntPartitions(n::Integer)
  return sum([IntPartitions(n,k) for k=0:n])
end

@doc """
`IntPartitions(n)` is the number of partitions of the integer `n`.

`IntPartitions(n,k)` is the number of partitions of the integer
`n` with exactly `k` (nonzero) parts.
""" IntPartitions


@memoize function Euler(n::Integer)
  n>=0 || throw(DomainError())
  if n%2 == 1
    return big(0)
  end
  if n==0
    return big(1)
  end
  last = div(n,2)-1
  return -sum([ Binomial(n,2k)*Euler(2k) for k=0:last])
end
@doc """
`Euler(n)` returns the `n`-th Euler number. Starting with `n=0`
this is the sequence
1, 0, -1, 0, 5, 0, -61, 0, 1385 and so on.
""" Euler

################ EXTRAS FOR DEBUGGING ####################

"""
Common code for the two Stirling matrix functions.
"""
function _matrix_maker(n::Int, f::Function)
  if n<0
    throw(DomainError())
  end

  M = zeros(BigInt,n+1,n+1)
  for i=0:n
    for j=0:n
      M[i+1,j+1] = f(i,j)
    end
  end
  return M
end

"""
`Stirling1matrix(n)` creates an `n+1`-by-`n+1` matrix
of Stirling numbers of the first kind (from `0,0` to `n,n`).
"""
function Stirling1matrix(n::Int)
  return _matrix_maker(n,Stirling1)
end


"""
`Stirling2matrix(n)` creates an `n+1`-by-`n+1` matrix
of Stirling numbers of the second kind (from `0,0` to `n,n`).
"""
function Stirling2matrix(n::Int)
  return _matrix_maker(n,Stirling2)
end


end  #end of module
