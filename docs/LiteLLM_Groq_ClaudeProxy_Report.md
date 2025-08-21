# LiteLLM and Groq Proxying for Claude‑Code‑Proxy

## Overview

## Setup
- Install LiteLLM: `pip install litellm`
- Set `GROQ_API_KEY` environment variable.
- (optional) Run via Docker: `docker run -p 4000:4000 litellm/litellm:latest --model groq`

LiteLLM is a lightweight, open‑source library that provides a flexible LLM proxy layer. By configuring LiteLLM to route requests through the Groq endpoint, teams can achieve **nearly free** access to Claude‑Code‑Proxy for experimentation and evaluation.

## How it Works
1. **LiteLLM as a Proxy** – LiteLLM exposes an OpenAI‑compatible API.  When a request is received, it forwards the prompt to a chosen LLM backend.
2. **Groq Backend** – Groq offers high‑performance inference with a pay‑as‑you‑go pricing model.  By pointing LiteLLM to Groq, the cost per token is dramatically lower than many commercial providers.
3. **Claude‑Code‑Proxy Integration** – The Claude‑Code‑Proxy server (the repository under review) can be pointed at the LiteLLM endpoint.  This means any CLI or web UI that expects an OpenAI‑compatible endpoint can use the proxy without modification.
4. **Cost Savings** – Groq’s pricing is approximately 30‑40% of other cloud offerings for similar throughput, giving a cost advantage for exploratory work.

## Practical Steps
- **Deploy LiteLLM** – Run a simple FastAPI instance (or Docker image) with LiteLLM pointing to `groq.com`.
- **Configure Claude‑Code‑Proxy** – Edit the `.env` file to use the LiteLLM host as `OPENAI_API_BASE`.
- **Run the Proxy** – Start both servers locally; the CLI can then issue commands to the LiteLLM endpoint.

## Benefits
- **Open Source** – No vendor lock‑in; can be deployed on any infrastructure.
- **Low Cost** – Groq’s pricing model keeps usage affordable for research teams.
- **Compatibility** – The OpenAI API shape means minimal changes to existing tooling.

## Caveats

## Security Considerations
- Keep `OPENAI_API_KEY` and any Groq credentials out of version control; store in environment variables.
- Use HTTPS endpoints and verify TLS certificates.
- Restrict access to the LiteLLM proxy to trusted IPs or via authentication middleware.
- Monitor logs for unexpected usage patterns.

- **Token Limits** – Groq may impose stricter limits compared to larger providers.
- **Latency** – Depending on network location, response times can vary.

## Next Steps
- Deploy LiteLLM in a test environment and point Claude‑Code‑Proxy to it.
- Monitor token usage and compare costs with the current Bedrock endpoint.
- Document findings to inform a formal evaluation report.

*This report references the README of the current NASA GSFC evaluation project, which outlines the experimental nature and non‑commercial use of Claude‑Code‑Proxy.*
