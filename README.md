# reset-develop
PowerShell script that updates the `develop` branch with changes in the `main` branch, that:

1. Checks and remembers what branches are merged int `develop` but not into `main`.
2. Resets `develop` so that is identical to `main`.
3. Merges back all branches remembered in 1. into `develop`.
4. In case of any merge conflict, that branch is skipped and the information about it is printed to the console.
