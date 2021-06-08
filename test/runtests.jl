using BigCombinatorics
using Test

@testset "Fibonacci" begin
    @test Fibonacci(10) == Fibonacci(9) + Fibonacci(8)
    n = 5000
    a = Fibonacci(n)
    b = Fibonacci(n + 1)
    @test gcd(a, b) == 1
end

@testset "Factorial" begin
    @test Factorial(10) == big(factorial(10))
    @test FallingFactorial(10, 3) == 10 * 9 * 8
    @test FallingFactorial(10, 10) == Factorial(10)
    @test FallingFactorial(10, 12) == 0
    @test RisingFactorial(10, 3) == 10 * 11 * 12
    @test DoubleFactorial(9) == 9 * 7 * 5 * 3
    @test DoubleFactorial(10) == 10 * 8 * 6 * 4 * 2
    @test HyperFactorial(5) == prod(big(k)^big(k) for k = 1:5)

    @test Derangements(1) == 0
    @test Derangements(12) == 176214841
end

@testset "Binomial" begin
    @test sum(Binomial(10, k) for k = 0:10) == 2^10
    @test Catalan(12) == 208012
    @test MultiChoose(10, 1) == 10
    @test MultiChoose(10, 0) == 1
    @test MultiChoose(10, 10) == 92378

    @test Multinomial(5, 5, 5) == div(Factorial(15), Factorial(5)^3)
    @test Multinomial([6, 6, 6, 6]) == Multinomial(6, 6, 6, 6)
end

@testset "Partitions" begin
    @test Bell(10) == 115975
    @test sum(Stirling2(10, k) for k = 0:10) == Bell(10)
    @test Stirling1(10, 10) == 1
    @test Stirling1(10, 0) == 0
    @test sum(Stirling1(10, k) for k = 0:10) == 0

    @test IntPartitions(10) == 42
    @test IntPartitionsDistinct(10) == 10

    n = 20
    k = 5
    a = Stirling2(n, k)
    b = sum(Binomial(n - 1, j) * Stirling2(j, k - 1) for j = (k-1):(n-1))
    @test a == b

    c = sum((-1)^j * Binomial(k, j) * (k - j)^n for j = 0:k) ÷ Factorial(k)
    @test a == c
end

@testset "Euler[ian]" begin
    @test Euler(12) == 2702765
    @test sum(Eulerian(10, k) for k = 1:10) == Factorial(10)
end

@testset "Misc" begin
    BigCombinatorics.cache_clear()
    @test PowerSum(10, 3) == sum(k^3 for k = 1:10)
    @test PowerSum(100, 1) == sum(1:100)
end
