$originalColor = $host.UI.RawUI.ForegroundColor

Write-Output "Updating branch 'develop'..."
git switch develop
git fetch
git reset --hard origin/develop

$branches = git branch -r --merged origin/develop --no-merged origin/main
$branchCount = $branches.Count - 1

Write-Output "" "There are $branchCount feature branches merged into 'develop'." "" "Resetting to 'origin/main'..."
git reset --hard origin/main
Write-Output "Branch 'develop' has been reset."

$index = 1
$failedBranches = @()
foreach ($branch in $branches) {
	$branchName = $branch.Trim()
	if ($branchName -ne "origin/develop") {
		$host.UI.RawUI.ForegroundColor = "yellow"
		Write-Output "" "Merging $branchName ($index/$branchCount)..."
		$host.UI.RawUI.ForegroundColor = $originalColor

		git merge $branchName

		if ($LASTEXITCODE -ne 0) {
			git merge --abort
			$failedBranches += $branchName

			$host.UI.RawUI.ForegroundColor = "red"
			Write-Output "Merge failed!"
			$host.UI.RawUI.ForegroundColor = $originalColor
		}
		else {
			$host.UI.RawUI.ForegroundColor = "green"
			Write-Output "Merge successful."
			$host.UI.RawUI.ForegroundColor = $originalColor
		}
		
		$index += 1
	}
}

if ($failedBranches.Count -eq 0) {
	$host.UI.RawUI.ForegroundColor = "green"
	Write-Output "" "All $branchCount branches merged sucessfully."
} else {
	$host.UI.RawUI.ForegroundColor = "red"
	Write-Output "" "Error! The following branches were not merged:"
	foreach ($failedBranch in $failedBranches) {
		Write-Output "  $failedBranch"
	}
}

$host.UI.RawUI.ForegroundColor = $originalColor
