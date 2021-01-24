ARG VARIANT=latest
FROM elixir:${VARIANT}

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    apt-get install -y ripgrep && \
    apt-get install -y git && \
    apt-get install -y man && \
    apt-get install -y less && \
    apt-get install -y vim && \
    apt-get install -y python3 && \
    apt-get install -y python3-pip && \
    curl -sL https://deb.nodesource.com/setup_15.x | bash && \
    apt-get install -y nodejs && \
    curl -L https://npmjs.org/install.sh | sh && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update && apt-get install yarn -y && \
    mix local.hex --force && \
    mix archive.install hex phx_new ${PHX_VERSION} --force && \
    mix local.rebar --force && \
    pip3 install gigalixir --user

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

EXPOSE 4000
EXPOSE 4004
