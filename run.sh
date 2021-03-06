#!/bin/bash

DISK=sda
PORT=2222
HOST=127.0.0.1

echo DISK="$DISK", PORT="$PORT", HOST="$HOST"

HOST_ROOT="root@$HOST"
PUBKEY=$(cat ~/.ssh/id_rsa.pub)

# copy your public key, so can ssh without a password later on
ssh -tt -p "$PORT" "$HOST_ROOT" "mkdir -m 700 ~/.ssh; echo $PUBKEY > ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys"

# copy install scripts from ./root folder
scp -P "$PORT" ./root/* "$HOST_ROOT:/root"

# run the install script remotely
ssh -tt -p "$PORT" "$HOST_ROOT" "./install.sh $DISK"
