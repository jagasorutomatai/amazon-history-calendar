# amazon-history-calendar
![google_calendar_api_0](https://user-images.githubusercontent.com/62248603/90950890-ca610180-e490-11ea-9011-0c5da38a65ed.PNG)

## 概要
Amazonの購入履歴をGoogleカレンダーに反映します
Ruby 2.7.1

## 前準備

### 各種アカウントの準備
- Amazonアカウント
- Googleアカウント

### Google Calendar APIを利用できるようにする
Google Developer ConsoleでGoogle Calendar APIを利用できるようにする。
認証情報にはOAuth 2.0 クライアント IDを使用する。
この時、認証情報のjsonファイルをダウンロードしておく。例) client_secret_******.json
https://console.developers.google.com/

### Google拡張機能のインストール(アマゾン注文履歴フィルタ)
chromeウェブストアでアマゾン注文履歴フィルタをインストールする
https://chrome.google.com/webstore/detail/%E3%82%A2%E3%83%9E%E3%82%BE%E3%83%B3%E6%B3%A8%E6%96%87%E5%B1%A5%E6%AD%B4%E3%83%95%E3%82%A3%E3%83%AB%E3%82%BF/jaikhcpoplnhinlglnkmihfdlbamhgig?hl=ja

## 使い方
### リポジトリのクローンとgemのインストール
```
$ git clone https://github.com/jagasorutomatai/amazon-history-calendar.git
$ cd amazon-history-calendar
$ bundle install --path vendor/bundle
```

### Googleカレンダーに反映するAmazon購入履歴をダウンロードする
Amazonのアカウントサービスにある注文履歴に進み、CSVファイルをダウンロードする。


領収書印刷用画面ボタンをクリックすると、領収書印刷画面に遷移する。
![google_calendar_api_02](https://user-images.githubusercontent.com/62248603/90958341-d53a8700-e4ce-11ea-9767-1e8c5537c01b.PNG)


注文履歴CSV(参考用)ダウンロードのボタンがあるのでダウンロードする。
![google_calendar_api_03](https://user-images.githubusercontent.com/62248603/90958353-e5eafd00-e4ce-11ea-9e11-3dc240651312.PNG)


ダウンロードしたデータはamazon-history-calendar/app/data配下に配置する。
またファイル名は以下のようにする。
- デジタルの場合: amazon-order_digital.csv
- デジタル以外の場合: amazon-order_non-digital.csv

### 認証情報を配置する
Google Developer Consoleでダウンロードした認証情報のjsonファイル(client_secret_******.json)を
amazon-history-calendar/app/config配下に配置する。
またファイル名は以下のようにする。
- client_secret.json

### プログラムを実行する
```
// 初回のみこの操作が必要。OAuth2.0同意画面でリクエストを許可する。
// 許可後に表示される文字列をコンソールに入力する
$ ruby amazon_history_calendar.rb
OAuth2.0同意画面(*******) の承認結果を入力してください: 
イベントを追加しました: https://www.google.com/calendar/****************************
イベントを追加しました: https://www.google.com/calendar/****************************
イベントを追加しました: https://www.google.com/calendar/****************************
・
・
・
・
イベントを追加しました: https://www.google.com/calendar/****************************
```

## 参考情報
https://qiita.com/ts-3156/items/1f84d06e50795a9df4c8
