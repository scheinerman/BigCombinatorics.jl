# Technical Notes

Every combinatorial function that uses the cache `_master_table` should have at least two definitions.
* A definition `f(arg::Integer)::BigInt` that defines it actions.
* A zero-argument definition `f()` that is its initializer.

The zero-argument initializer should look like this:
```julia
function Fibonacci()
    _make(Fibonacci, Integer)
    _save(Fibonacci, 0, big(0))
    _save(Fibonacci, 1, big(1))
end
Fibonacci()
```

The statement `_make(Fibonacci, Integer)` creates an empty dictionary in the `_master_table` to hold values of the `Fibonacci` function. The `_save` statements seed initial values. 