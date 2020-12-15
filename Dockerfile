FROM ubuntu:20.04

ENV SALT_VERSION=3002.2 
ENV DEBIAN_FRONTEND=noninteractive

RUN set -x \
### Install basic tools
  && apt-get update \
  && apt-get install --no-install-recommends --yes gnupg2 bash curl unzip git-core jq openssh-client python3-pip \
### Install salt
  && curl -L https://repo.saltstack.com/py3/ubuntu/20.04/amd64/archive/${SALT_VERSION}/SALTSTACK-GPG-KEY.pub | apt-key add - \
  && echo "deb https://repo.saltstack.com/py3/ubuntu/20.04/amd64/archive/${SALT_VERSION} focal main" > /etc/apt/sources.list.d/saltstack.list \
  && apt-get update \
  && apt-get install --no-install-recommends --yes salt-common \
### Install addons :: salt-lint
  && pip3 install --no-cache-dir salt-lint \
### Install custom rules
  && mkdir -p /usr/local/lib/python3.8/dist-packages/saltlint/custom \
  && cd /usr/local/lib/python3.8/dist-packages/saltlint/custom \
#  && curl -LO https://raw.githubusercontent.com/dawidmalina/salt-lint/comments/saltlint/rules/CommentHasSpaceRule.py \
  && curl -LO https://raw.githubusercontent.com/dawidmalina/salt-lint/empty_line/saltlint/rules/NoTwoEmptyLinesRule.py \
  && curl -LO https://raw.githubusercontent.com/dawidmalina/salt-lint/hyphen/saltlint/rules/HyphenHasSpaceRule.py \
  && curl -LO https://raw.githubusercontent.com/dawidmalina/salt-lint/colon/saltlint/rules/ColonFormatRule.py \
  && curl -LO https://raw.githubusercontent.com/dawidmalina/salt-lint/indent/saltlint/rules/NotEvenIndentationRule.py \
#  && curl -LO https://raw.githubusercontent.com/dawidmalina/salt-lint/sls/saltlint/rules/StateCanBeRendered.py \
### Cleanup
  && apt-get purge --yes unzip python3-pip \
  && apt-get install --no-install-recommends --yes python3-minimal \
  && apt-get clean autoclean \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/
