---
title: SvelteKitのフォルダ構成を理解する
description: src/配下の全ファイルの役割と紐付き、+プレフィックスの意味、データの流れを解説。
date: '2026-03-17'
published: true
tags:
  - SvelteKit
  - 入門
---

# SvelteKitのフォルダ構成を理解する

---

## `src/` 配下の全構成

```
src/
├── app.html
├── app.d.ts
├── routes/
│   ├── +layout.ts
│   ├── +layout.svelte
│   ├── +page.svelte
│   ├── bio/
│   │   └── +page.svelte
│   └── blog/
│       ├── +page.svelte
│       ├── +page.server.ts
│       └── [slug]/
│           ├── +page.svelte
│           ├── +page.server.ts
│           └── prose.css
├── components/
│   ├── Nav.svelte
│   ├── Profile.svelte
│   ├── Social.svelte
│   ├── Button.svelte
│   └── LargeTitle.svelte
├── content/
│   └── blog/
│       └── *.md
└── lib/
    └── blog/
        └── index.ts
```

---

## `+` プレフィックスの重要な意味

SvelteKitでは `+` がついたファイルは**SvelteKitが自動で認識する特別なファイル**です。

`+` がないファイル（コンポーネントなど）と区別するための印であり、**SvelteKit独自の命名規則**です。

```
+page.svelte      → URLに対応するページ
+layout.svelte    → 複数ページ共通のレイアウト
+page.server.ts   → サーバー側（またはビルド時）の処理
+layout.ts        → レイアウトの設定
```

これはReactやVue.jsにはない、SvelteKit独自の概念です。ファイルを置くだけでルーティングが自動で設定されます。

---

## 各フォルダの役割と紐付き

### `app.html` — 全体の土台

すべてのページの骨格となるHTMLファイルです。`%sveltekit.body%` というプレースホルダーにSvelteKitが全コンポーネントを注入します。

### `routes/` — ページ（URL対応）

ファイルの場所がそのままURLになります。

```
+layout.ts        prerender=trueで静的ホスティングを指定
      ↓
+layout.svelte    全ページ共通UI（Nav・ダークモードなど）
      ↓ childrenとして各ページを包む
      ├── +page.svelte              → /
      ├── bio/+page.svelte          → /bio
      └── blog/+page.svelte         → /blog
          └── blog/[slug]/+page.svelte → /blog/hello-world 等
```

### `components/` — 再利用部品

Flutterで言う**独自Widget**に相当します。一度作れば複数のページで使い回せます。

```
Nav.svelte        +layout.svelte が使う（全ページに表示）
Profile.svelte    +page.svelte が使う（トップページのアイコン）
Social.svelte     +page.svelte が使う（SNSリンク）
LargeTitle.svelte blog/[slug]/+page.svelte が使う（記事タイトル）
```

### `content/blog/` — データ（記事）

ブログ記事をMarkdownファイルとして管理します。**ここにファイルを追加するだけでブログ記事が増えます。**

### `lib/` — 共通ロジック

UIを持たない処理だけのファイルを置きます。

```
lib/blog/index.ts
  ├── getPosts()  → 全記事一覧を返す
  └── getPost()   → 記事1件を返す
```

---

## データの流れ

```
content/blog/*.md
        ↓ 読み込む
lib/blog/index.ts
        ↓ 呼び出す
+page.server.ts
        ↓ データを渡す
+page.svelte（表示）
        ↓ コンポーネントを使う
components/*.svelte
        ↓ 全体を包む
+layout.svelte
        ↓ HTMLの土台に注入
app.html
```

---

## エントリーポイントの層構造

```
ブラウザがアクセス
        ↓
app.html（骨格）
        ↓ %sveltekit.body% に注入
+layout.svelte（共通レイアウト）
        ↓ children() に差し込み
+page.svelte（各ページ）
        ↓ importして使う
components/*.svelte（部品）
```

---

## `+page.server.ts` はサーバーが必要か

`prerender = true` の設定により、`+page.server.ts` の処理は**ビルド時に1回だけ実行**されます。

```
開発中（npm run dev）:
  アクセスのたびにNode.jsが+page.server.tsを実行
  → Markdownを読む → ブラウザに返す

ビルド時（npm run build）:
  1回だけ実行して全ページのHTMLを生成
  → 以後+page.server.tsは実行されない
  → Cloudflare Pagesはそのファイルを返すだけ
```

このリポジトリのデータソースはMarkdownファイルなので、本物のサーバーもDBも不要です。

---

## CSSはどこにあるか

このリポジトリはCSSファイルがほぼありません。理由は3つの仕組みで書かれているからです。

| 方法 | 場所 | 例 |
|---|---|---|
| UnoCSS（Attributify） | HTMLの属性として | `<main max-w-4xl mxa>` |
| コンポーネントスコープCSS | `.svelte`内の`<style>`タグ | `+page.svelte`のアニメーション |
| グローバルCSS | `prose.css`（1ファイルのみ） | ブログ記事本文のスタイル |

---

## Flutter との対比

| Flutter | SvelteKit |
|---|---|
| 独自Widget | `components/*.svelte` |
| 標準Widget | HTML要素（`<div>`, `<p>`など） |
| `MaterialApp` / `Scaffold` | `+layout.svelte` |
| 各画面のWidget | `+page.svelte` |
| `initState()` でのデータ取得 | `+page.server.ts` |
| `lib/widgets/` | `src/components/` |
