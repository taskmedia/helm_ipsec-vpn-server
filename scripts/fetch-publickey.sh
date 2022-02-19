#!/bin/bash

controllername="sealed-secrets"
controllernamespace="sealed-secrets"

kubeseal \
  --fetch-cert \
  --controller-name $controllername \
  --controller-namespace $controllernamespace \
  > sealed-secrets.pem
