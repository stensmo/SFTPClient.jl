using SFTPClient
using Test


include("setup.jl")

@testset "Connect Test" begin

    @test files == actualFiles
    @test stats == actualStructs
    @test isfile(tempDir * "KeyGenerator.png")
    @test dirs == ["example"]
    @test isfile("readme.txt")

end

