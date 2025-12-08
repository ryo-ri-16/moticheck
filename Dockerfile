# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.8
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# 必要なライブラリ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# 環境変数
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# Gem インストール
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4

# アプリコピー
COPY . .

# assets:precompile 用に RAILS_MASTER_KEY を必要に応じてセット
# 本番ビルドでは Render が RAILS_MASTER_KEY を渡してくれるのでビルド時に dummy で対応することも可能
ARG SECRET_KEY_BASE_DUMMY=1
RUN SECRET_KEY_BASE=$SECRET_KEY_BASE_DUMMY RAILS_MASTER_KEY=$RAILS_MASTER_KEY ./bin/rails assets:precompile

# 最終イメージ
FROM base

COPY --from=base /usr/local/bundle /usr/local/bundle
COPY --from=base /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 80
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
