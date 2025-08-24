# Claude Code Proxy & LiteLLM Deployment Guide

## Overview
This document describes how to run the **Claude Code Proxy** locally and expose it through a **LiteLLM** proxy that forwards OpenAI‑compatible requests to Groq models. The setup enables the `claude` CLI (Claude‑Code) to communicate with Groq’s OSS‑20B model (or other Groq models) without modifying the CLI.

## Architecture Diagram
```
+----------------+      +----------------+      +-------------------+
| Claude‑Code    | ---> | LiteLLM Proxy  | ---> | Groq LLM endpoint |
| CLI (local)    |      | (Docker/FastAPI) |   | (groq.com)        |
+----------------+      +----------------+      +-------------------+
```
*Claude‑Code CLI sends OpenAI‑style HTTP requests to the LiteLLM proxy, which authenticates with Groq and returns model responses.*

## Prerequisites
- **Python 3.10+** (for running the proxy via `uvicorn`)
- **Docker** (optional, for running LiteLLM container)
- **uv** (Python package manager) – `install-uv.sh` script is provided.
- **Groq API key** (set as `GROQ_API_KEY`).
- **Anthropic environment variables** for Claude‑Code (see `vars`).

## Setup Steps
### 1. Clone & Prepare Claude‑Code‑Proxy
```bash
# Clone a known implementation (the repository contains multiple forks)
git clone git@github.com:fuergaosi233/claude-code-proxy.git
cd claude-code-proxy
```
### 2. Configure Environment
Create a `.env` file (or copy the provided template) with the following variables:
```dotenv
# Base URL for Claude‑Code CLI to reach the proxy
ANTHROPIC_BASE_URL=http://localhost:8082
# Auth token – the proxy does not validate it, but the CLI expects a value
ANTHROPIC_AUTH_TOKEN=ignored-ansi-uses-network-auth
# Model to request – Groq model name understood by LiteLLM
ANTHROPIC_MODEL="openai/groq-gpt-oss-20b"
```
> **Security note** – Do **not** commit `.env` to version control; add it to `.gitignore`.
### 3. Run the Proxy Server
```bash
uv run uvicorn server:app --host 127.0.0.1 --port 8082 --reload
```
The proxy now listens on `http://localhost:8082` and forwards requests to the configured OpenAI‑compatible endpoint.

### 4. Deploy LiteLLM
#### a) Build the Docker image (recommended for isolation)
```bash
cd litellm-deploy
make docker   # runs the Litellm container with config mounted
```
The Makefile runs:
```bash
docker run \
  --env-file=env -v $(pwd)/litellm_config.yaml:/app/config.yaml \
  -p 4000:4000 \
  ghcr.io/berriai/litellm:main-stable \
  --config /app/config.yaml --detailed_debug
```
#### b) Configuration (`litellm_config.yaml`)
```yaml
model_list:
  - model_name: groq-llama-3-70b
    litellm_params:
      model: groq/llama-3.3-70b-versatile
      api_key: "os.environ/GROQ_API_KEY"
  # …additional Groq models omitted for brevity…
```
Create a matching `env` file (or copy `env.example`) with:
```dotenv
LITELLM_MASTER_KEY=st-putyourkeyhere
LITELLM_SALT_KEY=sk-putyoursalthere
GROQ_API_KEY=gsk_putyourgrokapikeyhere
```
> **Security note** – Keep `LITELLM_MASTER_KEY`, `LITELLM_SALT_KEY`, and `GROQ_API_KEY` secret; do not expose them publicly.
#### c) Start LiteLLM
If using Docker (as above) the service is available at `http://localhost:4000/v1`.
Alternatively, run locally with:
```bash
pip install litellm
litellm --model groq/llama-3.3-70b-versatile --api_key $GROQ_API_KEY
```

### 5. Point Claude‑Code‑Proxy to LiteLLM
Edit the proxy’s `.env` (or export in the shell) to set:
```dotenv
OPENAI_API_BASE=http://localhost:4000/v1
OPENAI_API_KEY=st-putyourkeyhere   # matches LITELLM_MASTER_KEY
```
Restart the proxy if it was already running.

## Security Considerations
- **Secret Management** – Store all keys (`GROQ_API_KEY`, `LITELLM_*`) in environment variables or secret stores; never commit them.
- **Transport Security** – When exposing the LiteLLM proxy beyond localhost, enable TLS (e.g., terminate with a reverse proxy) and restrict access via firewall or authentication middleware.
- **Least‑Privileged Ports** – The proxy runs on 8082 and LiteLLM on 4000; ensure only trusted users can reach these ports.
- **Audit Logging** – Enable `--detailed_debug` in LiteLLM (as in the Makefile) to capture request metadata for monitoring.
- **Key Rotation** – Rotate Groq and LiteLLM keys regularly and update the corresponding `.env` files.

## Maintenance Checklist
- **Update Groq models** – Refresh `litellm_config.yaml` when new models are released.
- **Renew Secrets** – Rotate `GROQ_API_KEY`, `LITELLM_MASTER_KEY`, and `LITELLM_SALT_KEY` quarterly.
- **Dependency Upgrades** – Periodically run `uv pip install --upgrade -r requirements.txt` in the proxy repo.
- **Health Checks** – Verify both services respond (`curl http://localhost:8082/health` and `curl http://localhost:4000/v1/models`).
- **Backup `.env`** – Store a copy of sanitized `.env.example` in the repo for onboarding.

## References
- Claude‑Code‑Proxy repository: https://github.com/fuergaosi233/claude-code-proxy
- LiteLLM documentation: https://docs.litellm.ai
- Groq API docs: https://console.groq.com/docs
- Project reports: `docs/LiteLLM_Groq_ClaudeProxy_Report.md`
- Environment variables used by the CLI: `vars`

---
*Generated with Claude Code Man*