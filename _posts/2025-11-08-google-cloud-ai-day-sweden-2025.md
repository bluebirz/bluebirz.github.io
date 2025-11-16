---
title: "Note of seminar - Google Cloud AI Day Sweden 2025"
layout: post
author: bluebirz
description: I have participated in "Google Cloud AI Day Sweden 2025". 
date: 2025-11-08
categories: [events, seminar]
tags: [Google, Gemini, Google Firebase, Google ADK, GitLab, Apigee, MCP, AlloyDB]
mermaid: true
comment: true
image:
  path: assets/img/features/bluebirz/IMG_1376-google-cloud-ai-day.JPG
  lqip: ../assets/img/features/lqip/bluebirz/IMG_1376-google-cloud-ai-day.webp
  alt: Google Cloud AI Day Sweden 2025
  caption:
---

Last Wednesday (2025-11-05), my colleagues and I have participated in "Google Cloud AI Day Sweden 2025". There were so many ideas around there enlightened me to improve my way of working.

{% include bbz_custom/link_preview.html url='<https://cloudonair.withgoogle.com/events/google-cloud-ai-day-sweden-2025>' %}

---

## On the way

This event took place at Münchenbryggeriet, Stockholm.

<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d4071.479881602193!2d18.053289777432123!3d59.32059941171919!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x465f77e764fb664f%3A0x4cd8592d13dee65d!2sM%C3%BCnchenbryggeriet!5e0!3m2!1sen!2sse!4v1762453752863!5m2!1sen!2sse" width="100%" height="450" frameborder="0" class="gmap" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>

---

## My notes

I have joined "AI for Developers Track" and here is my notes I brought back from this event.

The future of software development in the age of AI
: > Future development will give developers smarter tools to build smarter apps that run on smarter platforms.

    - Focus on simplicity
    - Run faster experiments  
    - Build agentic solutions
    - Shift down: push workloads to platforms
    - AI assisted

    Then developers become more productive.

