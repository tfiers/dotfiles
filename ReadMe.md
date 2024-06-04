
On a new computer, in `C:\Users\[name]\`:
```
git init
git remote add origin git@github.com:tfiers/dotfiles.git
git fetch
git checkout origin/main -ft
```

Everything is gitignored, so to add a new file:
```
git add -f newfile 
```
