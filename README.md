[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/taskmedia)](https://artifacthub.io/packages/helm/taskmedia/ipsec-vpn-server)

# Helm chart: IPsec VPN server

Kubernetes [Helm](https://helm.sh) chart to run an IPsec VPN server, with IPsec/L2TP, Cisco IPsec and IKEv2.
This is based on the docker image [hwdsl2/docker-ipsec-vpn-server](https://github.com/hwdsl2/docker-ipsec-vpn-server).

The main goal is to simplify the deployment of a VPN server for k8s.
You will be able to configure VPN users directly as list in the [`values.yaml`](./values.yaml).

## Configuration

The configuration of the VPN server will be set in the [`values.yaml`](./values.yaml)-file.
Please ensure to overwrite the configuration especially for `vpn.psk`, `vpn.dns_name` and `users[*].password`.

It is possible to commit the password to your git repository if you have a separate sealed-secret instance.
You find detailed documentation in the section [Using sealed-secrets](#Using-sealed-secrets).

## Installation

To deploy the Helm chart first copy the [`values.yaml`](./values.yaml)-file and customize your deployment.
After it was modified you can deploy the chart with the following command.

```bash
$ helm repo add taskmedia https://helm.task.media
$ helm repo update

$ helm show values taskmedia/ipsec-vpn-server > ./my-values.yaml
$ vi ./my-values.yaml

$ helm upgrade --install vpn taskmedia/ipsec-vpn-server --values ./my-values.yaml
```

You can also use OCI Helm charts from [ghcr.io](https://ghcr.io/):

```bash
$ helm upgrade --install vpn oci://ghcr.io/taskmedia/ipsec-vpn-server
```

## Using sealed-secrets

To ensure your passwords can be committed to the repository (GitOps) without security issues you can use the integrated [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets) approach.
Enable it by setting `sealed_secrets: true`.
The `vpn.psk` and `users[*].password` then have to be entered encrypted.
To encrypt a value you need to use the public key of sealed-secrets.
The best approach is to use the [`kubeseal`](https://github.com/bitnami-labs/sealed-secrets/releases/latest) binary:

```bash
$ echo -n "${secret}" | \
    kubeseal \
    --raw \
    --from-file=/dev/stdin \
    --controller-name "sealed-secrets" \
    --controller-namespace "sealed-secrets" \
    --name "vpn-vpnconfig" \
    --namespace "vpn" \
```

Ensure to use the correct _name_ and _namespace_ otherwise the [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) will not be created by sealed-secrets.
As _name_ you have to specify the name of the generated secret.
Typically this is your `fullnameOverride` with suffix `-vpnconfig`.
Also specify the _namespace_ where the VPN server will be deployed to.

**Example**

```yaml
users:
  - username: vpn
    password: AgBAK6LJs8coFflnplWkf/w9a/MR6HpWHKPyEerTW+KgIf/XvOUC72YIGMlOYxWcyMX6v8GfnWKOR32KMKejzLGEEYaije1JPGeDgpiChzcKow7GJx2tCZy9BCDdX68UZlIX8SYNBa+fkPV1jwk5SuAURVO5K5VngNlRF3XjkEvxZ6rfvELE+T9IJj4jg8/cBVIbypBHx/Cw1eDOucZXSQKo3bvyBiVasd/MzfCj+3ukayeAbrm5XqRlxVNjRKikOv0HO3qr8SwWyguVush5Jpo0LCmqwGf8z1QmBQFqI1/XJXAJ3kckvanRwEafUpNRAyaY/H/b7OMaw3wUkaWcUTCQ5ZUFe99OKLzQzMlxC+nGxE78v2/RKS5Nxf2mQFnXdjtAZBnKN+fYs/N8YpixFF3FRZQ2FEtifcDUBTvQ9U1bcd7S3vybOAfJHy3FNi6v+/vCtWuwELAznD5EaEJZ1UE6My7spgYbQ3Ld3TxnReYyR9L2171D509/zMWZdFiaVIY417Clq03mi9pbyz85CsR1Sm3yNsw7YGAO3hBZd0a1wW519CrKEUQ0laQoEWkw7EMfj/WtOLBmw9DgRDCFHhLDRF6vwVNGhmnu/qW+dpYtY18wI6LuO5HnblV/fJ0/aD4SnscLgmnopFPraqtK2E4DQGsVc0jLu+nBcN46SYCUTysVPwULMddQXLyPbBYStjjCXFgJR9xTmg==
```
