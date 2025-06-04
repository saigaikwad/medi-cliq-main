# syntax=docker/dockerfile:1

# --- Base image with Ruby ---
ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=true \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# --- Build stage ---
FROM base as build

# Install dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  build-essential \
  libvips \
  git \
  nodejs \
  yarn \
  pkg-config

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy all app code
COPY . .

# Precompile bootsnap and assets
RUN bundle exec bootsnap precompile --gemfile
RUN SECRET_KEY_BASE=dummy ./bin/rails assets:precompile

# --- Final production image ---
FROM base

# Only required runtime packages
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  curl \
  libsqlite3-0 \
  libvips \
  nodejs \
  yarn && \
  rm -rf /var/lib/apt/lists/*

# Copy installed gems and compiled app from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create non-root user and set permissions
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER rails

# Entry point
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Run server by default
EXPOSE 3000
CMD ["./bin/rails", "server"]
