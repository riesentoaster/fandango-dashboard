FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bundler \
    tzdata \
    nodejs \
    npm

RUN gem install bundler

WORKDIR /app

COPY Gemfile /app/

RUN bundle

# Table widget
RUN smashing install 9c7cb3030f63ad10e517

COPY . /app/

# Environment variables for GitHub Issues job (optional):
# GITHUB_TOKEN - GitHub personal access token
# GITHUB_OWNER - GitHub repository owner
# GITHUB_PROJECT - GitHub repository name
# GITHUB_SINCE - Date to fetch issues since (e.g., "2024-01-01")

CMD ["smashing", "start"]