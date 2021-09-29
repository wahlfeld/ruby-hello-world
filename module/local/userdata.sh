#!/usr/bin/env bash
set -e

bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait

curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s stable
# shellcheck disable=SC1091
source /etc/profile.d/rvm.sh
rvm install 2.5.1

# shellcheck disable=SC2154
# shellcheck disable=SC2086
aws s3 cp --recursive s3://${bucket}/ /

bundle install
bundle exec rackup -p 3000 --host 0.0.0.0
