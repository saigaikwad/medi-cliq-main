# Base image
FROM ruby:3.3

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  curl

# Install bundler
RUN gem install bundler

# Copy Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Expose port (adjust if needed)
EXPOSE 3000

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]
