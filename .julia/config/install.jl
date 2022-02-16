
using Pkg

# We cannot record the following in Project.toml nor in Manifest.toml (`pkg> dev <url>`
# places a `path` (which is machine-specific) in the Manifest -- not the url. Using `pkg>
# add <url>` does record the url; but then we can't hack on pkg locally).
unregistered_dev_pkgs = Dict(
    "WhatIsHappening"  => "https://github.com/tfiers/WhatIsHappening.jl",
    "Sciplotlib"       => "https://github.com/tfiers/Sciplotlib.jl",
    "MyToolbox"        => "https://github.com/tfiers/MyToolbox.jl",
)

# The following is a fix: temporarily remove dev packages from `Project.toml`, to avoid
# "LoadError: expected package {devpkg} to be registered".
for pkgname in keys(unregistered_dev_pkgs)
    try Pkg.rm(pkgname)
    catch # The dependency is already removed from `Project.toml`.
    end
end

for url in values(unregistered_dev_pkgs)
    Pkg.develop(; url)
end

# Install all from `~/.julia/environments/vX.Y/Project.toml`.
Pkg.instantiate()
