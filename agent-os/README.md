# Getting Started

## Project Config

- Configure core project info:
    - `/agent-os:plan-product`
    - generates `agent-os/project/{mission,roadmap,tech-stack}.md`

- Customize standards for your tech stack
    - `/agent-os:customize-standards-for-tech-stack`
    - generates `agent-os/standards/**/*.md`  (review these carefully!)

## Build a feature

- Create the spec
    - `/agent-os:create-spec`
    - asks clarifying questions
    - generates
        - `spec/my-new-feauture/requirements.md`
        - `spec/my-new-feauture/spec.md` (review this carefully!)
- Create the tasks
    - `/agent-os:create-tasks`
    - generates `spec/my-new-feauture/tasks.md`
- Implement the tasks
    - `/agent-os:implement-tasks`
    - generates code for your feature (review this carefully!)
    