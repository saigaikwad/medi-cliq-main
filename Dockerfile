# Use official Ruby slim image
ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    BUNDLE_DEPLOYMENT=true

# Install system dependencies needed for Rails and gems with native extensions
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libpq-dev \
    nodejs \
    yarn \
    libvips-dev \
    pkg-config \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfiles early for caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy app source
COPY . .

# Precompile bootsnap (optional, can comment if error persists)
RUN bundle exec bootsnap precompile --gemfile

# Precompile assets (provide dummy secret key base)
RUN SECRET_KEY_BASE=dummy ./bin/rails assets:precompile

# Final image
FROM base

# Install runtime dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    libpq5 \
    nodejs \
    yarn \
    libvips42 \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=base /usr/local/bundle /usr/local/bundle
COPY --from=base /rails /rails

RUN useradd -m rails && chown -R rails:rails /rails

USER rails
WORKDIR /rails

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
