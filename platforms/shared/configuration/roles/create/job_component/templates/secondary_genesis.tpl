# template for besu-genesis chart/job
global:
  serviceAccountName: vault-auth
  vault:
    type: hashicorp
    network: besu
    address: {{ vault.url }}
    authPath: {{ network.env.type }}{{ name }}
    secretEngine: {{ vault.secret_path | default("secretsv2") }}
    secretPrefix: "data/{{ network.env.type }}{{ name }}"
    role: vault-role
  cluster:
    provider: {{ org.cloud_provider }}
    cloudNativeServices: false
    kubernetesUrl: {{ kubernetes_url }}
{% if network.docker.password is defined %}
image:
  pullSecret: regcred
{% endif %}
settings:
  removeGenesisOnDelete: true
  secondaryGenesis: true   
