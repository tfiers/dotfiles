using Pkg

atreplinit() do repl
    # If the current dir is a project, auto-activate it.
    if isfile("Project.toml")
        Pkg.activate(".")
    end
    ENV["JULIA_EDITOR"] = "code.cmd"
    # Without this, `@edit` opens the right file in vscode, but does not jump to the
    # right location. My docs edit: https://github.com/JuliaLang/julia/pull/44083
end

macro ohmyrepl()
    # This takes a while, so we do not want to run it automatically.
    # An alternative might be a system image with the below included (though system images
    # have a small startup cost too).
    quote
        print("Setting up OhMyREPL … ")
        using OhMyREPL
        OhMyREPL.colorscheme!("OneDark")
        OhMyREPL.enable_autocomplete_brackets(true)
        OhMyREPL.Passes.RainbowBrackets.activate_256colors()
        # Ideally we'd also precompile usage here (run recorded compile statements), so no
        # delay on next typing in repl. Also, maybe, precomp load should be added to pkg.
        println("done")
    end
end
