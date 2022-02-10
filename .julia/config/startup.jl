
atreplinit() do repl
    # Cannot import packages here (not toplevel); but we can include a file that can. (weird)
    include(joinpath(@__DIR__, "replinit.jl"))
end
