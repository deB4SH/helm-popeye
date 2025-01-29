# Helm Popeye

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

Helm Popeye provides an easy to install chart which enables you to deploy popeye as cronjob in your cluster and report findings towards prometheus. This chart is provided as-is with no warranties. 

## What is Popeye

Popeye is a utility that scans live Kubernetes clusters and reports potential issues with deployed resources and configurations. As Kubernetes landscapes grows, it is becoming a challenge for a human to track the slew of manifests and policies that orchestrate a cluster. Popeye scans your cluster based on what's deployed and not what's sitting on disk. By linting your cluster, it detects misconfigurations, stale resources and assists you to ensure that best practices are in place, thus preventing future headaches. It aims at reducing the cognitive overload one faces when operating a Kubernetes cluster in the wild. Furthermore, if your cluster employs a metric-server, it reports potential resources over/under allocations and attempts to warn you should your cluster run out of capacity.

Popeye is a readonly tool, it does not alter any of your Kubernetes resources in any way!

## How to use

The chart is published via oci repository here on github via `oci://ghcr.io/deb4sh/helm-popeye`.
A general usage guide for using oci-based registries is provided via the official helm documentation availble [here](https://helm.sh/docs/topics/registries/)


An other, often prefered way is to use umbrella charts. Through an umbrella chart you can easily provide a generic base configuration and only need to configure your specific cluster environment in a second values configuration.

An example may look like the following snipped.

```
apiVersion: v2
name: popeye
version: 1.0.0
description: This chart deploys popeye.
dependencies:
  - name: popeye
    version: 0.0.0-63cb61
    repository: oci://ghcr.io/deb4sh/helm-popeye
```

A general value overlay may look like.
```
popeye:
  cronJob:
    schedule: "* */1 * * *"
    securityContext:
      runAsNonRoot: true
      seccompProfile:
        type: RuntimeDefault
    
    containerConfiguration:
      outputFormat: ""

  job:
    securityContext:
      allowPrivilegeEscalation: false
      runAsNonRoot: true
      runAsUser: 5000
      runAsGroup: 5000
      seccompProfile:
        type: RuntimeDefault
      capabilities:
        drop:
          - ALL
    resources:
      limits:
        cpu: '1'
        memory: 1000Mi
      requests:
        cpu: 500m
        memory: 500Mi
  
  grafana:
    enabled: true
    datasource: "victoriametrics"
```

Some spinch examples are available [here](https://github.com/derailed/popeye/tree/master/spinach-examples).

## Honorable Mentions

This wouldn't be able without the awesome work of the open source communities. 

* https://github.com/derailed/popeye


[contributors-shield]: https://img.shields.io/github/contributors/deb4sh/helm-popeye.svg?style=for-the-badge
[contributors-url]: https://github.com/deb4sh/helm-popeye/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/deb4sh/helm-popeye.svg?style=for-the-badge
[forks-url]: https://github.com/deb4sh/helm-popeye/network/members
[stars-shield]: https://img.shields.io/github/stars/deb4sh/helm-popeye.svg?style=for-the-badge
[stars-url]: https://github.com/deb4sh/helm-popeye/stargazers
[issues-shield]: https://img.shields.io/github/issues/deb4sh/helm-popeye.svg?style=for-the-badge
[issues-url]: https://github.com/deb4sh/helm-popeye/issues
[license-shield]: https://img.shields.io/github/license/deb4sh/helm-popeye.svg?style=for-the-badge
[license-url]: https://github.com/deb4sh/helm-popeye/blob/main/LICENSE.txt