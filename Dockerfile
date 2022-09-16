FROM ruby:2.2.3
RUN apt-get update && apt-get -yq install build-essential git wget libpq-dev nodejs imagemagick

ARG BUNDLER_VERSION=1.17.3
ENV BUNDLER_VERSION=${BUNDLER_VERSION}
RUN gem install bundler -v ${BUNDLER_VERSION} --no-document 

RUN mkdir /ors
WORKDIR /ors

ADD Gemfile /ors/Gemfile
ADD Gemfile.lock /ors/Gemfile.lock
RUN bundle install

ADD . /ors

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
