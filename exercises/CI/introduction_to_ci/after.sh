#!/usr/bin/env bash
ssh-agent bash -c 'ssh-add ../git-server/keys/id_rsa; git clone ssh://git@localhost:3333/git-server/repos/myrepo.git'
git config --local --add core.sshCommand 'ssh -i ../../git-server/keys/id_rsa'
# break file so that they can commit and see the mistake?