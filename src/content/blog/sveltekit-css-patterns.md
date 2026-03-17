---
title: SvelteKitのCSS記述パターン3種類
description: UnoCSS（Attributify）・コンポーネントスコープCSS・グローバルCSSファイルの使い分けを解説。
date: '2026-03-17'
published: true
tags:
  - SvelteKit
  - CSS
  - UnoCSS
  - 入門
---

# SvelteKitのCSS記述パターン3種類

このリポジトリではCSSを3つの方法で書いており、独立したCSSファイルがほぼ不要な構成になっている。

---

## 全体像

| パターン | 場所 | 用途 |
|---|---|---|
| ① UnoCSS（Attributify） | HTMLの属性として | ほぼ全てのスタイル |
| ② コンポーネントスコープCSS | `.svelte`内の`<style>`タグ | アニメーションなど複雑なCSS |
| ③ グローバルCSSファイル | `prose.css`（1ファイルのみ） | Markdownから生成されるHTMLのスタイル |

---

## ① UnoCSS（Attributify モード）

クラス名をHTMLの**属性**として直接書く方法。`uno.config.ts`の`presetAttributify()`で有効になる。

```svelte
<!-- +layout.svelte -->
<main max-w-4xl mxa my3 px-8>
```

これは実際には以下のCSSと同じ意味：

```css
max-width: 56rem;        /* max-w-4xl */
margin-left: auto;       /* mxa */
margin-right: auto;
margin-top: 0.75rem;     /* my3 */
margin-bottom: 0.75rem;
padding-left: 2rem;      /* px-8 */
padding-right: 2rem;
```

### ショートカットも定義できる

`uno.config.ts`でよく使う組み合わせを短縮できる：

```ts
shortcuts: {
  fcc:  'flex justify-center items-center',
  fxc:  'flex justify-center',
  fyc:  'flex items-center',
  gcc:  'grid place-content-center place-items-center',
}
```

```svelte
<!-- 使う側 -->
<div fcc>  ← flex justify-center items-center と同じ
```

### ダークモードも属性で書ける

```svelte
<p text="gray-600 dark:gray-300">
<!--              ↑ダークモード時はgray-300 -->
```

### UnoCSSの仕組み

UnoCSSはビルド時に全`.svelte`ファイルをスキャンして、**使われているクラス名のCSSだけを生成**する。使っていないCSSは生成されないため、ファイルサイズが最小限になる。

---

## ② コンポーネントスコープCSS

`.svelte`ファイル内の`<style>`タグに書いたCSSは**そのコンポーネントだけに適用**される。

```svelte
<!-- +page.svelte -->
<p class="word">Hello</p>

<style>
  .word {
    display: inline-block;
    animation: typing 0.3s steps(10) forwards;
  }

  @keyframes typing {
    from { max-width: 0; opacity: 1; }
    to   { max-width: 100%; opacity: 1; }
  }
</style>
```

### スコープの重要性

他のページに同じ`.word`クラスがあっても**干渉しない**。SvelteKitがビルド時にクラス名にユニークなハッシュを付与するため：

```css
/* ビルド後のイメージ */
.word.svelte-abc123 {   ← ハッシュが自動付与される
  animation: typing ...
}
```

### 使いどころ

UnoCSSでは表現しにくい複雑なCSSを書くときに使う：
- `@keyframes`アニメーション
- `:nth-child()`などの複雑なセレクター
- `animation-delay`の細かい制御

---

## ③ グローバルCSSファイル（prose.css）

このリポジトリで唯一の独立したCSSファイル。ブログ記事ページでのみimportされる。

```ts
// blog/[slug]/+page.svelte
import './prose.css'
```

### なぜ必要か

ブログ記事はMarkdownから自動生成されるHTMLのため、クラス名を直接書けない：

```markdown
<!-- Markdownで書く -->
# 見出し
本文テキスト
```

```html
<!-- 自動生成されるHTML -->
<h1>見出し</h1>
<p>本文テキスト</p>
```

`<h1>`や`<p>`にUnoCSSのクラスを付与できないため、セレクターでスタイルを当てるCSSファイルが必要になる。

---

## まとめ：使い分けの判断基準

```
クラス名を書けるHTMLの場合
  → ① UnoCSS（Attributify）を使う

アニメーションなど複雑なCSSの場合
  → ② <style>タグに書く

自動生成されるHTMLにスタイルを当てたい場合
  → ③ 独立したCSSファイルを作る
```

この構成のメリットは**ほぼ全てのスタイルがコンポーネントと同じファイルにまとまる**こと。別のCSSファイルを探し回る必要がなく、コンポーネントを見れば見た目もわかる。
