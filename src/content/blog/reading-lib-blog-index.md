---
title: SvelteKitのコードを読む — lib/blog/index.ts編
description: TypeScriptのinterface・export・チェーン処理・Null合体演算子・unifiedパイプラインをlib/blog/index.tsで解説。
date: '2026-03-17'
published: true
tags:
  - SvelteKit
  - TypeScript
  - 入門
---

# SvelteKitのコードを読む — lib/blog/index.ts編

このファイルはブログ記事の読み込みと変換を担当する。`routes/`配下からは直接呼ばれず、`+page.server.ts`経由で使われる。

---

## ファイルの全体像

```
readMarkdownFiles()  → src/content/blog/*.mdを全部読む（内部処理）
getPosts()           → 記事一覧を返す（/blog ページで使う）
getPost(slug)        → 記事1件をHTMLに変換して返す（/blog/[slug] ページで使う）
```

---

## ブロック① インポート

```ts
import fs from 'node:fs'       // ファイル読み書き（Node.js組み込み）
import path from 'node:path'   // ファイルパス操作（Node.js組み込み）
import matter from 'gray-matter' // Markdownのメタデータ解析
import { unified } from 'unified' // Markdown→HTML変換パイプライン
```

`node:`プレフィックスは「Node.js組み込みモジュール」を明示する書き方。`npm install`不要。

---

## ブロック② interface（型の設計図）

```ts
export interface BlogPost {
  slug: string       // URL用のID例: "hello-world"
  title: string      // 記事タイトル
  description: string
  date: string
  published: boolean // 公開・非公開フラグ
  tags: string[]     // 文字列の配列
}

export interface BlogPostWithContent extends BlogPost {
  html: string       // BlogPostの全項目 ＋ html だけ追加
}
```

`interface`はTypeScript独自の機能で「このオブジェクトはこの形にしてね」という型の設計図。

`extends`はFlutterのクラス継承と同じ概念：

```ts
// TypeScript
interface BlogPostWithContent extends BlogPost { ... }
```

```dart
// Flutter（同じ概念）
class BlogPostWithContent extends BlogPost { ... }
```

---

## exportありとなしの違い

```ts
// export なし → このファイルの中だけで使える（内部処理）
function readMarkdownFiles() { ... }

// export あり → 他のファイルからimportして使える（外部公開）
export function getPosts() { ... }
export function getPost() { ... }
```

部屋に例えると：

```
lib/blog/index.ts という部屋

export なし readMarkdownFiles() → 部屋の中だけで使う道具（外には出せない）
export あり getPosts()          → 窓口に出して他の部屋から使える
export あり getPost()           → 窓口に出して他の部屋から使える
```

実際に`+page.server.ts`では`export`ありの関数だけimportできる：

```ts
import { getPosts } from '$lib/blog'   // ← exportありだからimportできる
// readMarkdownFilesはimportできない   ← exportなしだから
```

---

## ブロック③ `readMarkdownFiles()` — チェーン処理

```ts
function readMarkdownFiles(): { slug: string; raw: string }[] {
  if (!fs.existsSync(BLOG_DIR)) return []  // フォルダがなければ空配列を返す

  return fs
    .readdirSync(BLOG_DIR)            // フォルダ内のファイル名一覧を取得
    .filter((f) => f.endsWith('.md')) // .mdファイルだけに絞る
    .map((f) => ({                    // 各ファイルを変換
      slug: f.replace('.md', ''),     // "hello-world.md" → "hello-world"
      raw: fs.readFileSync(path.join(BLOG_DIR, f), 'utf-8'),
    }))
}
```

`.filter().map()`は配列のチェーン処理。Dartの`where().map()`と同じ：

```dart
// Flutter（同じ概念）
files
  .where((f) => f.endsWith('.md'))
  .map((f) => {'slug': f.replaceAll('.md', ''), 'raw': readFile(f)})
```

---

## ブロック④ `getPosts()` — Null合体演算子

```ts
export function getPosts(): BlogPost[] {
  return readMarkdownFiles()
    .map(({ slug, raw }) => {
      const { data } = matter(raw)   // メタデータを取り出す
      if (!data.published) return null // published:falseなら除外

      return {
        slug,
        title: data.title ?? slug,   // titleがなければslugを代わりに使う
        //              ↑ Null合体演算子
      } satisfies BlogPost
    })
    .filter((p): p is BlogPost => p !== null) // nullを除外
    .sort((a, b) =>
      new Date(b.date).getTime() - new Date(a.date).getTime() // 新しい順
    )
}
```

`??`（Null合体演算子）はDartと全く同じ記法：

```ts
// TypeScript
title: data.title ?? slug
// → data.titleがnull/undefinedならslugを使う

// Dart（同じ）
title = data['title'] ?? slug;
```

---

## ブロック⑤ `getPost()` — unifiedパイプライン

```ts
export async function getPost(slug: string): Promise<BlogPostWithContent | null> {
  const filePath = path.join(BLOG_DIR, `${slug}.md`)
  if (!fs.existsSync(filePath)) return null  // ファイルがなければnull（404用）

  const raw = fs.readFileSync(filePath, 'utf-8')
  const { data, content } = matter(raw)
  // data    → メタデータ（title・date・tagsなど）
  // content → 本文（---より下の部分）

  const result = await unified()
    .use(remarkParse)            // Markdownをパース
    .use(remarkRehype)           // Markdown → HTML構造に変換
    .use(rehypeSlug)             // 見出しにidをつける（#リンク用）
    .use(rehypeAutolinkHeadings) // 見出しをクリックできるリンクにする
    .use(rehypePrettyCode, { theme: 'github-dark' }) // シンタックスハイライト
    .use(rehypeStringify)        // HTML文字列に変換
    .process(content)            // 実行

  return { ...data, html: result.toString() }
}
```

`unified().use().use().process()`はパイプライン処理。データを順番に加工していく：

```
Markdownテキスト
    ↓ remarkParse      → 構造化データ（AST）に変換
    ↓ remarkRehype     → HTML構造に変換
    ↓ rehypeSlug       → 見出しにid付与
    ↓ rehypePrettyCode → コードに色付け
    ↓ rehypeStringify  → HTML文字列に変換
    完成したHTML
```

---

## まとめ

| 概念 | 説明 |
|---|---|
| `interface` | オブジェクトの型の設計図 |
| `extends` | 別のinterfaceを継承して項目を追加 |
| `export`あり | 他のファイルからimportできる |
| `export`なし | そのファイル内でのみ使える |
| `??` | 左がnull/undefinedなら右を使う |
| チェーン処理 | `.filter().map().sort()`を繋げて書く |
| パイプライン | データを順番に加工していく処理 |
