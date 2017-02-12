#cloud-config

ssh_authorized_keys:
  - "${public_key}"

write_files:
  - path: "/home/${username}/.ssh/id_rsa"
    permissions: "0400"
    owner: "${username}"
    content: |
      ${private_key}
