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

paste() = eval(Base.Meta.parse(clipboard()))

# Loading the functionality below takes a while. If we have started julia just for a one off
# command (like using the package manager), we don't want to wait for them. Hence why we put
# them in on-demand macros, instead of executing them automatically at-repl-init.
#
# An alternative solution might be a system image with OhMyREPL / Revise included (though
# system images have a small startup cost too).
#
# The `@async @eval using Revise` trick (from https://m3g.github.io/JuliaNotes.jl/stable/fastrepl/)
# does not work. (We still have to wait until it's loaded before we can start).

macro withfb(descr, expr)
    quote
        print($descr, " … ")
        $(esc(expr))
        println("done")
    end
end

macro omr()
    precompile_file = joinpath(@__DIR__, "repl-trace-compile.jl")
    quote
        @withfb "Loading OhMyREPL" (
            using OhMyREPL
        )
        @withfb "Setting options" begin
            OhMyREPL.colorscheme!("OneDark")
            # ↪ There are no explicit light themes (OneDark works fine in light term).
            OhMyREPL.enable_autocomplete_brackets(true)
            OhMyREPL.Passes.RainbowBrackets.activate_256colors()
        end
        @withfb "Precompiling REPL usage" (
            include($precompile_file)
        )
        # ↪ Done by OhMyREPL itself now:
        #   https://github.com/KristofferC/OhMyREPL.jl/pull/288
        #   ..though that only caches llvm IR I think, not native
    end
end

macro re()
    quote
        @withfb "Loading Revise" (
            using Revise
        )
        # When working with a package in the repl, we'll use the repl repeatedly, so loading
        # OhMyREPL is worth it.
        @omr
    end
end

macro sk()
    # FIXME this doesn't work if Crayons not installed.
    # should be proper newpkg.
    quote
        if isdefined(Main, :sketch)
            is_first_call = false
        else
            print("Loading … ")  # This printed line is completed in `sketch()`.
            is_first_call = true
            include(homedir() * "/.julia/sketches/sketch-sel/main.jl")
        end
        sketch(is_first_call)
    end
end

macro newpkg(name::Symbol)
    quote
        include(joinpath(@__DIR__, "newpkg.jl"))
        newpkg($(string(name)))
    end
end
