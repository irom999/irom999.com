# irom999.com

森 裕介のポートフォリオサイト。

## 技術スタック

- **SvelteKit** (Svelte 5) — フレームワーク
- **UnoCSS** — スタイリング
- **TypeScript** — 全ファイルで使用
- **unplugin-icons** — アイコン
- **gray-matter + unified** — Markdown 処理
- **Typst** — CV (PDF) 生成

## 開発

依存パッケージをインストール：

```sh
pnpm install
```

開発サーバーを起動：

```sh
pnpm dev
```

## コマンド

```sh
pnpm dev          # 開発サーバー起動
pnpm build        # プロダクションビルド
pnpm preview      # ビルド結果のプレビュー
pnpm check        # 型チェック
pnpm lint         # ESLint
pnpm format       # Prettier フォーマット
pnpm build:cv     # CV (PDF) をビルド → static/cv.pdf
```

## ブログ

`src/content/blog/*.md` に Markdown ファイルを追加すると自動的にブログ記事として公開される。

フロントマター形式：

```yaml
---
title: タイトル
description: 説明
date: '2025-01-01'
published: true
tags:
  - tag1
---
```

`published: false` にすると非公開。

## CV

`cv/yusuke_mori.typ` を編集後、以下でビルド：

```sh
pnpm build:cv
```

`static/cv.pdf` に出力され、`/cv` からアクセスできる。
