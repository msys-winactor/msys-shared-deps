# release.ps1
# 実行するとバージョンを更新し、タグを付与しGitHubへPushします

param (
    [ValidateSet("patch", "minor", "major")]
    [string]$level = "patch"
)

Write-Host "🔧 Poetryバージョンを更新中（$level）..."
poetry version $level

$version = poetry version -s
$tag = "v$version"

Write-Host "🔖 バージョン: $version"
Write-Host "🔧 Gitにコミット＆タグ付け..."

git add pyproject.toml poetry.lock
git commit -m "Release $tag"
git tag $tag
git push origin main --follow-tags

Write-Host "🚀 タグ $tag を push しました。GitHub Actions が起動します。"
