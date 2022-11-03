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

# Loading the functionality below takes a while. If we have started julia just for a one off
# command (like using the package manager), we don't want to wait for them. Hence why we put
# them in on-demand macros, instead of executing them automatically at-repl-init.
#
# An alternative solution might be a system image with OhMyREPL / Revise included (though
# system images have a small startup cost too).

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
        @withfb "Precompiling repl usage" (
            include($precompile_file)
        )
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

macro newpkg(name::Symbol, testdir::Bool = false)
    pkgname = string(name)
    quote
        @withfb "Loading PkgTemplates" (
            using PkgTemplates
            # ↪ Doing `@eval using PkgTemplates` in the function (`_newpkg`) does not work
            #   (`MethodError: no method matching License(; name="MIT")`).
        )
        _newpkg($pkgname, $testdir)
    end
end

function _newpkg(name::String, testdir::Bool)
    @withfb "Instantiating Template" begin
        tests = (testdir) ? Tests(project = true) : !Tests
        genpkg = Template(
            julia = v"1.2",  # Required for `Tests(project = true)`
            plugins = [
                License(name = "MIT"),
                Git(ssh = true),
                tests,
                !CompatHelper,
                !TagBot,
                Develop(),
                # ↪ Does `]dev NewPkg` in currently active env, so that we can run its code with
                #   `using NewPkg` (after `using Revise`). Note that after the
                #   `Pkg.activate(srcdir)` below, we're no longer in this currently active env.
            ],
        )
    end
    println("Creating new package '$name'")
    genpkg(name)
    srcdir = joinpath(Pkg.devdir(), name)
    println("Changing active directory to ", srcdir)
    cd(srcdir)
    edit(".")
    Pkg.activate(".")
    println()
    println("Creating gh repo")
    reponame = name * ".jl"
    run(`gh repo create --public $reponame`)
    println()
    println("Pushing to repo:")
    run(`git push --set-upstream origin main`)  # `origin` auto-set by PkgTemplates
    println()
    println(" ↪ https://github.com/tfiers/$reponame")
end
