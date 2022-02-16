
atreplinit() do repl
    # Cannot import packages here (we're in a function i.e. not top-level); but we can
    # include a file that can. (weird)
    try
        include(joinpath(@__DIR__, "replinit.jl"))
    catch e
        @error e
        println("\nPackages required by `replinit.jl` may need to be installed.")
        print("Run `~/.julia/config/install.jl`? [Y/n] >")
        answer = readline()
        if answer ∈ ["", "Y"]
            include(joinpath(@__DIR__, "install.jl"))
            include(joinpath(@__DIR__, "replinit.jl"))
        end
    end
end
