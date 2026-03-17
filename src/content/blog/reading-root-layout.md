---
title: src/routes/+layout.svelte を読む — このサイトの共通レイアウト
description: ルートレイアウトファイルを1行ずつ読み解く。onNavigate・View Transition・MetaTags・UnoCSS の使い方を整理する。
date: '2026-03-17'
published: true
tags:
  - SvelteKit
  - Svelte
  - コードリーディング
---

このサイトの `src/routes/+layout.svelte` を読む。全71行のファイルだが、SvelteKitの重要な仕組みが詰まっている。

---

## ファイルの役割

SvelteKitでは `+layout.svelte` が**全ページ共通のラッパー**になる。ルート（`src/routes/`）に置いたものはサイト全体に適用される。

```
src/routes/
├── +layout.svelte   ← 全ページを包む共通レイアウト
├── +layout.ts       ← レイアウトのload関数・設定
└── blog/
    └── [slug]/
        └── +page.svelte
```

---

## +layout.ts — prerender の宣言

```ts
// src/routes/+layout.ts
export const prerender = true;
```

`prerender = true` を設定すると、SvelteKitはビルド時に全ページをHTMLとして出力する（静的サイト生成）。このサイトはすべてのページを事前レンダリングしている。

---

## script ブロック — インポートと初期化

```ts
import { onNavigate } from '$app/navigation';
import { page } from '$app/state';
import Nav from '$components/Nav.svelte';
import { Header as DarkModeHeader } from 'svelte-fancy-darkmode';
import { MetaTags } from 'svelte-meta-tags';
import 'uno.css';
import '@unocss/reset/tailwind.css';
```

| インポート | 役割 |
|-----------|------|
| `onNavigate` | ページ遷移のライフサイクルフック |
| `page` | 現在のURL・データなどのページ情報（Svelte 5のstoreではなくstateオブジェクト） |
| `Nav` | ナビゲーションコンポーネント |
| `DarkModeHeader` | ダークモード用の`<meta>`タグとテーマ色注入 |
| `MetaTags` | OGP・Twitterカードなどのメタタグ管理 |
| `uno.css` | UnoCSS（Tailwind互換ユーティリティCSS）の出力 |
| `tailwind.css` | CSSリセット |

---

## $props() — children の受け取り

```ts
const { children } = $props();
```

Svelte 5の `$props()` でプロパティを受け取る。レイアウトコンポーネントでは `children` が子ページのコンテンツになる。テンプレート側で `{@render children()}` として描画する。

---

## onNavigate — View Transition の統合

```ts
onNavigate((navigation) => {
  if (!document?.startViewTransition) {
    return;
  }

  return new Promise((resolve) => {
    document.startViewTransition(async () => {
      resolve();
      await navigation.complete;
    });
  });
});
```

`onNavigate` はページ遷移直前に呼ばれるフック。ここでは**View Transition API**と統合している。

**処理の流れ：**

1. `document.startViewTransition` が未対応のブラウザでは何もしない
2. `startViewTransition` に渡したコールバック内で `resolve()` を呼ぶ
3. SvelteKitはPromiseが解決されるまでDOM更新を待機する
4. `resolve()` が呼ばれたことでSvelteKitがDOMを更新し始める
5. `await navigation.complete` で遷移完了まで待つ

この仕組みにより、ページ遷移時にブラウザネイティブのアニメーションが適用される。

---

## $derived — リアクティブなタイトル

```ts
const title = $derived(page.data.title ?? 'home');
const description = `Portfolio of @irom999`;
```

`$derived` はSvelte 5のリアクティビティプリミティブ。`page.data.title` が変わると `title` も自動で再計算される。

各ページの `+page.ts` や `+page.server.ts` で `title` を返すと、ここで拾われてMetaTagsに渡る仕組み。

---

## テンプレート — MetaTags と構造

```svelte
<DarkModeHeader themeColors={{ dark: '#0F0F0F', light: '#ffffff' }} />

<MetaTags
  {description}
  openGraph={{ url: page.url.href, type: 'website', title, description }}
  {title}
  titleTemplate={title !== 'home' ? `%s | irom999.com` : 'irom999.com'}
  twitter={{ cardType: 'summary', site: '@irom999', title, description }}
/>

<main max-w-4xl mxa my3 px-8 un-dark>
  <Nav />
  {#key page.url}
    {@render children()}
  {/key}
</main>
```

### DarkModeHeader

ダークモードの `<meta name="theme-color">` とテーマ色をCSSカスタムプロパティで注入するコンポーネント。

### MetaTags

`svelte-meta-tags` ライブラリが提供するコンポーネント。`<title>` タグ・OGP・Twitterカードをまとめて管理できる。

`titleTemplate` の `%s` には `title` の値が入る。トップページだけ `irom999.com` とシンプルにするための条件分岐。

### main 要素のUnoCSS属性

```svelte
<main max-w-4xl mxa my3 px-8 un-dark>
```

HTMLの属性として直接UnoCSS（Tailwind互換）のクラスが書かれている。

| 属性 | 意味 |
|------|------|
| `max-w-4xl` | 最大幅を4xl（56rem）に制限 |
| `mxa` | `margin: auto`（水平中央揃え） |
| `my3` | 上下マージン |
| `px-8` | 左右パディング |
| `un-dark` | UnoCSS のダークモード適用フラグ |

### {#key page.url}

```svelte
{#key page.url}
  {@render children()}
{/key}
```

`#key` ブロックはキーが変わるたびにコンポーネントを**破棄して再生成**する。URLが変わるたびに子ページが再マウントされ、スクロール位置やアニメーションのリセットが保証される。

---

## style ブロック — グローバルスタイル

```svelte
<style>
  :global {
    body {
      --uno: font-sans text-base bg-white text-text-800
             dark:(bg-bg-base text-text-100)
             motion-safe:(transition transition-duration-1s scroll-smooth);
      text-autospace: normal;
      overflow-wrap: anywhere;
      word-break: normal;
      line-break: strict;
    }
    @view-transition {
      navigation: auto;
    }
  }
</style>
```

`:global {}` ブロック内のスタイルはSvelteのスコープから外れ、ドキュメント全体に適用される。

**`body` に指定しているもの：**

- `font-sans text-base` — フォントとベーステキストサイズ
- `bg-white / dark:bg-bg-base` — ライト・ダークの背景色
- `text-text-800 / dark:text-text-100` — ライト・ダークの文字色
- `motion-safe:(transition ...)` — アニメーション許可ユーザーのみ遷移アニメーションを有効化
- `text-autospace: normal` — CJKとラテン文字の間に自動でスペースを挿入するCSS新機能
- `overflow-wrap: anywhere` — 長いURLなどを折り返す
- `line-break: strict` — 日本語の禁則処理を厳格に適用

**`@view-transition { navigation: auto; }`**

CSSの `@view-transition` ルールでブラウザレベルのページ遷移アニメーションを有効化。`onNavigate` の JS コードと合わせて二段構えになっている。

---

## まとめ

`+layout.svelte` は以下の仕事を一手に担っている。

1. **静的サイト生成** — `+layout.ts` で `prerender = true`
2. **View Transition** — `onNavigate` + CSS `@view-transition` でページ遷移アニメーション
3. **メタタグ管理** — `MetaTags` でOGP・Twitterカードを全ページに適用
4. **ダークモード** — `DarkModeHeader` でテーマ色を注入
5. **レイアウト構造** — `<main>` でコンテンツ幅と中央揃えを設定
6. **グローバルスタイル** — `body` のフォント・色・日本語組版の設定
