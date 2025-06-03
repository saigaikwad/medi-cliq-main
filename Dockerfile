# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and for asset compilation
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config nodejs yarn && \
    rm -rf /var/lib/apt/lists/*

# Copy gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Accept SECRET_KEY_BASE as build argument
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompile Rails assets
RUN bundle exec rails assets:precompile

# Final stage for app image
FROM base

# Install runtime packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 libvips && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy gems and app from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create a non-root user and set ownership for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port 3000 and start the Rails server by default
EXPOSE 3000
CMD ["./bin/rails", "server"]
