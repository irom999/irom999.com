---
title: SvelteKitのコードを読む — Nav.svelte・+layout.svelte編
description: import * as・{#snippet}・page.url・{#key}・{@render children()}をNav.svelteと+layout.svelteで解説。
date: '2026-03-17'
published: true
tags:
  - SvelteKit
  - Svelte
  - 入門
---

# SvelteKitのコードを読む — Nav.svelte・+layout.svelte編

---

## `.svelte`拡張子の意味

`.svelte`は単なるファイル名ではなく、**Svelteコンパイラが認識する特別な形式**。

```
Profile.ts     → TypeScriptファイル。UIは作れない
Profile.svelte → Svelteコンポーネント。HTML + CSS + TSを1ファイルに書ける
```

ただし「SvelteKitがルーティングに使うかどうか」はファイル名と場所で決まる：

```
src/routes/+page.svelte    → URLに対応するページとして認識される
src/components/Nav.svelte  → ただのコンポーネント（URLとは無関係）
```

---

# Nav.svelte を読む

---

## ブロック① インポート

```ts
import { resolve } from '$app/paths'
// → URLを正しく解決するSvelteKit組み込み関数

import { page } from '$app/state'
// → 現在のページ情報（URL等）をリアクティブに取得

import * as DarkMode from 'svelte-fancy-darkmode'
// → * as は「全部まとめてDarkModeという名前で取り込む」

import MoonToSunny from '~icons/line-md/moon-filled-to-sunny-filled-loop-transition'
import SunnyToMoon from '~icons/line-md/sunny-filled-loop-to-moon-filled-transition'
// → unplugin-iconsでアイコンをコンポーネントとして使う
```

`import * as`はまとめてimportする書き方：

```ts
// 通常の書き方
import { ToggleButton, Header } from 'svelte-fancy-darkmode'

// * as でまとめて取り込む
import * as DarkMode from 'svelte-fancy-darkmode'
DarkMode.ToggleButton  // このようにアクセスする
DarkMode.Header
```

---

## ブロック② `{#snippet}` — 再利用できるHTMLの断片

```svelte
{#snippet underline(isPath: boolean, transparentDefault = false)}
  <span
    class={{
      'bg-accent-100': isPath,    // isPathがtrueならオレンジ下線
      'bg-transparent': !isPath,  // falseなら透明
    }}
  ></span>
{/snippet}
```

`{#snippet}`はSvelte5の新機能で関数に近い概念：

```
引数: isPath（現在のページかどうか）
処理: trueならオレンジ、falseなら透明なspanを返す
```

呼び出すときは`{@render}`を使う：

```svelte
{@render underline(page.url.pathname === '/')}
// → 現在のパスが / なら isPath=true → オレンジ下線が表示される
```

---

## ブロック③ リアクティブなURL監視

```svelte
<div class={{ hidden: page.url.pathname === '/' }}>
  @irom999
</div>
```

`page.url.pathname`はページ遷移のたびに自動更新される：

```
/ にいるとき    → page.url.pathname === '/' が true  → @irom999が非表示
/blog にいるとき → page.url.pathname === '/' が false → @irom999が表示
```

Reactで同じことを書くと`usePathname()`フックが必要：

```jsx
// React
const pathname = usePathname()
<div className={pathname === '/' ? 'hidden' : ''}>
  @irom999
</div>
```

Svelteは`page`を参照するだけで自動的にリアクティブになる。

---

## ブロック④ ダークモードボタン

```svelte
<DarkMode.ToggleButton>
  {#snippet dark()}
    <SunnyToMoon />   ← ダークモード時に表示するアイコン
  {/snippet}

  {#snippet light()}
    <MoonToSunny />   ← ライトモード時に表示するアイコン
  {/snippet}
</DarkMode.ToggleButton>
```

2つのsnippetをpropsとして渡している。どのアイコンを表示するかは親（Nav.svelte）が決め、切り替えのロジックはDarkMode側が持つ設計。

---

# +layout.svelte のHTMLを読む

```svelte
<main max-w-4xl mxa my3 px-8 un-dark>
  <Nav />
  {#key page.url}
    {@render children()}
  {/key}
</main>
```

---

## `<main>` の属性

```svelte
<main max-w-4xl mxa my3 px-8 un-dark>
<!--  最大幅制限  中央寄せ 上下余白 左右余白 ダークモード -->
```

全部UnoCSSのAttributify。CSSクラスをHTMLの属性として書いている。

---

## `<Nav />`

`Nav.svelte`コンポーネントをここに配置。`+layout.svelte`は全ページ共通なので、ナビゲーションが全ページに表示される。

---

## `{#key page.url}` — 値が変わるたびに作り直す

```svelte
{#key page.url}
  {@render children()}
{/key}
```

`{#key}`は**値が変わるたびに中身を完全に破棄して作り直す**Svelteの構文：

```
/ にアクセス    → page.url が変わる → children()を作り直す
/blog に遷移   → page.url が変わる → children()を作り直す
/bio に遷移    → page.url が変わる → children()を作り直す
```

これがないとページ遷移時にView Transitionsアニメーションが正しく動かない。

---

## `{@render children()}` — ページの中身を差し込む

```svelte
{@render children()}
```

`children()`は各`+page.svelte`の内容。`+layout.svelte`はここに各ページを差し込む：

```
/ にアクセス時:
<main>
  <Nav />
  +page.svelte の中身  ← children()
</main>

/blog にアクセス時:
<main>
  <Nav />
  blog/+page.svelte の中身  ← children()
</main>
```

FlutterのNavigatorで言う「画面の中身が切り替わる場所」に相当する。

---

## まとめ

| 構文・機能 | 説明 |
|---|---|
| `import * as X` | 全エクスポートをXという名前でまとめてimport |
| `{#snippet}` | 再利用できるHTMLの断片（引数を取れる） |
| `{@render}` | snippetを呼び出して表示する |
| `page.url.pathname` | 現在のURLをリアクティブに取得 |
| `{#key 値}` | 値が変わるたびに中身を作り直す |
| `{@render children()}` | 子ページの内容をここに差し込む |
