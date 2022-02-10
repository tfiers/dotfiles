using WhatIsHappening  # loads blazing fast

@withfeedback "Setting up OhMyREPL" begin
    using OhMyREPL
    OhMyREPL.colorscheme!("OneDark")
    OhMyREPL.enable_autocomplete_brackets(true)
    OhMyREPL.Passes.RainbowBrackets.activate_256colors()
end

mwt(obj; supertypes = true) = methodswith(typeof(obj); supertypes)
# Stopgap until these are released:
# - https://github.com/JuliaLang/julia/pull/38791
# - https://github.com/julia-vscode/LanguageServer.jl/pull/980
# - https://github.com/JuliaLang/IJulia.jl/issues/1033 (IJulia support needed; to reopen)

ENV["JULIA_EDITOR"] = "code.cmd"  # https://github.com/JuliaLang/julia/pull/44083

using Pkg
isfile("Project.toml") && Pkg.activate(".")
