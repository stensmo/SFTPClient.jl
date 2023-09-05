using SFTPClient
using Test


include("setup.jl")

@testset "Connect Test" begin

    @test files == actualFiles
    @test isfile(tempDir * "KeyGenerator.png")
    @test dirs == ["example"]

end

