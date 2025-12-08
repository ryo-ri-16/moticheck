# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.8
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libjemalloc2 libvips postgresql-client \
    build-essential git libpq-dev libyaml-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# === build stage ===
FROM base AS build

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4

COPY . .

COPY config/master.key.build /rails/config/master.key

RUN SECRET_KEY_BASE=1 \
    RAILS_MASTER_KEY=$(cat /rails/config/master.key) \
    ./bin/rails assets:precompile

# === final stage ===
FROM base AS final

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 80
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
