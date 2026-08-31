# CLAUDE.md

This file gives Claude Code the context it needs to work effectively in the **LibasAI** repository.

## Project Overview

**LibasAI** (formerly FashionMind) is an AI-powered, multi-agent conversational shopping assistant for Pakistani apparel brands — a Final Year Project (FYP) at FAST-NUCES.

- **Team**: Mahad Malik (23I-0537) — Lead Backend/Recommendation, M. Shayan Asad (23I-0518) — Lead Frontend/Multi-Agent
- **Supervisor**: Mr. Syed Muhammad Saad Salman
- **Session**: 2026–2027
- **Classification**: Stream B (application-derived) FYP

LibasAI is a **discovery-and-redirect** platform: users search, compare, and get recommendations in-app, then get redirected to the brand's own site to complete purchase. **There is no in-app checkout, payment, or order management — this is explicitly out of scope. Do not build or suggest building these.**

## The Core Problem (Complex Computing Problem / CCP)

Everything in this repo should ultimately serve one intellectual core: **the trade-off between recommendation relevance and equitable visibility for small/emerging brands.**

A purely relevance-optimized recommender favors established brands (larger catalogs, richer interaction history) and starves small/data-scarce brands of exposure. LibasAI must design and evaluate a recommendation approach that balances personalized relevance against fair visibility under cold-start conditions.

- **Adopted approach**: Post-hoc re-ranking — train a relevance model normally (Module 3), then apply a bounded visibility adjustment to the ranked list afterward.
- **Baselines to implement for comparison**: popularity baseline, fixed-quota/rule-based injection baseline.
- **Noted but not required**: exposure-constrained optimization (Singh & Joachims, 2018) as a possible extension if time allows. Do not build this unless explicitly asked — it's out of the committed scope.
- **Acceptance criterion** (may be refined after the technical spike): retain ≥90% of the relevance of a purely relevance-optimized baseline (Precision@k, Recall@k) while improving small/emerging brand visibility in top-k by ≥20% relative to that baseline.

When working on the recommendation engine, always keep this trade-off explicit and measurable — don't let it get diluted into "just build a recommender."

## Key Constraint: A Trained Model Is Mandatory

The supervisor requires an **actually trained/fine-tuned model** — relying solely on pre-trained or API-served models does not satisfy the FYP requirement. This applies specifically to **Module 3 (Recommendation Engine)**:
- Train a Matrix Factorization or Neural Collaborative Filtering model (scikit-learn / LightFM) on interaction data.
- Bootstrap with a public dataset (H&M Personalized Fashion Recommendations) before real user data exists.
- The LLM (Groq/Qwen/Llama) and CLIP (Hugging Face) are **used as-is, not fine-tuned** — they are "Support" components, not the project's core contribution. Don't confuse chatbot/CLIP work with the CCP.

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Android-first) |
| Backend | FastAPI |
| Database | PostgreSQL |
| Vector store | pgvector extension in Postgres (FAISS/Qdrant Cloud as fallback) |
| Caching | Redis (Upstash) |
| Recommendation | Scikit-learn, LightFM |
| Image similarity | CLIP via Hugging Face Inference API (free tier, no fine-tuning) |
| LLM inference | Qwen/Llama via Groq API (free tier, no fine-tuning) |
| Deployment | Docker + Render/Railway (free tier) |
| Distribution | APK for testing/demo; Play Store publishing is optional future work, not a deliverable |

## System Modules

1. **AI Chatbot Interface** — NL query processing, intent/constraint extraction (budget, color, occasion, brand).
2. **Multi-Agent AI** — separate agents (not one LLM with tool-calling): Search, Recommendation, Comparison, Outfit. Agents run independently/in parallel where possible; this is a deliberate architecture choice for separation of concerns and latency, not a monolith.
3. **Recommendation Engine** — the CCP lives here. Cold-start handling, trained MF/NCF model, popularity baseline, fairness re-ranking, Precision@k/Recall@k + visibility/exposure metric.
4. **Brand Portal** — brand registration/auth, product CRUD, inventory/pricing management.
5. **Image Similarity Search** — image upload → CLIP feature extraction → similarity retrieval.
6. **Product Aggregation Module** — ingest brand-partner data + permitted public sources into a unified product DB, normalize/sync.

## Repo Conventions

- This is a Flutter repo (see `.gitignore`) with a FastAPI backend likely in a separate service/directory — check actual repo layout before assuming structure; don't assume a monorepo layout that isn't there.
- Android-first: don't add iOS/macOS/Windows-specific code unless asked.
- Use PostgreSQL JSONB for variable per-brand product attributes rather than rigid relational schemas — this was a deliberate design decision (brands have heterogeneous product fields).
- Keep external AI components (Groq, Hugging Face CLIP) called via their free-tier APIs, not self-hosted, unless explicitly asked to change this.

## Current Priorities (check with Mahad before assuming these are stale)

1. **Most urgent**: a proof-of-concept / technical spike demonstrating the relevance–fairness trade-off on a small dataset. This is the one gap that can't be closed by document editing — it needs actual code: a small trained recommender + a post-hoc re-ranking pass + before/after Precision@k, Recall@k, and exposure metrics on a small slice of data (e.g., H&M dataset subset).
2. After the spike/defense: move into full build-out of the modules above, starting with backend (FastAPI + Postgres) and the recommendation model, per the work division below.

## Work Division (for context on who owns what)

- **Mahad**: Backend (FastAPI), database design, Brand Portal, Image Similarity Search, recommendation model design/training/evaluation (owns the CCP).
- **Shayan**: Flutter frontend, conversational UI, chatbot integration, multi-agent workflow integration (supports recommendation model dev/eval).
- Shared: requirements, literature review, multi-agent implementation, product aggregation, API integration, testing, docs, deployment.

## Evaluation Plan (keep in mind when writing eval code)

- Intent extraction accuracy (chatbot)
- Task success rate (multi-agent pipeline)
- Relevance–visibility trade-off: Precision@k, Recall@k + visibility/exposure metric for small/emerging brands
- Usability testing: LibasAI conversational search vs. traditional keyword search

## Key References (cite/align with these where relevant to Module 3 work)

- Koren, Bell, Volinsky (2009) — Matrix Factorization Techniques for Recommender Systems
- He et al. (2017) — Neural Collaborative Filtering (WWW '17)
- Mehrotra et al. (2018) — relevance/fairness/satisfaction trade-off in two-sided marketplaces (CIKM '18)
- Singh & Joachims (2018) — exposure-constrained ranking (reference only; not implementing unless asked)

## Things to Avoid

- Don't add in-app checkout/payment/order management — explicitly out of scope.
- Don't quietly swap the trained recommender for a purely API/pre-trained solution — violates the mandatory training requirement.
- Don't collapse the multi-agent design into a single LLM-with-tools implementation without checking — the separation is an intentional, justified architecture decision in the proposal.
- Don't scope-creep into full e-commerce, multi-platform (iOS/web) support, or Play Store publishing unless explicitly requested.