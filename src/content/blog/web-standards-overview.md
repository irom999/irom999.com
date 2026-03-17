---
title: Web標準とは何か — HTML・CSS・JavaScriptを支える仕組み
description: W3C・WHATWG・ECMAScriptなど、Webを動かす標準化団体と主要仕様を整理。なぜWeb標準が重要なのかを解説する。
date: '2026-03-17'
published: true
tags:
  - Web標準
  - HTML
  - CSS
  - JavaScript
  - 入門
---

ブラウザが違っても同じWebサイトが動く。当たり前に見えるこの事実は、**Web標準**があるから成り立っている。

今回はWeb標準の概要と、それを管理する主な標準化団体・仕様を整理する。

---

## Web標準とは

Web標準とは、Webを構成する技術（HTML・CSS・JavaScript・HTTP など）の**仕様書（specification）**のこと。

ブラウザベンダー（Google・Apple・Mozilla・Microsoft など）はこの仕様書をもとにブラウザを実装する。仕様が共通だから、ChromeでもFirefoxでもSafariでも同じHTMLが動く。

標準がなければ、各社が独自仕様を作り、開発者はブラウザごとに別々のコードを書く必要が生じる。1990年代のブラウザ戦争はまさにその状態だった。

---

## 主な標準化団体

### W3C（World Wide Web Consortium）

Webの発明者ティム・バーナーズ＝リーが1994年に設立した標準化団体。CSS・SVG・WebAssemblyなど多くの仕様を管理している。

- サイト: [w3.org](https://www.w3.org)
- 主な仕様: CSS, SVG, WAI-ARIA, WebAssembly, Web Components

### WHATWG（Web Hypertext Application Technology Working Group）

2004年にApple・Mozilla・Operaがw3cに対抗して設立。HTMLの「Living Standard（随時更新される仕様）」を管理している。現在のHTML仕様はWHATWGが主導している。

- サイト: [whatwg.org](https://whatwg.org)
- 主な仕様: HTML, DOM, Fetch, URL, Streams

> W3CとWHATWGは長年並立していたが、2019年に合意し、HTMLの標準はWHATWGが一本管理することになった。

### TC39（ECMA International Technical Committee 39）

JavaScriptの仕様である**ECMAScript**を策定する委員会。Ecma Internationalという標準化団体の下に置かれている。

- サイト: [tc39.es](https://tc39.es)
- 主な仕様: ECMAScript（JavaScript）

提案はStage 0〜4の段階で管理され、Stage 4に到達した機能が正式仕様に採用される。

### IETF（Internet Engineering Task Force）

インターネットプロトコルを管理する団体。WebのベースとなるHTTPやTLSの仕様を策定している。

- 主な仕様: HTTP/1.1, HTTP/2, HTTP/3, TLS, WebSocket

---

## 主要なWeb標準

| 仕様 | 管理団体 | 概要 |
|------|----------|------|
| HTML Living Standard | WHATWG | Webページの構造を記述するマークアップ言語 |
| CSS（各モジュール） | W3C | スタイルとレイアウトを担当 |
| ECMAScript | TC39 / ECMA | JavaScriptの言語仕様 |
| DOM | WHATWG | ドキュメントのオブジェクトモデル |
| Fetch API | WHATWG | ネットワークリクエストのAPI |
| Web Components | W3C | 再利用可能なUIコンポーネントの仕組み |
| WebAssembly | W3C / WHATWG | バイナリ形式の実行仕様 |
| HTTP/2, HTTP/3 | IETF | 通信プロトコル |

---

## 仕様の「ステータス」を読む

W3Cの仕様には進捗を示すステータスがある。

```
ED → WD → CR → PR → REC
```

- **ED（Editor's Draft）** — 編集中の草稿。まだ非公式。
- **WD（Working Draft）** — 作業草案。意見募集中。
- **CR（Candidate Recommendation）** — 勧告候補。実装テスト段階。
- **PR（Proposed Recommendation）** — 勧告案。最終レビュー。
- **REC（Recommendation）** — 勧告。正式な標準。

CRに到達した仕様は比較的安定しており、実装が進んでいることが多い。

---

## ブラウザの対応状況を確認する

仕様が策定されても、すぐに全ブラウザで使えるわけではない。対応状況の確認には以下を使う。

### MDN Web Docs

[developer.mozilla.org](https://developer.mozilla.org) — 各APIの仕様・対応ブラウザ・サンプルコードが揃ったリファレンス。

### Can I Use

[caniuse.com](https://caniuse.com) — CSS・HTML・JavaScriptの機能別ブラウザ対応表。視覚的にわかりやすい。

---

## なぜ標準を意識するか

フレームワーク（React・Svelte・Vueなど）はバージョンアップで破壊的変更が起きる。しかし**Web標準は後方互換性を重視**して設計されており、1990年代のHTMLが今でも動く。

標準APIを理解しておくと：

- フレームワークが変わっても知識が腐らない
- ブラウザの挙動を正確に予測できる
- パフォーマンスやアクセシビリティの改善につながる

SvelteもReactも、最終的にはWeb標準のAPIに変換されて実行される。土台を知ることが、フレームワークの理解も深める。

---

## まとめ

- Web標準は、ブラウザ間の互換性を保つための共通仕様
- HTML → WHATWG、CSS → W3C、JavaScript → TC39、HTTP → IETFがそれぞれ管理
- MDNとCan I Useで対応状況を確認できる
- 標準APIの知識はフレームワーク依存より長持ちする
