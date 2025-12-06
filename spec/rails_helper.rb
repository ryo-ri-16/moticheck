require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# テストデータベースのマイグレーション状態を確認
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # FactoryBotのメソッドを使いやすくする
  config.include FactoryBot::Syntax::Methods
  # トランザクションを使ってテスト後にデータをクリーンアップ
  config.use_transactional_fixtures = true
  # テストの実行順序をランダムにする
  config.order = :random
  # 型推論を有効にする
  config.infer_spec_type_from_file_location!
  # Railsのヘルパーをフィルタリング
  config.filter_rails_from_backtrace!
end
