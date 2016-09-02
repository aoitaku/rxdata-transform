# rxdata transform

## これは何？
RPG ツクールの .rxdata ファイルを JSON フォーマットのテキストファイルに変換するツールです。出力した JSON ファイルから .rxdata を復元することもできます。

## どうやって使うの？
いまのところ gem になってないので gem でインストールしたりできません。  
適当に `git clone` して `bundle install` して `bundle exec ruby rxdata_converter.rb export DIR` って感じで使ってください。

## 詳しい使い方

### export DIR
Data 配下の .rxdata ファイルを JSON 形式に変換して export 以下に書き出します。  
`DIR` に RPGツクールXP のプロジェクトフォルダを指定してください。

### import DIR
export 配下の .json ファイルを .rxdata に変換して build 以下に書き出します。  
`DIR` に RPGツクールXP のプロジェクトフォルダを指定してください。

## Ruby インストールしなきゃいけないの？
一応スタンダロン化した exe を用意する予定です。

## 黒画面難しそう
がんばって！

## 何に使うの？
RPG ツクールのプロジェクトファイルを git で管理したり差分ツールで差分をチェックしたりマージツールでマージしたりするときに便利らしいです。

## どの辺が便利なの？
JSON へのシリアライズを行うときにソートして出力しているので差分が綺麗に取れると思います。

Scripts.rxdata はセクションごとに個別のファイルに出力します。セクションの順番は別途保存しているので復元するときはその順番で復元されます。  
使い慣れたエディタでスクリプトを編集したいときに便利です。

## rvdata とか rvdata2 とかは？
対応予定です。拡張子みてるとこの処理を .rxdata から .rvdata にするだけとかでいいような気はします。

## 注意点
Data フォルダ以下を直接書き換えたりはしませんが、json から import した .rxdata で置き換えるときは事前にバックアップを取ってください。  
動作確認はしていますが完全な動作を保証するものではありません。

## バグがあった！
お気軽に [Issue](//github.com/aoitaku/rxdata-transform/issues) で報告してくれると助かります。  

## 使いにくいところあったから勝手に直したいんだけど
どんどん直してください。その上で Pull Request 送っていただけると幸いです。

## ライセンス
zlib/libpng です。詳しくは [LICENSE.md](//github.com/aoitaku/rxdata-transform/blob/master/LICENSE.md) みてください。
