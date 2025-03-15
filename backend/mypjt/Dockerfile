FROM ruby:3.3.0
WORKDIR /app
COPY . .
RUN bundle install
EXPOSE 80
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "80"]