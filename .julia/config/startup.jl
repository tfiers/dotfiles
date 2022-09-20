atreplinit() do repl
    expr = quote

        ENV["JULIA_EDITOR"] = "code.cmd"
            # Without this, `@edit` opens the right file in vscode, but does not jump to the
            # right location. My docs edit: https://github.com/JuliaLang/julia/pull/44083

        print("Setting up OhMyREPL … ")
        using OhMyREPL
        OhMyREPL.colorscheme!("OneDark")
        OhMyREPL.enable_autocomplete_brackets(true)
        OhMyREPL.Passes.RainbowBrackets.activate_256colors()
        println("done")

        # If the current dir is a project, auto-activate it.
        using Pkg
        if isfile("Project.toml")
            Pkg.activate(".")
        end

    end
    eval(expr)
end
