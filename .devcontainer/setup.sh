apt-get update


apt-get install -y \
  postgresql-client \
  inotify-tools \
  nodejs \
  curl \
  git \
  gnupg2 \
  jq \
  sudo \


curl -L https://npmjs.org/install.sh | sh && \

# set-up and install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn -y


mix local.hex --force && \
mix archive.install hex phx_new ${PHX_VERSION} --force && \
mix local.rebar --force

