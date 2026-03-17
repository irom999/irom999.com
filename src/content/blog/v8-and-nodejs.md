---
title: V8エンジンとNode.jsの関係
description: ChromeのJSエンジンV8とNode.jsの関係性、それぞれの役割、Cloudflare Workersとの違いを解説。
date: '2026-03-17'
published: true
tags:
  - JavaScript
  - Node.js
  - 入門
---

# V8エンジンとNode.jsの関係

---

## そもそもJavaScriptはどこで動くか

JavaScriptはそのままではCPUが理解できない。**実行環境（エンジン）** が必要。

```
JavaScript コード
      ↓
  V8エンジン（翻訳・実行）
      ↓
  CPUが処理
```

---

## V8エンジンとは

GoogleがChromeのために開発したJavaScript実行エンジン。

```
担当すること:
  - JavaScriptのコードを読む
  - 機械語に変換する
  - 実行する
  - メモリ管理（不要なデータを自動で削除）

担当しないこと:
  - ファイルの読み書き
  - ネットワーク通信
  - OSとのやり取り
```

V8は「JavaScriptを実行するエンジン」に専念しており、ファイル操作などの機能は持っていない。

---

## Node.jsとは

**V8エンジンを取り出してサーバー上で動かせるようにしたもの。**

```
Chrome:
  V8エンジン ＋ ブラウザのAPI（DOM・fetch・sessionStorageなど）

Node.js:
  V8エンジン ＋ サーバー用API（fs・path・httpなど）
```

Ryan Dahlという人が2009年に「ChromeからV8だけ取り出してサーバーで動かしたら面白いのでは」と作ったのがNode.jsの始まり。

---

## 車に例えると

```
V8エンジン → 車のエンジン本体（走る力を生み出す）

Chrome     → エンジン ＋ 車体（ブラウザとして使える）
Node.js    → エンジン ＋ トラックの荷台（サーバーとして使える）
```

同じエンジンを積んでいるが、用途が違う。

---

## できることの違い

```
ブラウザ（Chrome）のJavaScript:
  document.querySelector()  ← OK（DOMを操作できる）
  fetch()                   ← OK
  sessionStorage            ← OK
  fs.readFileSync()         ← NG（ファイルを読めない）

Node.js:
  fs.readFileSync()         ← OK（ファイルを読める）
  path.resolve()            ← OK
  http.createServer()       ← OK（サーバーを立てられる）
  document.querySelector()  ← NG（DOMがない）
  sessionStorage            ← NG
```

ブラウザはセキュリティ上、ファイルシステムにアクセスできない。Node.jsはブラウザの外で動くので制限がない。

---

## Cloudflare WorkersはNode.jsではない

WorkersもV8エンジンを使っているが、Node.jsとは別の実行環境。

| | Node.js | Cloudflare Workers |
|---|---|---|
| ベース | V8エンジン | V8エンジン |
| 動く場所 | サーバー（1箇所） | 世界200箇所以上のエッジ |
| `fs`（ファイル操作） | 使える | 使えない |
| `fetch` | 使える | 使える（Web標準） |

Workersは世界中のデータセンターで動くため、ファイルシステムを持てない。代わりにCloudflare独自のストレージ（KV・R2）を使う。

---

## このリポジトリとの関係

```
開発中（npm run dev）:
  Node.jsが+page.server.tsを実行
  → fs.readFileSync()でMarkdownを読む（Node.jsのAPIを使っている）

ビルド時（npm run build）:
  Node.jsが全ページのHTMLを生成して終了

本番（Cloudflare Pages）:
  完成HTMLをそのまま配信
  → Node.jsもWorkersも不要
```

`prerender = true`にしているのは、Workersの制約（`fs`が使えない）を避けるためでもある。

---

## まとめ

```
V8エンジン → JSを実行するエンジン本体
Chrome     → V8 ＋ ブラウザAPI
Node.js    → V8 ＋ サーバーAPI（fsなど）
Workers    → V8 ＋ Web標準API（Cloudflare独自環境）

全部V8を使っているが、使えるAPIが違う
```
