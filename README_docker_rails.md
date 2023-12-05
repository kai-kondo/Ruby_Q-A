# DockerでのRails7環境の構築方法

## 環境

- Ruby: 3.1
- Rails: 7.x
- MySQL: 5.7

## アプリ名の変更

テンプレートとして用意している下記のファイル内の myapp の箇所を任意のアプリ名に変更する。

- docker-compose.yml
- Dockerfile

## ポート番号の変更

ポート番号がの他のDockerコンテナのそれと重複すると動作しないので、重複しない値に変更する。

- docker-compose.yml
- Dockerfile

## コマンドの実行

### Railsアプリの生成

    $ docker-compose run app rails new . --no-deps --force --database=mysql

上記コマンドでrails newが実行されアプリ構築に必要なファイルが生成される。なお、`rails new`コマンドのforceオプションはGemfileを上書きOKとするオプション。

もし、追加のGemが必要であればGemfileにいまのうちに追加しておく。以下、追加例。

```
group :production do
  gem 'unicorn', '5.4.1'
end

gem 'slim-rails'
gem 'html2slim'

gem 'pry-rails'
```

### buildコマンドの実行

```
$ docker-compose build
```

## DB設定

自動生成された config/database.yml のパスワードを設定し、DBのホストをdb（docker-compose.ymlで指定している値）に変更する。

```
$ vi config/database.yml
# MySQL. Versions 5.1.10 and up are supported.
#
# Install the MySQL driver
#   gem install mysql2
#
# Ensure the MySQL gem is defined in your Gemfile
#   gem 'mysql2'
#
# And be sure to use new-style password hashing:
#   https://dev.mysql.com/doc/refman/5.7/en/password-hashing.html
#
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: passw0rd
  host: db
  ...
```

## コンテナの起動とDBの作成

```
$ docker-compose up -d
$ docker-compose exec app rails db:create
```

## Bootstrapの導入方法

### JS関連の設定

#### 1. Bootstrap用のJSを読み込む

appコンテナ内で以下のコマンドを実行する。

```
$ docker-compose exec app bash
> bin/importmap pin bootstrap
```

上記を実行すると、`config/importmap.rb`に以下の2行が追加される。

```
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.2.3/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/lib/index.js"

```

ただし、ga.jspm.ioからのPopperが動作しないので、以下のようにunpkg.comからロードするように書き換える。（[参考リンク](https://blog.eq8.eu/til/how-to-use-bootstrap-5-in-rails-7.html)）

```
pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2.11.2/dist/esm/index.js"
```

### 2. application.jsにエントリーを追加

`app/javascript/application.js` に下記の記述を追加する

```
import "bootstrap"
```

### CSS関連の設定

#### 1. GemfileでのBootstrapの追加

Gemfileに以下の記述を追加する

```
gem 'bootstrap', '~> 5.1.3'
```

その後、`bundle install`を実行

#### 2. SCSSファイルの編集

`app/assets/stylesheets/application.css` を `application.scss` に変更し以下の記述を追加する。
なお、2行目はBootstrapアイコンを利用できるようにするもの。

```
@import "bootstrap";
@import url("https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css");
```

参考リンク

- [Simple way how to use Bootstrap 5 in Rails 7 \- importmaps & sprockets](https://blog.eq8.eu/til/how-to-use-bootstrap-5-in-rails-7.html)


## Bootstrapの導入（誤った手順）

以下の方法で導入すると、importmapsとcssbuilding-railsが競合するのか、Stimulusが正常に動作しないという問題があるので、この手順は実行しないほうがよい。

### 1. Gemfileに以下を追加する。

```
gem 'cssbundling-rails'
```

### 2. Bundleの実行とBootstrapの導入

```
$ docker-compose exec app bash
# bundle install
# rails css:install:bootstrap
```

### 3. package.jsonにエントリーを追加

```
sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules
```

追加後のファイルは以下のようになる。

```
{
  "name": "app",
  "private": "true",
  "dependencies": {
    "@popperjs/core": "^2.11.6",
    "bootstrap": "^5.2.3",
    "bootstrap-icons": "^1.10.3",
    "sass": "^1.57.1"
  },
  "scripts": {
    "build:css": "sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules"
  }
}
```

### 4. scssのコンパイル

```
# yarn build:css
```