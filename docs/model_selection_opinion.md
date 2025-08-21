# Model Selection Opinion

**Overview**
- **BIG_MODEL (groq-gpt-oss-120b)** – used for *Claude Opus* requests, the largest and most capable model.
- **MIDDLE_MODEL (groq-gpt-oss-20b)** – used for *Claude Sonnet* requests, a mid‑size model offering a balance of speed and quality.
- **SMALL_MODEL (groq-llama-3-8b)** – used for *Claude Haiku* requests, the fastest, lightweight model.

**Mixing Different Model Families**
- All three are from the Groq family, so their APIs and tokenization are compatible. **Models must stay within the same provider family**; otherwise, mismatched request formats, tokenizers, rate‑limit policies, and pricing structures can cause integration failures.
- If you route through a LiteLLM proxy that normalizes different back‑ends, you can mix models from different factories (e.g., DeepSeek, OSS‑GPT, Meta Llama). It works only when the proxy handles each provider’s token limits, safety policies, and error formats; otherwise you may encounter provider‑specific failures.

**What Do Opus, Sonnet, Haiku Mean?**
- *Opus*: the most powerful Claude tier, suited for complex, high‑stakes tasks that need deep reasoning.
- *Sonnet*: a mid‑tier Claude tier, good for everyday coding, reasoning, and chat with lower latency.
- *Haiku*: the lightweight tier, ideal for quick, simple queries where speed matters more than depth.

**Opinion**
- Using the largest model for Opus ensures best quality for critical workloads.
- Pairing Sonnet and Haiku provides cost‑effective scaling for routine tasks.
- The three‑tier setup gives flexibility without sacrificing compatibility, as long as all models stay within the same provider family.