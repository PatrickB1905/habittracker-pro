FROM ruby:3.4.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /app
COPY Gemfile* ./
RUN bundle install

COPY . .

# Entrypoint script will run migrations then start the server
EXPOSE 3000
CMD ["./entrypoint.sh"]
