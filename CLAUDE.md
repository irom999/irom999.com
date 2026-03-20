# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
pnpm dev          # 開発サーバー起動
pnpm build        # プロダクションビルド
pnpm preview      # ビルド結果のプレビュー
pnpm check        # svelte-check による型チェック（全ファイル）
pnpm check:watch  # 型チェック（ウォッチモード）
pnpm lint         # ESLint
pnpm format       # Prettier フォーマット
```

## アーキテクチャ

### 技術スタック
- **SvelteKit** (Svelte 5) — フレームワーク
- **UnoCSS** — スタイリング（`uno.config.ts` で設定）
- **TypeScript** — 全ファイルで使用
- **unplugin-icons** — アイコン（`~icons/` プレフィックスでインポート）
- **gray-matter + unified** — Markdown処理

### スタイリングのルール
UnoCSS の `presetAttributify` が有効だが、**TypeScriptエラーを避けるため `class=""` 形式で記述する**。attributify mode（`<div flex mxa>` のような書き方）は使わない。

`uno.config.ts` に定義されたショートカット：
- `fcol` = `flex flex-col`
- `fyc` = `flex items-center`
- `fcc` = `flex justify-center items-center`
- `fxc` = `flex justify-center`
- `fxe` = `flex justify-end`
- `gcc` = `grid place-content-center place-items-center`
- `transition-base` = `transition-all transition-duration-500`
- `op-card` = `op70 dark:op50 hover:op80 group-hover:op80`
- `btn-{color}` = ボタンスタイル（動的ショートカット）

### ブログの仕組み
`src/content/blog/*.md` に Markdown ファイルを置くと自動的にブログ記事として公開される。

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

`published: false` にすると非公開。記事の読み込みは `src/lib/blog/index.ts` がサーバーサイドで Node.js の `fs` を使って処理する。

### Svelte 5 の注意点
- `children` を受け取るコンポーネントは `Props` 型に `children: Snippet` を含める（`import type { Snippet } from 'svelte'`）
- `$props()` を使用（Svelte 5 の runes 構文）
