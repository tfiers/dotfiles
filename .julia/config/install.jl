
using Pkg

# We cannot record the following in Project.toml. And I don't want to commit Manifest.toml
# in my dotfiles repo; no need to record every update of every dependency here methinks.
unregistered_packages = Dict(
    "WhatIsHappening"  => "https://github.com/tfiers/WhatIsHappening.jl",
    "Sciplotlib"       => "https://github.com/tfiers/Sciplotlib.jl",
    "MyToolbox"        => "https://github.com/tfiers/MyToolbox.jl",
)

# The following is a fix: temporarily remove dev packages from `Project.toml`, to avoid
# "LoadError: expected package {devpkg} to be registered".
for pkgname in keys(unregistered_packages)
    try Pkg.rm(pkgname)
    catch # The dependency is already removed from or not yet in `Project.toml`.
    end
end

for url in values(unregistered_packages)
    Pkg.add(; url)
end

# Install all from `~/.julia/environments/vX.Y/Project.toml`.
Pkg.instantiate()
