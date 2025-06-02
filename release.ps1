param (
    [ValidateSet("patch", "minor", "major")]
    [string]$level = "patch"
)

# 1. Poetryバージョン更新
Write-Host "📦 Poetryバージョンを更新中（$level）..."
poetry version $level

# 2. バージョン取得
$version = poetry version -s
$tag = "v$version"
Write-Host "🔖 バージョン: $version"

# 3. Gitに追加
git add pyproject.toml
if (Test-Path poetry.lock) {
    git add poetry.lock
}

# 4. コミット＆annotatedタグ付け
Write-Host "🔧 Gitにコミット＆タグ付け..."
git commit -m "Release $tag"
git tag -a $tag -m "Release $tag"

# 5. GitHubにPush
git push origin main --follow-tags

Write-Host "🚀 タグ $tag を push しました。GitHub Actions が起動します。"
