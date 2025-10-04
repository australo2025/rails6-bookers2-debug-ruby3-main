# Bookers2 Debug

## 概要
このアプリは「読んだ本の感想の共有」を実現する学習用 Rails アプリです。主要機能は「本の投稿」「いいね」「コメント」「フォロー」「タグ検索」など。

## 動作環境
- Ruby 3.1.2 / Rails 6.1.x
- SQLite3（開発） / Node.js + Yarn（Webpacker）
- OS: Ubuntu / macOS いずれも可

## セットアップ（Quick Start）
```bash
git clone https://github.com/australo2025/rails6-bookers2-debug-ruby3-main.git
cd rails6-bookers2-debug-ruby3-main
bundle install
yarn install --check-files
bin/rails db:prepare
bin/rails s