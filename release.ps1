# release.ps1
# ワンコマンドでバージョンアップ + Gitタグ + Push を行い、GitHub ActionsでZIPリリース

param (
    [ValidateSet("patch", "minor", "major")]
    [string]$level = "patch"
)

# 1. Poetryバージョン更新
Write-Host "🔧 Poetryバージョンを更新中（$level）..."
poetry version $level

# 2. バージョン番号取得
$version = poetry version -s
$tag = "v$version"

Write-Host "🔖 バージョン: $version"

# 3. Gitに変更を追加
git add pyproject.toml

# poetry.lock が存在すれば追加
if (Test-Path poetry.lock) {
    git add poetry.lock
}

# 4. Gitコミットとタグ付け
Write-Host "🔧 Gitにコミット＆タグ付け..."
git commit -m "Release $tag"
git tag $tag

# 5. GitHubにPush（mainブランチ＆タグ）
git push origin main --follow-tags

Write-Host "🚀 タグ $tag を push しました。GitHub Actions が起動します。"
