---
title: SvelteとReactを比較して学ぶ — 基礎編
description: コンパイラとライブラリの違い、Component・Props・Stateを比較しながら解説。
date: '2026-03-17'
published: true
tags:
  - Svelte
  - React
  - 入門
---

# SvelteとReactを比較して学ぶ — 基礎編

SvelteとReactをゼロから比較しながら学んだ記録です。

---

## SvelteとReactの根本的な違い

| | React | Svelte |
|---|---|---|
| 種類 | **JavaScriptライブラリ** | **コンパイラ** |
| UI更新 | 仮想DOM（Virtual DOM） | コンパイル時に最適なJSを生成 |
| ブラウザに届くもの | ReactランタイムJS + あなたのコード | 変換済みのピュアJS |

### Reactはライブラリ

ブラウザに届くJSの中にReact自身のコードが含まれます。ブラウザ上でReactのランタイムが動き、仮想DOMを計算してUIを更新します。

### Svelteはコンパイラ

`npm run build`のとき、Svelteが`.svelte`ファイルを**普通のJavaScriptに翻訳**します。ブラウザにはSvelteのコードは届かず、軽いピュアJSだけが届きます。これがSvelteの高速な理由です。

---

## フレームワークの整理

| | 説明 |
|---|---|
| React | UIを作るライブラリ（ルーティングなし） |
| React Router | ReactにURLとページの対応を追加するライブラリ |
| **Next.js** | React + ルーティング + その他をまとめたフレームワーク |
| **SvelteKit** | Svelte + ルーティング + その他をまとめたフレームワーク |

Next.jsとSvelteKitは同じ立ち位置です。どちらも「ファイルの場所＝URL」になるファイルベースルーティングを持っています。

---

## Component（コンポーネント）

UIを部品として分割する仕組みです。

```
+page.svelte（親）
├── <Profile />（子）
└── <Social />（子）
```

**親子関係はフォルダ構成ではなく、importで決まります。** 使う側が親、importされる側が子です。

---

## Props（プロパティ）

**親コンポーネントから子コンポーネントへデータを渡す仕組み**です。

### Svelte

```svelte
<!-- 子: Greeting.svelte -->
<script>
  let { name } = $props()
</script>
<p>こんにちは、{name}さん！</p>

<!-- 親 -->
<Greeting name="irom999" />
```

### React

```jsx
// 子: Greeting.jsx
function Greeting({ name }) {
  return <p>こんにちは、{name}さん！</p>
}

// 親
<Greeting name="irom999" />
```

渡す側（親）の書き方はSvelteもReactも同じです。違いは受け取る側だけです。

---

## State（状態）

**コンポーネント自身が持つ、時間とともに変わるデータ**です。

| | Props | State |
|---|---|---|
| 出所 | 親から渡される | 自分が持つ |
| 変更 | 子は変更できない | 自分で変更できる |

### Svelte — `let`だけでOK

```svelte
<script>
  let count = 0
</script>

<p>{count}</p>
<button onclick={() => count++}>+1</button>
```

Svelteはコンパイラが変数への代入を検知して自動で再描画します。

### React — `useState`が必要

```jsx
import { useState } from 'react'

function Counter() {
  const [count, setCount] = useState(0)

  return (
    <>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </>
  )
}
```

Reactは`setCount()`を呼ぶことで「再描画して」とReactに伝える必要があります。`count`を直接書き換えてもUIは更新されません。

---

## StateとPropsの組み合わせ

Stateは親が持ち、子にPropsとして渡すのが基本パターンです。

### Svelte

```svelte
<!-- 子: Counter.svelte -->
<script>
  let { count, onIncrement } = $props()
</script>
<p>{count}</p>
<button onclick={onIncrement}>+1</button>

<!-- 親 -->
<script>
  import Counter from './Counter.svelte'
  let count = 0
</script>
<Counter count={count} onIncrement={() => count++} />
```

### React

```jsx
// 子
function Counter({ count, onIncrement }) {
  return (
    <>
      <p>{count}</p>
      <button onClick={onIncrement}>+1</button>
    </>
  )
}

// 親
function App() {
  const [count, setCount] = useState(0)
  return <Counter count={count} onIncrement={() => setCount(count + 1)} />
}
```

子コンポーネントは「表示と操作だけ」に集中し、データ管理は親に任せます。これにより子コンポーネントをどこでも再利用できます。

---

## まとめ

- **Svelte**：コンパイラ。`let`だけでState管理でき、記述量が少ない
- **React**：ライブラリ。`useState`などのルールを覚える必要があるが、エコシステムが大きい
- **Props**：親 → 子へのデータの渡し方（渡す側の構文は同じ）
- **State**：コンポーネント自身が管理するデータ
