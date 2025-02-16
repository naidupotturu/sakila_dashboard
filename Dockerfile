# Use official Ruby image as the base for build stage
ARG RUBY_VERSION=3.3.0
FROM ruby:$RUBY_VERSION-slim as base

# Set working directory
WORKDIR /app

# Install required dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git libvips pkg-config nodejs npm && \
    npm install -g yarn

# Copy Gemfile and Gemfile.lock and install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Install JavaScript dependencies
RUN yarn install

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE=de7d99c3911e60188f27cc213b5cf19d3a9146703dc8b2940ef60c9639f271aa2db139318c04aafcbab74b8d8aa89910f9e4069f7521bbf31541764493e19160 bundle exec rails assets:precompile

# Final image to deploy app
FROM ruby:$RUBY_VERSION-slim

# Set working directory
WORKDIR /app

# Install necessary runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 libvips

# Copy built gems, assets, and application code
COPY --from=base /usr/local/bundle /usr/local/bundle
COPY --from=base /app /app

# Set up a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

# Entrypoint for database setup
ENTRYPOINT ["/app/bin/docker-entrypoint"]

# Expose the port and start the Rails server
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
