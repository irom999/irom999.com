---
title: フロントエンド技術の描画方式を比較する — DOM・Canvas・WebAssembly
description: React/Svelte・Three.js・Flutter WebがそれぞれどうやってUIを画面に出すか。DOM操作・Canvas描画・WebAssemblyの違いを整理する。
date: '2026-03-18'
published: true
tags:
  - Web標準
  - Flutter
  - React
  - Svelte
  - 入門
---

ブラウザに何かを表示する方法は1つではない。React・Svelte・Three.js・Flutter Webはそれぞれ異なる方法で画面を描いている。その違いを整理する。

---

## ブラウザが画面を描く3つの手段

| 手段 | 概要 |
|------|------|
| **DOM** | HTMLタグをツリー構造で管理し、CSSでスタイルを当てる |
| **Canvas** | `<canvas>` 要素にJavaScriptから直接ピクセルを描く |
| **WebAssembly** | C++などをブラウザで動かし、Canvasに描画する |

フロントエンドフレームワークは、この3つのどれか（または組み合わせ）を使っている。

---

## ① DOM方式 — React・Svelte・Vue

### 仕組み

```
コンポーネント（JSX / .svelte）
        ↓
JavaScript が DOM ツリーを操作
        ↓
ブラウザのレンダリングエンジンが CSS を適用して描画
```

HTMLの `<div>`・`<p>`・`<button>` などの要素がDOMツリーとして存在し、CSSがスタイルを決める。開発者ツールで「要素を検証」すると中身が見える。

### Virtual DOM（React）とコンパイラ方式（Svelte）

React は**Virtual DOM**という仮想のDOMツリーをメモリ上に持ち、差分だけ実際のDOMに反映する。

```
状態が変わる
    ↓
新しい Virtual DOM を作る
    ↓
前回との差分を計算（Diffing）
    ↓
差分だけ実際の DOM を更新
```

Svelte は**コンパイル時**にどのDOMを更新すべきか解析し、Virtual DOMを持たない直接更新のコードを生成する。

```
状態が変わる
    ↓
コンパイル済みのコードが直接 DOM を更新
（差分計算のランタイムコストがない）
```

### DOM方式の特徴

- SEO・アクセシビリティが自然に機能する（HTMLが存在するため）
- ブラウザのテキスト選択・検索が使える
- CSSやブラウザ拡張機能との相性が良い
- 複雑なアニメーションや大量の描画更新は苦手

---

## ② Canvas方式 — Three.js・ゲームエンジン系

### 仕組み

```
JavaScript の描画命令
        ↓
<canvas> 要素の 2D/WebGL コンテキストに描画
        ↓
ピクセル単位で画面に出力
```

DOMに要素は存在しない。`<canvas>` が1枚あるだけで、その中身はJavaScriptが毎フレーム描き直す。

Three.jsは**WebGL**（GPU命令をブラウザから呼ぶAPI）を使った3D描画ライブラリ。60fpsで大量のポリゴンを描く用途に向いている。

### Canvas方式の特徴

- アニメーション・3D・大量描画が得意
- SEOはできない（HTMLとしてコンテンツが存在しない）
- スクリーンリーダーが読めない
- ブラウザの「テキスト選択」「Ctrl+F検索」が使えない

---

## ③ WebAssembly + Canvas方式 — Flutter Web

### 仕組み

```
Dart で書いた Flutter アプリ
        ↓
Skia（C++の2D描画エンジン）を WebAssembly にコンパイル
        ↓
<canvas> 要素1枚に全 UI を描画
```

Flutter Webのデフォルトレンダラー（**CanvasKit**）は、C++製の描画エンジン「Skia」をWebAssemblyとして動かし、`<canvas>` 1枚に全UIを自前で描く。ブラウザのDOM・CSS・レイアウトエンジンを一切使わない。

### なぜこの方式なのか

Flutter はもともとモバイルアプリ（iOS・Android）向けに設計されており、ネイティブUIウィジェットを使わず**独自の描画エンジンで全UIを描く**思想を持つ。Web版もその思想を引き継いでいる。

これにより、モバイルとWebで**ピクセル単位で完全に同じ見た目**を実現できる。

### Flutter Web の HTMLモード（補足）

Flutter Webには CanvasKit の他に **HTMLレンダラー**もある。こちらはDOMと `<canvas>` を組み合わせて描画するが、セマンティックなHTMLにはならない。パフォーマンスや見た目の一貫性を優先する場合は CanvasKit が使われる。

### Flutter Web の特徴

| 項目 | 状況 |
|------|------|
| SEO | 困難（DOMにコンテンツがない） |
| アクセシビリティ | 制限あり（スクリーンリーダー非対応が基本） |
| テキスト選択・Ctrl+F | 動作しない or 制限あり |
| CSSでのカスタマイズ | できない |
| ピクセル完全一致 | モバイル・Web・デスクトップで同一 |
| 初回ロード | WASMのダウンロードが必要で重い |

---

## 3方式の比較

| | React / Svelte | Three.js | Flutter Web（CanvasKit） |
|--|---------------|----------|--------------------------|
| 描画手段 | DOM + CSS | Canvas（WebGL） | Canvas（WASM + Skia） |
| HTMLの存在 | あり | なし | なし |
| SEO | 対応可 | 困難 | 困難 |
| アクセシビリティ | 対応可 | 困難 | 制限あり |
| CSSの適用 | できる | できない | できない |
| 得意な用途 | Webアプリ・コンテンツ | 3D・ビジュアライゼーション | クロスプラットフォームアプリ |

---

## なぜ描画方式が違うのか

それぞれが**解決したい問題**が異なるから。

- **React・Svelte** → Webのドキュメント・UIを効率よく管理したい
- **Three.js** → 3DグラフィックスをWebで動かしたい
- **Flutter** → 1つのコードベースでモバイル・Web・デスクトップを同じ見た目で動かしたい

Webの標準（DOM・CSS）に乗ることは「ブラウザの資産（SEO・アクセシビリティ・テキスト処理）を使える」ことと引き換えに「ブラウザのレンダリングエンジンに従う」制約を受け入れることでもある。Flutter WebはWeb標準を捨てることで完全な描画の自由を手に入れた、という設計判断といえる。

---

## まとめ

1. DOM方式（React・Svelte）はHTMLとCSSを使い、SEO・アクセシビリティが自然に機能する
2. Canvas方式（Three.js）はピクセル直接描画で3D・高頻度アニメーションが得意
3. Flutter Web（CanvasKit）はWASMでC++の描画エンジンを動かし、DOM・CSSを一切使わない
4. どの方式が「正しい」かではなく、何を作るかによって適切な方式が変わる
