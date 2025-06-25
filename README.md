# msys-shared-deps

MSYS 社内で共通利用する Python 依存パッケージをまとめたリポジトリです。

## 概要

このプロジェクトは、複数のプロジェクトで共通して利用する Python パッケージの依存関係を一元管理するためのものです。

## 開発・リリース工程

### 1. 初期セットアップ

```sh
# リポジトリをクローン
git clone <repository-url>
cd msys-shared-deps


# 依存関係をインストール
poetry install
```

### 2. 依存パッケージの追加・更新

Poetry コマンドを使って依存パッケージを追加・更新します：

```sh
# 新しいパッケージを追加
poetry add numpy

# バージョン指定で追加
poetry add "pandas>=1.5.0,<2.0.0"

# 開発用依存関係として追加
poetry add --group dev pytest

# 既存パッケージのアップデート
poetry update requests

# すべてのパッケージをアップデート
poetry update

# パッケージの削除
poetry remove numpy
```

Poetry コマンドを実行すると、`pyproject.toml` と `poetry.lock` が自動的に更新されます。

### 3. リリース (自動化スクリプト使用)

バージョン更新とリリースは `release.py` スクリプトで自動化されています：

```sh
# パッチバージョンアップ (例: 0.1.14 -> 0.1.15)
poetry run release

# マイナーバージョンアップ (例: 0.1.14 -> 0.2.0)
poetry run release --level minor

# メジャーバージョンアップ (例: 0.1.14 -> 1.0.0)
poetry run release --level major
```

#### スクリプトの実行内容

`release.py` は以下の処理を自動実行します：

1. **Poetry でバージョン更新**: 指定されたレベル（patch/minor/major）でバージョンを更新
2. **バージョン取得**: 更新されたバージョン番号を取得してタグ名を生成
3. **Git ファイル追加**: `pyproject.toml` と `poetry.lock` を Git に追加
4. **コミット & タグ付け**: リリースコミットを作成し、annotated タグを付与
5. **GitHub プッシュ**: メインブランチとタグを GitHub にプッシュ

#### 自動リリースプロセス

スクリプトがタグをプッシュすると、GitHub Actions が自動的に以下を実行します：

1. **環境セットアップ**: Python 3.12.4、pip、pip-tools をインストール
2. **要件ファイル生成**: `pyproject.toml` から `requirements.txt` を生成
3. **依存関係インストール**: すべての依存パッケージを `libs/` フォルダにインストール
4. **ZIP ファイル作成**: `msys-shared-deps_libs_v{VERSION}.zip` を作成
5. **GitHub Release**: ZIP ファイルを GitHub Releases にアップロード

### 4. ダウンロードと利用

リリースされた ZIP ファイルは以下から利用できます：

- GitHub の Releases ページからダウンロード
- ZIP ファイルを展開すると `libs/` フォルダに全依存パッケージが含まれています
- Python のパスに `libs/` フォルダを追加することで利用可能

```python
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'libs'))

# 依存パッケージが利用可能
import requests
import cryptography
import openpyxl
import boxsdk
```

## ライセンス

本リポジトリは MSYS 社内利用を想定しています。
