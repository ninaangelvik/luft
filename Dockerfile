# This Dockerfile for a Ruby application was generated by gcloud.

# The base Dockerfile installs:
# * A number of packages needed by the Ruby runtime and by gems
#   commonly used in Ruby web apps (such as libsqlite3)
# * A recent version of NodeJS
# * A recent version of the standard Ruby runtime to use by default
# * The bundler gem
FROM gcr.io/google-appengine/ruby:latest

# If your application requires a specific ruby version (compatible with rbenv),
# set it here. Leave blank to use the currently recommended default.
ARG REQUESTED_RUBY_VERSION="2.4.1"
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install any requested ruby if not already preinstalled by the base image.
# Tries installing a prebuilt package first, then falls back to a source build.
RUN if test -n "$REQUESTED_RUBY_VERSION" -a \
        ! -x /rbenv/versions/$REQUESTED_RUBY_VERSION/bin/ruby; then \
      (apt-get update -y \
        && apt-get install -y -q gcp-ruby-$REQUESTED_RUBY_VERSION) \
      || (cd /rbenv/plugins/ruby-build \
        && git pull \
        && rbenv install -s $REQUESTED_RUBY_VERSION) \
      && rbenv global $REQUESTED_RUBY_VERSION \
      && gem install -q --no-rdoc --no-ri bundler --version $BUNDLER_VERSION \
      && gem install -q --no-rdoc --no-ri foreman --version 0.64.0 \

      && DEBIAN_FRONTEND=noninteractive && apt-get clean \
      && rm -f /var/lib/apt/lists/*_*; \
    fi
ENV RBENV_VERSION=${REQUESTED_RUBY_VERSION:-$RBENV_VERSION}

# Copy the application files.
COPY . /app/

# Install required gems if Gemfile.lock is present.
RUN if test -f Gemfile.lock; then \
      bundle install --deployment --without="development test" \
      && rbenv rehash; \
    fi

# Temporary. Will be moved to base image later.
ENV RACK_ENV=production \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

# Run asset pipeline if we're in a Rails app.
RUN if test -d app/assets -a -f config/application.rb; then \
      bundle exec rake assets:precompile || true; \
    fi

# BUG: Reset entrypoint to override base image.
ENTRYPOINT []

# Start application on port $PORT.
CMD exec bundle exec foreman start --formation "$FORMATION" -f Procfile 
