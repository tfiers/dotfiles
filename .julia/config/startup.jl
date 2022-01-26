# To avoid the below: `julia --startup-file=no`.

using Pkg
if isfile("Project.toml") || isfile("JuliaProject.toml")
    Pkg.activate(".")
end

using OhMyREPL
OhMyREPL.colorscheme!("OneDark")
OhMyREPL.enable_autocomplete_brackets(true)
OhMyREPL.Passes.RainbowBrackets.activate_256colors()

mwt(obj; supertypes = true) = methodswith(typeof(obj); supertypes)

using Revise
