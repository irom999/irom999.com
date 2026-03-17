---
title: SvelteKitの設定ファイルを理解する
description: package.json・vite.config.ts・tsconfig.json・eslint・prettierなど設定ファイルの役割と必要な理由を解説。
date: '2026-03-17'
published: true
tags:
  - SvelteKit
  - 入門
---

# SvelteKitの設定ファイルを理解する

プロジェクト直下にある設定ファイルは「誰が何に何を伝えるか」でそれぞれ役割が違う。

---

## 全体像

```
package.json      → npm/pnpm に「何をインストールするか・どんなコマンドを使うか」
pnpm-lock.yaml    → npm/pnpm に「正確なバージョンを固定する」
svelte.config.js  → SvelteKit に「どこにデプロイ・どんなエイリアスを使うか」
vite.config.ts    → Vite に「どのプラグインを使うか」
tsconfig.json     → TypeScript に「どこまで厳しくチェックするか」
uno.config.ts     → UnoCSS に「どんなクラス・色・フォントを使うか」
eslint.config.js  → ESLint に「どんなルールでコードをチェックするか」
.prettierrc       → Prettier に「どんなフォーマットで整形するか」
.prettierignore   → Prettier に「どのファイルは整形しないか」
```

---

## `package.json` — プロジェクトの設計図

```json
{
  "scripts": {
    "dev": "vite dev",      // npm run dev で開発サーバー起動
    "build": "vite build",  // npm run build でビルド
    "format": "prettier --write ."  // npm run format で整形
  },
  "devDependencies": {
    "svelte": "^5.49.2",
    "unocss": "^66.6.0"
  }
}
```

`npm install`はこのファイルを読んでパッケージをインストールする。プロジェクトの「材料リスト」。

---

## `pnpm-lock.yaml` — バージョンの固定

```
package.jsonの "^5.49.2" は「5.49.2以上なら何でもOK」という意味。
pnpm-lock.yaml は正確なバージョン（例: 5.49.2）を記録して固定する。
→ 別のPCやチームメンバーでも全員が同じバージョンをインストールできる。
```

手動で編集しない。`pnpm install`が自動で更新する。

---

## `svelte.config.js` — SvelteKitの設定

```js
const config = {
  preprocess: [vitePreprocess()],
  // → .svelteファイルの<script lang="ts">をViteがJSに変換する前処理

  vitePlugin: {
    dynamicCompileOptions({ filename }) {
      if (!filename.includes('node_modules')) {
        return { runes: true }
        // → Svelte5の新機能（$props・$state・$derived等）を有効化
      }
    },
  },

  kit: {
    adapter: adapter(),
    // → 静的ホスティング用のアダプター（Cloudflare Pages向け）

    alias: {
      $components: './src/components',
      // → import Profile from '$components/Profile.svelte' と書けるようになる
    },
  },
}
```

---

## `vite.config.ts` — Viteのプラグイン設定

```ts
export default defineConfig({
  plugins: [
    Icons({ compiler: 'svelte' }),
    // → クラス名でアイコンを表示できる（i-ph-github-logo-duotoneなど）

    UnoCSS({ extractors: [extractorSvelte()] }),
    // → .svelteファイルをスキャンしてCSSを生成

    sveltekit(),
    // → Svelteコンパイル・ルーティング・SSRなどSvelteKit全体の処理
  ],
})
```

プラグインはViteの機能を拡張するもの。ライブラリ（コードの中でimportして使う）とは別物。

---

## `tsconfig.json` — TypeScriptの設定

```json
{
  "extends": "./.svelte-kit/tsconfig.json",
  // → SvelteKitが自動生成した設定を継承（$app/...などの型情報）

  "compilerOptions": {
    "strict": true,
    // → 厳格な型チェック。これがないとTypeScriptの恩恵が半減する

    "sourceMap": true,
    // → ブラウザのDevToolsで元のコードの行番号でデバッグできる

    "moduleResolution": "bundler"
    // → Viteなどのバンドラーに合わせたモジュール解決方法
  }
}
```

---

## `uno.config.ts` — UnoCSSの設定

```ts
export default defineConfig({
  presets: [
    presetWind3(),       // TailwindCSS互換のクラス名を使えるように
    presetAttributify(), // <div fcc> のような属性記法を有効化
    presetIcons(),       // i-ph-github-logo-duotone のようなアイコンクラスを有効化
    presetWebFonts(),    // Inter・DM Monoなどのフォントを設定
    presetTypography(),  // ブログ記事本文の読みやすいスタイル
  ],
  shortcuts: {
    fcc:  'flex justify-center items-center',
    fxc:  'flex justify-center',
    fyc:  'flex items-center',
    gcc:  'grid place-content-center place-items-center',
    // → <div fcc> と書くだけで flex justify-center items-center が適用される
  },
})
```

---

## `eslint.config.js` — コード品質チェック

```js
rules: {
  '@typescript-eslint/no-unused-vars': 'warn',
  // → 使っていない変数があったら警告を出す
}
```

FlutterのAnalyzerに相当する。コードの書き間違いやバグになりそうな箇所を自動検出する。ビルドには関係なく、開発時のみ使われる。

---

## `.prettierrc` — コード整形ルール

```json
{
  "useTabs": true,           // インデントはタブを使う
  "singleQuote": true,       // " ではなく ' を使う
  "trailingComma": "all",    // 配列・オブジェクトの末尾にカンマをつける
  "printWidth": 100,         // 1行100文字を超えたら改行する
  "plugins": ["prettier-plugin-svelte"],  // .svelteファイルにも対応
  "overrides": [
    { "files": "*.svelte", "options": { "parser": "svelte" } }
  ]
}
```

`npm run format`を実行すると全ファイルが自動整形される。FlutterのDart Formatterに相当。

---

## `.prettierignore` — 整形しないファイル

```
.svelte-kit    ← SvelteKitが自動生成するファイル
build          ← ビルド成果物
node_modules   ← パッケージ本体
pnpm-lock.yaml ← 自動生成されるロックファイル
```

共通点は「自動生成されるファイル」。手動で書いていないファイルは整形対象から除外する。

---

## ビルド時の各ファイルの扱い

```
ビルドの対象（変換・出力される）:
  src/  → build/ に変換して出力
  static/ → build/ にそのままコピー

ビルドの設定として読まれる（出力はされない）:
  svelte.config.js / vite.config.ts / tsconfig.json / uno.config.ts

開発時のみ使われる（ビルドに関係ない）:
  eslint.config.js / .prettierrc / .prettierignore

管理情報（ビルドに関係ない）:
  package.json / pnpm-lock.yaml
```
