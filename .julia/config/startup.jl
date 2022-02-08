# To avoid all the below: `julia --startup-file=no`, alias `jf`.

using WhatIsHappening

@withfeedback "Setting up OhMyREPL" begin
    using OhMyREPL
    OhMyREPL.colorscheme!("OneDark")
    OhMyREPL.enable_autocomplete_brackets(true)
    OhMyREPL.Passes.RainbowBrackets.activate_256colors()
end
# OhMyREPL is not used when in notebook. No way to know we're in IJulia and thus turn it off
# selectively, alas (`isdefined(Main, :IJulia)` is not true here). Luckily it is fast.

mwt(obj; supertypes = true) = methodswith(typeof(obj); supertypes)
# Stopgap until these are released:
# - https://github.com/JuliaLang/julia/pull/38791
# - https://github.com/julia-vscode/LanguageServer.jl/pull/980
# - https://github.com/JuliaLang/IJulia.jl/issues/1033 (IJulia support needed; to reopen)

ENV["JULIA_EDITOR"] = "code.cmd"  # https://github.com/JuliaLang/julia/pull/44083

using Pkg
isfile("Project.toml") && Pkg.activate(".")
