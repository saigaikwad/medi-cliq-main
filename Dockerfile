# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

FROM base as build

# Install system dependencies for building gems and assets
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    git \
    nodejs \
    yarn \
    libsqlite3-dev \
    libvips \
    pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock early for caching
COPY Gemfile Gemfile.lock ./

# Install gems with retry and parallel jobs
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Only run bootsnap precompile if bootsnap is present in Gemfile.lock
RUN if grep -q bootsnap Gemfile.lock; then bundle exec bootsnap precompile --gemfile; fi

# Copy application code
COPY . .

# Precompile bootsnap cache for app/ and lib/
RUN bundle exec bootsnap precompile app/ lib/

# Precompile Rails assets with dummy secret key (can be overridden in Railway environment)
RUN SECRET_KEY_BASE=${SECRET_KEY_BASE:-dummy} ./bin/rails assets:precompile

FROM base

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    curl \
    libsqlite3-0 \
    libvips \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

EXPOSE 3000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
