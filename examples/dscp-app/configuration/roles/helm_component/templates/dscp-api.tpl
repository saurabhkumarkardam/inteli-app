apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: {{ name }}-api
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/dscp-api
  releaseName: {{ name }}-api
  values:
    fullNameOverride: {{ name }}-api
    config:
      port: {{ peer.api.port }}
      externalNodeHost: "{{ name }}"
      externalNodePort: {{ peer.ws.port }}
      logLevel: info  
      externalIpfsHost: "{{ name }}-ipfs-api" 
      externalIpfsPort: {{ peer.ipfs.apiPort }} 
      enableLivenessProbe: true
      substrateStatusPollPeriodMs: 10000
      substrateStatusTimeoutMs: 200000
      ipfsStatusPollPeriodMs: 10000
      ipfsStatusTimeoutMs: 200000
      auth:
        type: NONE
        jwksUri: {{ auth_jwksUri }}
        audience: {{ auth_audience }}
        issuer: {{ auth_issuer }}
        tokenUrl: {{ auth_tokenUrl }}
    ingress:
      enabled: false
      className: "gce"
      paths:
        - /v3
    replicaCount: 1
    image:
      repository: ghcr.io/digicatapult/dscp-api
      pullPolicy: IfNotPresent
      tag: 'v4.6.7'
    dscpNode:
      enabled: false

    dscpIpfs:
      enabled: false
      dscpNode:
        enabled: false
    vault:
      alpineutils: ghcr.io/hyperledger/alpine-utils:1.0
      address: {{ component_vault.url }}
      secretprefix: {{ component_vault.secret_path | default('secretsv2') }}/data/{{ org_name }}/{{ peer.name }}
      serviceaccountname: vault-auth
      role: vault-role
      authpath: "{{ network.env.type }}{{ org.name | lower }}"
