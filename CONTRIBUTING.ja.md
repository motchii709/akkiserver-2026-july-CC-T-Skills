# 寄稿ガイド（日本語版）

Issue も PR も歓迎します。初めての方でも気軽にどうぞ。
English version: [CONTRIBUTING.md](CONTRIBUTING.md).

## 歓迎する寄稿

- **間違いの指摘**: 型名・メソッド名・引数形が動かない、公式ドキュメントと異なる
- **多モデル検証の報告**: 試したモデル名・使った場面・結果（動いた/動かない例つき歓迎）
- **不足の補完**: 未記載のペリフェラル・イベント名・Lua 例
- **言葉の改善**: 分かりにくい表現・誤字脱字（日本語・英語とも）

## やり方

1. まず Issue を立てるか、直接 PR を送る（どちらでも可。迷ったら Issue から）。
2. PR の場合: `skills/cc-tweaked-addons/` 以下を編集し、何をどう裏付けたか（javap /
   config / 公式ドキュメント URL / ゲーム内実測）を PR 本文に書く。
3. 推測で書かない。裏付けのない記述は `unconfirmed` と明記する。

## 記述ルール

- 型文字列・メソッド名は同梱 jar の javap 実測値を正とします。公式ドキュメントと
  異なる場合は両方を記載し、どちらを優先すべきか明記してください。
- スキル本体・references は英語で書きます。日本語での質問・Issue・PR は歓迎します。
- バージョンを書く。新規 Mod / 新バージョン対応の PR は jar 内バージョン
  （`META-INF/neoforge.mods.toml` の `version`）を添えてください。
- ゲーム内に置く前提のコードには認証情報・秘密のトークン類を書かないでください
  （APIキー・個人トークンは PC 側やエージェント側で管理し、ゲーム内には置かない）。
- 同梱の `types/class_set.d.lua` は © manmen2414（MIT）です。変更した場合は PR で
  明記し、[提供元リポジトリ](https://github.com/manmen2414/AKKI-Server-MameeennArea)
  への upstream も検討してください。

## ライセンス

寄稿は MIT（[LICENSE](LICENSE)）の下で取り扱います。
