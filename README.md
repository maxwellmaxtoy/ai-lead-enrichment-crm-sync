# AI Lead Enrichment & CRM Sync

A production-ready AI lead processing and CRM automation system built with n8n, Supabase, Google Gemini, Google Forms, Apps Script, and Gmail.

The workflow accepts leads from a real Google Form, validates and deduplicates them, enriches company information using AI, calculates a lead score, updates the CRM, records audit events, and sends operational notifications.

## Architecture

```text
Google Form
    ↓
Google Apps Script
    ↓
Authenticated n8n Webhook
    ↓
Input Validation
    ↓
Deduplication
    ↓
Supabase CRM
    ↓
Company Website Fetch
    ↓
Gemini AI Enrichment
    ↓
Confidence Gate
    ↓
Lead Scoring
    ↓
Qualification
    ↓
CRM Update
    ↓
Audit Logging
    ↓
Gmail Notifications