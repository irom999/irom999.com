---
title: TypeScript・Svelte・Reactの根本的な違い
description: TypeScript・Svelte・Reactそれぞれの役割・種類・関係性を整理して解説。
date: '2026-03-17'
published: true
tags:
  - TypeScript
  - Svelte
  - React
  - 入門
---

# TypeScript・Svelte・Reactの根本的な違い

---

## 一言で言うと

| | 種類 | 一言 |
|---|---|---|
| **TypeScript** | 言語 | JavaScriptに型を追加したもの |
| **React** | JavaScriptライブラリ | UIを作る部品集 |
| **Svelte** | コンパイラ | `.svelte`ファイルをJSに変換するツール |

---

## TypeScriptとは

JavaScriptに**型**を追加した言語。MicrosoftがJavaScriptの弱点を補うために作った。

```ts
// JavaScript（型なし）
function add(a, b) {
  return a + b
}
add("5", 3)  // → "53"（文字列結合。バグだが実行されてしまう）

// TypeScript（型あり）
function add(a: number, b: number): number {
  return a + b
}
add("5", 3)  // → エディタが即座にエラー表示
```

### TypeScriptとJavaScriptの関係

```
TypeScript ⊃ JavaScript
（TypeScriptはJavaScriptの上位互換）

JavaScriptのコードはそのままTypeScriptとして動く
TypeScriptはブラウザでは動かない → コンパイルしてJSに変換が必要
```

### エラーを検知するタイミング

```
JavaScript:
  コードを書く → ブラウザで実行 → エラー発生
                                    ↑ここまで気づけない

TypeScript:
  コードを書く → エディタが即エラー表示
                  ↑コードを書いている瞬間に気づける
```

---

## Reactとは

UIを作るための**JavaScriptライブラリ**。Facebookが開発。

```
種類：ライブラリ
  → コードの中でimportして使う
  → npm install react が必要
  → ブラウザにReact本体のJSが届く（ランタイムが必要）
```

```jsx
// Reactのコンポーネント
import { useState } from 'react'

function Counter() {
  const [count, setCount] = useState(0)  // ← ReactのAPIを使う

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  )
}
```

### Reactの仕組み

```
あなたのコード ＋ Reactライブラリ
        ↓
ブラウザに届く
        ↓
Reactのランタイムが仮想DOMを計算
        ↓
変更箇所だけ実際のDOMを更新
```

---

## Svelteとは

`.svelte`ファイルを**普通のJavaScriptに変換するコンパイラ**。

```
種類：コンパイラ
  → ビルド時にJSに変換される
  → ブラウザにSvelte本体は届かない（ランタイム不要）
  → 軽くて速い
```

```svelte
<!-- Svelteのコンポーネント -->
<script>
  let count = 0  // ← 普通の変数だけでOK
</script>

<p>{count}</p>
<button onclick={() => count++}>+1</button>
```

### Svelteの仕組み

```
.svelteファイル
        ↓ ビルド時にSvelteコンパイラが変換
普通のJavaScript
        ↓
ブラウザに届く（Svelteのコードは含まれない）
        ↓
ピュアなJSが直接DOMを更新
```

---

## 3つの比較

### カウンターを書いた場合

```ts
// TypeScript（UIは作れない。ロジックだけ）
let count: number = 0
function increment(): void {
  count++
}
```

```jsx
// React（TypeScriptと組み合わせて使うことが多い）
function Counter() {
  const [count, setCount] = useState<number>(0)
  return <button onClick={() => setCount(count + 1)}>{count}</button>
}
```

```svelte
<!-- Svelte（TypeScriptと組み合わせて使うことが多い） -->
<script lang="ts">
  let count: number = 0
</script>
<button onclick={() => count++}>{count}</button>
```

---

## 関係性の整理

```
TypeScript  ──────────────────────────────────
                ↑                    ↑
            Reactで使う          Svelteで使う
            (<script lang="ts">不要) (<script lang="ts">)
```

TypeScriptはReactにもSvelteにも組み合わせて使える。**言語とライブラリ/コンパイラは別の概念**。

---

## フレームワークとの関係

| 単体 | フレームワーク |
|---|---|
| React | Next.js（React ＋ ルーティング等） |
| Svelte | SvelteKit（Svelte ＋ ルーティング等） |

TypeScriptはどちらのフレームワークでも使える。

---

## まとめ

```
TypeScript → 言語。型でバグを防ぐ。単体でUIは作れない。
React     → ライブラリ。UIを作る。ブラウザにReact本体が届く。
Svelte    → コンパイラ。UIを作る。ブラウザにSvelteは届かない。

TypeScript ＋ React    → ReactでUIを書きながら型の恩恵を受ける
TypeScript ＋ Svelte   → SvelteでUIを書きながら型の恩恵を受ける
                          （このリポジトリのやり方）
```