Prototype, Build, and Deploy AI-Powered Apps
: In this session, the speaker demonstrated [firebase.studio](https://firebase.studio/) to create a simple note accepting both text and voice input by simple prompts on Gemini. And presented [Gemini CLI](https://github.com/google-gemini/gemini-cli) too.

  The speaker also made audiences to craft an app using Gemini with their own ideas to a small competition.

Building Intelligent Agents: Gemini, Google ADK, and Memory Management
: Google Cloud Gemini LLMs are capable for:

    - Advance reasoning & multi-step planning
    - Native multimodality
    - Long context & caching
    - Optimized Price-performance & speed

    Introduced [Google ADK](https://google.github.io/adk-docs/) to develop and deploy AI agents. It manages sessions and memory in order to remember, understand, and respond naturally towards user queries. And we can deploy our agent from Google ADK to Agent Engine, Cloud Run, or GKE.

Opening Keynote
:   - Introduce [Google Gemini Enterprise](https://cloud.google.com/gemini-enterprise) for employees with 100+ tool connectors.
    - Adopt End2End agentic standardization:
      - [Agent Development Kit (ADK)](https://google.github.io/adk-docs/): build & deploy
      - [Agent2Agent (A2A) Protocol](https://a2a-protocol.org/latest/): communicate & collaborate
      - [Agent Payment Protocol (AP2)](https://github.com/google-agentic-commerce/AP2): nagotiate & transact
    - Google's 4Ms architecture for efficient AI: Machine, Model, Mechanisation, and Map

Build the AI-powered conversational app of tomorrow, today
: Speaker showed demos of [Firebase AI Logic](https://firebase.google.com/docs/ai-logic) to build a real-time, natural-voice interaction with Gemini Live API and Firebase AI Logic the people can interact with AI and ask AI about what and how they doing through video camera.

Five Key Takeaways to Enhance Your Gemini Apps
:   1. Multi-layered application
        - modularity & easy maintenance: UI &#8596; Logic &#8596; Data
        - independent scaling: to identify bottleneck and scale as needed
        - flexible tool integration
    2. Application performance
        - use global endpoint
        - use "lite" model for speed
    3. Cost effective
        - batch processing
        - cache
        - controlled generation
        - global endpoint
        - provision throughput
    4. Context awareness
        - use system instruction: define critical details that model needs to remember.
        - use grounding with Google Search: allows Gemini to browse the internet to get latest information.
        - use RAG (Retrieval-Augmented Generation): model learns from private data and converts to vectors then include relevant data in overall context.
    5. Simplicity
        - easy to build
        - faster to ship
        - quicker to fix/debug

Securing AI Applications in Google Cloud: A Developer's Guide
: There's Google's **SAIF** (Secure AI Framework) and the SAIF risk map is as below.
    <br/>
    ```mermaid
    ---
    title: SAIF risk map
    ---
    stateDiagram-v2
        direction LR
        state "Data Sources" as ds

        state "Infrastructure" as infra
        state "Data Storage Infrastructure" as infra
        state "Model Storage Infrastructure" as infra
        state "Model Serving Infrastructure" as infra

        state "Model" as model
        
        state "Application" as app

        state "User" as user

        ds --> infra
        infra --> model
        model --> app
        app --> model
        app --> user
        user --> app
        app --> ds
    ```

    **Risks**: 

    - **Data Poisoning**: inject tainted data into the model to degrade performance, skew results towards a specific outcome, or implant hidden backdoors.
    - **Model Source Tampering**: introduce vulnerabilities or unexpected behaviors by tampering with source code, dependencies, or weights, either by supply chain attacks or insider attacks.
    - **Prompt Injection**: cause the model to executed commands "injected" inside a prompt to change model's behaviors.
    - **Insecure Integrated Component**: vulnerabilities in software interacting with models in order to gain unthorized access, introduce malicious code, or compromise system operations.

    **Implement strong security foundations**:

    - **Data & Model Perimeter**: establish a security parameter to prevent unauthorized data and model endpoints access by using VPC Service Controls.
    - **Least Privilege Control**: use MFA and apply the principle of least privilege to all Service Accounts that execute model training or inference code.
    - **Model Versioning & Traceability**: automatically version models and track data provenance (metadata on training/tuning data).
    - **Cloud Logging & Monitoring**: leverage Cloud Logging & Monitor to audit user prompts, agent reasoning steps, and final responses.

Building ADK agents in your Enterprise Systems
: > An AI Agent is an **Application** that tries to achieve a specific **Goal** by **Observing** the world and **Acting** upon it using the **Tools** it has at its disposal.

    The speaker showed how to use Agent Development Kit to build multi-agent solutions and [Apigee API Hub](https://cloud.google.com/apigee/docs/apihub/what-is-api-hub) to discover and find toolset to connect and integrate with our applications. For example, connect Salesforce to display accounts & contacts, connect JIRA to create issues, or connect Google Maps to route the map.

Partner Session: GitLab
: The speaker from GitLab introduce [GitLab Duo](https://about.gitlab.com/gitlab-duo/), AI-powered DevSecOps platform to assist DevOps tasks such as summarize discussion, suggest code, explain tests and vulnerabilities.

Building Your Next Agent with MCP and AlloyDB
: The speaker demonstrated the architecture of Agentic AI.

    ```mermaid
    ---
    title: Agentic App Architecture
    ---
    stateDiagram-v2
        state "Front end" as fn 
        state "Agent" as agent 
        state "Model" as model 
        state "MCP Toolbox" as mcp {
            state "Tool 1: Product Lookup" as tool1
            state "AlloyDB AI<ul style="text-align:left"><li>Vector similarity search</li><li>App & schema context</li><li>Query templates</li><li>LLM (e.g. Gemini)</li></ul>" as tool1
            state "Tool 2: Place Orders" as tool2
        }
        state "AlloyDB Database" as db {
            state "ScaNN index" as tb
            state "Model Endpoint Management" as endpoint 
        }
        state "Vertex AI" as ai 

        fn --> agent
        agent --> fn 

        agent --> model
        model --> agent

        agent --> mcp
        mcp --> agent

        tool1 --> db : select
        db --> tool1

        tool2 --> db : update 
        db --> tool2

        ai --> endpoint
        endpoint --> tb
    ```

    With Agent Development Kit (ADK), we can develop and deploy AI agents which is optimized for Gemini and Google ecosystem plus compatible with other frameworks.

    - **Grounding problem or hallucination** is that the model only understand information that they're trained on and explicitly given in the prompt then they often assume that the premise of a prompt is true.
    - **RAG or Retrieval-Augmented Generation** is that **R**etrieve relevant data to the problem and **A**dd into the prompt which is fed to LLM then **G**enerate output more relevant and reliable.
    - **Intelligent search** = Semantic search. It can understand meaning beyond simple keywod matching and embed numerical vectors capturing semantic essence.
    - **Embedding vectors** means storing vector-type variables into the database and it can be fetched later.
    - **ScaNN** stands for **Sca**lable **N**earest **N**eigbor is an ANN library published by Google in 2020 where **ANN** (**A**pproximate **N*earest **N**eighbor) is an algorithm to find data points that close to the query point but not necessary to be the exact closest ones.
    - [AlloyDB](https://docs.cloud.google.com/alloydb/docs/overview) is a database built for Gen AI era. It's compatible with PostgreSQL, highly available with 99.99% SLA, and features AlloyDB AI that supports AI vector processing, AI Query Engine, AI Natural language, and AI models.

Evening Keynote
: End of the day with fascinating video and presentation of space discovery history from Professor of Planetary Science, Susie Imber.

---

I like the way Google promoted their Gemini and complications towards AI.

---

## References

- [Richard Seroter on shifting down vs. shifting left \| Google Cloud Blog](https://cloud.google.com/blog/products/application-development/richard-seroter-on-shifting-down-vs-shifting-left/)
- [Retrieval-augmented generation - Wikipedia](https://en.wikipedia.org/wiki/Retrieval-augmented_generation)
- [What is Approximate Nearest Neighbor (ANN) Search? \| MongoDB](https://www.mongodb.com/resources/basics/ann-search)
