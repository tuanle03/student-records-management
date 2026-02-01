ARG RUBY_VERSION=3.4.7
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && apt-get install -y \
  build-essential libpq-dev git curl nodejs yarn \
  && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT=development:test

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 4

COPY . .

RUN bundle exec bootsnap precompile app/ lib/ \
 && SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle","exec","puma","-C","config/puma.rb"]
