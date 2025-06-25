#!/usr/bin/env python3
"""
Release script for msys-shared-deps
"""
import argparse
import subprocess
import sys
from pathlib import Path


def run_command(cmd, capture_output=False):
    """コマンドを実行し、結果を返す"""
    print(f"🔧 実行中: {' '.join(cmd)}")
    try:
        result = subprocess.run(
            cmd, 
            check=True, 
            capture_output=capture_output, 
            text=True,
            cwd=Path(__file__).parent
        )
        return result.stdout.strip() if capture_output else None
    except subprocess.CalledProcessError as e:
        print(f"❌ エラー: {e}")
        sys.exit(1)


def main():
    """メイン関数"""
    parser = argparse.ArgumentParser(description="Release script for msys-shared-deps")
    parser.add_argument(
        "--level", 
        choices=["patch", "minor", "major"], 
        default="patch",
        help="バージョンアップのレベル (default: patch)"
    )
    
    args = parser.parse_args()
    
    print(f"📦 Poetryバージョンを更新中（{args.level}）...")
    
    # 1. Poetryバージョン更新
    run_command(["poetry", "version", args.level])
    
    # 2. バージョン取得
    version = run_command(["poetry", "version", "-s"], capture_output=True)
    tag = f"v{version}"
    print(f"🔖 バージョン: {version}")
    
    # 3. Gitに追加
    run_command(["git", "add", "pyproject.toml"])
    
    # poetry.lockファイルが存在する場合は追加
    if Path("poetry.lock").exists():
        run_command(["git", "add", "poetry.lock"])
    
    # 4. コミット＆annotatedタグ付け
    print("🔧 Gitにコミット＆タグ付け...")
    run_command(["git", "commit", "-m", f"Release {tag}"])
    run_command(["git", "tag", "-a", tag, "-m", f"Release {tag}"])
    
    # 5. GitHubにPush
    run_command(["git", "push", "origin", "main", "--follow-tags"])
    
    print(f"🚀 タグ {tag} を push しました。GitHub Actions が起動します。")


if __name__ == "__main__":
    main()
