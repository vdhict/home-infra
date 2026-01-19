# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/claude-code) when working with code in this repository.

## Project Overview

This is a home infrastructure repository for deploying and managing a Kubernetes cluster. It is based on the [onedr0p/cluster-template](https://github.com/onedr0p/cluster-template) and uses:

- **Talos Linux** as the Kubernetes operating system
- **Flux** for GitOps-based cluster management
- **SOPS** with Age for secrets encryption
- **Task** (go-task) for automation

## Repository Structure

```
├── kubernetes/          # Kubernetes manifests managed by Flux
│   ├── apps/           # Application deployments
│   ├── bootstrap/      # Bootstrap configuration (Talos patches)
│   └── flux/           # Flux system configuration
├── talos/              # Talos Linux configuration
│   └── clusterconfig/  # Generated node configs
├── bootstrap/          # Bootstrap templates and scripts
│   ├── templates/      # Jinja2 templates for config generation
│   └── scripts/        # Bootstrap helper scripts
├── scripts/            # Utility scripts
├── .taskfiles/         # Task automation files
│   ├── bootstrap/      # Bootstrap tasks
│   ├── kubernetes/     # Kubernetes tasks
│   ├── talos/          # Talos tasks
│   └── workstation/    # Workstation setup tasks
└── .github/            # GitHub Actions workflows
```

## Common Commands

All automation uses [Task](https://taskfile.dev/). Run `task --list` to see available tasks.

### Setup & Configuration
- `task init` - Initialize config.yaml from sample
- `task configure` - Render and validate configuration files
- `task workstation:brew` - Install CLI tools via Homebrew
- `task workstation:venv` - Setup Python virtual environment

### Talos Cluster Management
- `task bootstrap:talos` - Deploy and bootstrap the Talos cluster
- `task talos:generate-config` - Regenerate Talos node configs
- `task talos:apply-node HOSTNAME=<node>` - Apply config to a node
- `task talos:upgrade-node HOSTNAME=<node>` - Upgrade Talos on a node
- `task talos:upgrade-k8s` - Upgrade Kubernetes version
- `task talos:reset` - Reset cluster to maintenance mode

### Flux & Kubernetes
- `task bootstrap:flux` - Install Flux and sync to Git
- `task kubernetes:resources` - Show common cluster resources

## Key Configuration Files

- `config.yaml` - Main configuration (generated from config.sample.yaml)
- `talconfig.yaml` / `talhelper.yaml` - Talos cluster configuration
- `kubernetes/flux/` - Flux kustomizations and sources
- `.sops.yaml` - SOPS encryption configuration
- `age.key` - Age encryption key (do not commit unencrypted)

## Environment

- `KUBECONFIG` is set to `./kubeconfig` via direnv
- Python virtual environment is in `.venv/`
- SOPS Age key is expected at `./age.key`

## Working with Secrets

All `*.sops.*` files are encrypted with SOPS/Age. To edit:
```sh
sops <file>.sops.yaml
```

Ensure secrets are encrypted before committing.

## GitHub Actions

The repository includes workflows for:
- `labeler.yaml` - Auto-label PRs
- `label-sync.yaml` - Sync GitHub labels
- `release.yaml` - Create monthly releases
- `e2e.yaml` - End-to-end testing (runs on upstream template only)

## Notes

- This repo uses `mise` for tool version management in CI
- Kubernetes manifests follow Flux conventions with HelmRelease and Kustomization resources
- The cluster uses Cilium for CNI, cert-manager for certificates, and OpenEBS for storage
