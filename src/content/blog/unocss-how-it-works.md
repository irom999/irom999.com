---
title: UnoCSSの仕組み — スキャン・照合・生成とuno.config.tsの役割
description: UnoCSSがどうやってCSSを生成するか。TailwindとのPurgeCSS方式との違い、presetとuno.config.tsの役割分担を整理する。
date: '2026-03-18'
published: true
tags:
  - UnoCSS
  - Tailwind
  - SvelteKit
  - CSS
  - 入門
---

UnoCSSはTailwind互換のユーティリティCSSフレームワークだが、全CSSを事前に出力するのではなく**使ったクラスだけを生成する**。その仕組みを整理する。

---

## Tailwindの仕組みと歴史

### Tailwind v2 以前 — 全件出力 + PurgeCSS

初期のTailwindは**全クラスのCSSをまず出力**し、その後 PurgeCSS という別ツールで未使用のCSSを削除するという2段階の方式だった。

```
全クラスのCSS を出力（数MB）
        ↓
PurgeCSS がソースをスキャンして未使用クラスを削除
        ↓
使ったクラスだけ残る（数KB）
```

この方式はビルドが遅く、設定も複雑だった。

### Tailwind v3 以降 — JIT（Just-In-Time）

Tailwind v3 から **JITモード**が導入され、方式が逆転した。

```
ソースをスキャンしてクラス名を収集
        ↓
収集したクラスに対してだけ CSS を生成
```

「全部出してから削る」から「使うものだけ作る」に変わった。PurgeCSSは不要になり、ビルドも高速化した。

### UnoCSS — JITをさらに推し進めた設計

UnoCSSはTailwind v3のJIT方式をベースに、さらにスキャン精度と速度を高めた設計になっている。Tailwindとの実質的な処理フローは近いが、presetによるルール管理の柔軟性が高い。

---

## UnoCSSの全体の流れ

```
① ソースファイルをスキャン（クラス名を文字列として収集）
        ↓
② uno.config.ts + preset のルールと照合
        ↓
③ 一致したクラスだけ CSS を生成・出力
```

---

## ① スキャン

UnoCSSはビルド時にソースファイルを文字列として読み、クラス名らしき文字列を収集する。

例えば `+layout.svelte` に以下のような記述があれば：

```svelte
<main max-w-4xl mxa my3 px-8 un-dark>
```

`max-w-4xl`・`mxa`・`my3`・`px-8`・`un-dark` が候補として収集される。

### スキャン対象の除外

`uno.config.ts` の `content.pipeline.exclude` でスキャンから除外するファイルを指定できる。

```ts
content: {
  pipeline: {
    exclude: [/~icons/, /svelte-meta-tags/],
  },
},
```

`svelte-meta-tags` のソース内に偶然 `text-red-500` のような文字列があっても、クラス名として拾わないようにするための設定。

---

## ② 照合 — ルールはどこにあるか

スキャンで収集したクラス名を「このクラスはどのCSSか」というルールと照合する。ルールは2か所に存在する。

### preset の中（`preset-wind3.mjs` など）

`presetWind3()` はTailwind互換の膨大なルールを持つ。`max-w-4xl` や `flex` などはここで定義されている。`uno.config.ts` はこのpresetを「使う」と宣言するだけ。

```ts
presets: [
  presetWind3(),        // Tailwind互換ルールの本体
  presetAttributify(),  // 属性として書けるようにする
  presetIcons(),        // アイコンのユーティリティ
  presetTypography(),   // prose クラス
  presetFluid(),        // fluid typography
]
```

presetの実体は `node_modules/unocss/dist/preset-wind3.mjs` に入っている。`unocss` パッケージをインストールするだけで全公式presetが使える。

### uno.config.ts の中（独自ルール）

プロジェクト固有のルールは `uno.config.ts` に書く。

**shortcuts — クラスの短縮エイリアス**

```ts
shortcuts: [
  {
    fcc: 'flex justify-center items-center',
    fcol: 'flex flex-col',
    fxc: 'flex justify-center',
    fyc: 'flex items-center',
  },
  [
    /^btn-(\w+)$/,
    ([_, color]) =>
      `op50 px2.5 py1 transition-all hover:(op100 text-${color} bg-${color}/10) border rounded`,
  ],
]
```

`fcc` と書くだけで `flex justify-center items-center` と同じCSSが出る。`btn-orange` のように動的なショートカットも作れる。

**extendTheme — 独自カラーの追加**

```ts
extendTheme: (_theme) => {
  const merged = { ..._theme };
  Object.assign(merged.colors, {
    accent: { 100: '#FB923C', 200: '#F97316', 300: '#C2410C' },
    text:   { 100: '#FFFFFF', /* ... */ 800: '#0f0f0f' },
    bg:     { base: '#0F0F0F', 100: '#1E1E1E', /* ... */ },
  });
  return merged;
},
```

`text-accent-100`・`bg-bg-base` などの独自カラーが `text-red-500` と同じ感覚で使えるようになる。

---

## ルールの場所まとめ

| ルールの場所 | 例 |
|------------|-----|
| `presetWind3()` の中（`preset-wind3.mjs`） | `max-w-4xl`, `px-8`, `flex`, `dark:` など |
| `uno.config.ts` の `shortcuts` | `fcc`, `fcol`, `btn-*` など独自定義 |
| `uno.config.ts` の `extendTheme` | `text-accent-100`, `bg-bg-base` など独自カラー |

**`uno.config.ts` は独自ルールの追加とpresetの選択を担い、Tailwind互換のルール本体は `presetWind3.mjs` の中にある。**

---

## ③ 生成

照合で一致したクラスのみCSSとして出力される。

```css
/* max-w-4xl だけ使っていれば、これだけ出力される */
.max-w-4xl { max-width: 56rem; }

/* max-w-2xl は使っていないので出力されない */
```

使っていないクラスは一切出力されないため、最終的なCSSファイルは最小サイズになる。

---

## .mjs とは

`preset-wind3.mjs` の `.mjs` はES Module（ESM）形式のJavaScriptファイルを示す拡張子。`.js` はCommonJSかESMか曖昧だが、`.mjs` はESMであることをNode.jsに明示する。

| 拡張子 | モジュール形式 |
|--------|-------------|
| `.mjs` | ES Module（`import` / `export`） |
| `.cjs` | CommonJS（`require()` / `module.exports`） |
| `.js` | `package.json` の `"type"` 次第 |

`.d.mts` は対応するTypeScript型定義ファイル。

---

## TailwindとUnoCSSの比較

| | Tailwind v2以前 | Tailwind v3（JIT） | UnoCSS |
|--|----------------|-------------------|--------|
| 方式 | 全出力 + Purge | JIT（使うものだけ生成） | JIT（同様） |
| ルール定義 | `tailwind.config.js` | `tailwind.config.js` | `uno.config.ts` + preset |
| preset の概念 | なし（プラグインのみ） | なし | あり（柔軟に組み合わせ可） |
| 属性記法 | 非対応 | 非対応 | `presetAttributify` で対応 |

---

## まとめ

1. Tailwind v2以前は全CSS出力 → PurgeCSSで削除という方式だった
2. Tailwind v3のJITで「使うものだけ生成」に転換した
3. UnoCSSはJIT方式をベースに、presetでルールを柔軟に管理する設計
4. ルールはpresetの `.mjs`（Tailwind互換）と `uno.config.ts`（独自定義）の2か所にある
5. 一致したクラスだけCSSを出力するので最終ファイルが軽い
