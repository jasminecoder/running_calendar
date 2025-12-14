---
name: global-error-handling
description: Implement Rails error handling with rescue_from callbacks, user-friendly error pages, and proper exception management. Use when handling exceptions in controllers, creating custom error pages, implementing rescue_from blocks, validating and failing early, or configuring error tracking services in Rails applications.
---

## When to use this skill

- When adding `rescue_from` blocks in `ApplicationController`
- When creating custom error pages (`public/404.html`, `public/500.html`)
- When deciding between `find` (raises) and `find_by` (returns nil)
- When handling `ActiveRecord::RecordNotFound` or `ActionController::ParameterMissing`
- When implementing validation failure responses
- When rendering error status codes (`:not_found`, `:unprocessable_entity`)
- When configuring error tracking services (Sentry, Honeybadger)
- When implementing graceful degradation for external service failures

# Global Error Handling

This Skill provides Claude Code with specific guidance on Rails error handling patterns.

## Instructions

For details, refer to the information provided in this file:
[Rails Error Handling Standards](../../../agent-os/standards/global/error-handling.md)
