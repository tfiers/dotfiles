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
        @withfb "Loading PkgTemplates" (
            using PkgTemplates
            # ↪ Doing `@eval using PkgTemplates` in the function (`_newpkg`) does not work
            #   (`MethodError: no method matching License(; name="MIT")`).
        )
        using DefaultApplication
        _newpkg($(string(name)))
    end
end

function _newpkg(name::String)
    @withfb "Instantiating Template" begin
        genpkg = Template(
            julia = v"1.2",  # v"1.2" is required for `Tests(project = true)`
            plugins = [
                License(name = "MIT"),
                Git(ssh = true),
                Tests(project = true),
                Documenter{GitHubActions}(),
                # ↪ I want the unreleased as of now version by default..
                #   eh well, do that below: `cd(docdir) do Pkg.add(url=…)`
                #   OOrrr: don't use this Plugin. There's too much to tweak with it.
                GitHubActions(
                    coverage = false,
                    # For new features and changes per version,
                    # see https://github.com/JuliaLang/julia/blob/master/HISTORY.md
                    extra_versions = [
                        # "1.2",    # Aug 2019
                        # "1.3",    # Nov 2019. Artifacts.jl
                        # "1.4",    # Mar 2020
                        # "1.5",    # Aug 2020
                        "1.6",      # Mar 2021. LTS
                        "1.7",      # Nov 2021
                        "1.8",      # Aug 2022. Stable
                        "nightly",  # last commit to master
                    ]
                ),
                RegisterAction(),
                TagBot(),  # Makes git tag and gh Release on new General registry version.
                           # also, _something_ builds the docs for each minor.
                CompatHelper(),  # Runs every night, to… uh see if new versions released of deps?
                Readme(destination = "ReadMe.md"),
                # ↪ why not a custom template file, easy.
                #   Also: https://juliaci.github.io/PkgTemplates.jl/stable/user/#Extending-Existing-Plugins-1
                Develop(),
                # ↪ Does `]dev NewPkg` in currently active env, so that we can run its code with
                #   `using NewPkg` (after `using Revise`). Note that after the `Pkg.activate(srcdir)`
                #   below, we're no longer in this currently active env.
            ],
        )
    end
    println("Creating new package '$name'")
    println("<PkgTemplates.jl output>")
    genpkg(name)
    println("</PkgTemplates.jl output>\n")
    srcdir = joinpath(Pkg.devdir(), name)
    println("Changing active directory to ", srcdir)
    cd(srcdir)
    edit(".")
    Pkg.activate(".")
    println()
    choice = Base.prompt("Create github repo? [y]/n")
    if choice != "n"
        println("Creating gh repo")
        reponame = name * ".jl"
        run(`gh repo create --public $reponame`)
        println()
        println("Pushing to repo:")
        run(`git push --set-upstream origin main`)  # `origin` auto-set by PkgTemplates
        println()
        DefaultApplication.open("https://github.com/tfiers/$reponame")
        println("[reminder to go to repo settings: gh pages branch, and DOCUMENTER_URL]")
        # There's `gh secret set` :)
        # Doesn't seem to be sth for gh pages setting.
        # But there's `gh browse -s` (open browser to settings).
        # or well yeah just `https://github.com/tfiers/PkgDepGraph.jl/settings/pages`
        # Weird though. there's not even a 'https://cli.github.com/manual/gh_extension' for it.
        # oohh, can disable projects: `gh repo edit --enable-projects=false`
        #
        # Ah but wait!  Maybe this `julia-actions/julia-docdeploy@v1` is outdated.
        # like, i think there's some gh-pages action for which you don't need to go set branch. no?
    end
end
