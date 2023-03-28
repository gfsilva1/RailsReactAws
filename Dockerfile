FROM ruby:3.1.2-alpine as base
ARG RAILS_ENV

ENV BUILD_PACKAGES="linux-headers tzdata build-base libffi-dev bash postgresql-dev curl less gcompat nodejs npm git"
RUN apk --update --upgrade add $BUILD_PACKAGES && rm /var/cache/apk/*

FROM base as step

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app

ENV BUNDLER_VERSION=2.4.8
ARG BUNDLE_WITHOUT
RUN gem install bundler:${BUNDLER_VERSION} && bundle _${BUNDLER_VERSION}_ install --jobs=4
COPY . /app

FROM step as app

EXPOSE 3002
