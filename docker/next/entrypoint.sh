#!/bin/sh

if [ "$NODE_ENV" = "development" ]
  echo "node_modules not found, running npm install..."
  npm install
fi

exec "$@"
