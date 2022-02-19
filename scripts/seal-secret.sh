#!/bin/bash

secretname="vpn-vpnconfig"
namespace="vpn"
secret="passw0rd"

# seal from downloaded certificate
echo -n "${secret}" | \
  kubeseal \
  --raw \
  --from-file=/dev/stdin \
  --cert sealed-secrets.pem \
  --namespace $namespace \
  --name $secretname

# seal with certificate from controller
# controllername="sealed-secrets"
# controllernamespace="sealed-secrets"
# echo -n "${secret}" | \
#   kubeseal \
#   --raw \
#   --from-file=/dev/stdin \
#   --controller-name $controllername \
#   --controller-namespace $controllernamespace \
#   --name $secretname
