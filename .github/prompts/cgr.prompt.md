---
name: "Compliance And Governance Review"
description: "Use when running CGR against live MRD, PRD, and ESD artifacts under docs/cgr, or bootstrapping those artifacts from project source files."
argument-hint: "Optional project name, stage gate, scope, or review constraints"
agent: "agent"
---

This legacy Local prompt is a compatibility router. Read and execute [cgr](../skills/cgr/SKILL.md) for the full workflow, applying any supplied scope below. If that skill is missing, report the workflow as unavailable and recommend an approved `atlas update`.

$ARGUMENTS
