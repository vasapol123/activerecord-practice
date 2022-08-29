FROM ruby:3.1.2-slim

RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-dev

WORKDIR /usr/src/app

COPY Gemfile* ./

RUN gem install bundler && bundle install

COPY ./ ./

CMD ["bundle", "exec", "guard", "start", "--force-polling"]
