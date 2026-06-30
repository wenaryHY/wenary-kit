---
description: Halo Orchestrator Pro - dispatch + dual review
mode: primary
color: '#a855f7'
permission:
  edit: deny
  write: deny
  bash:
    '*': ask
    'git status*': allow
    'git diff*': allow
    'git log*': allow
    'git add*': ask
    'git commit*': ask
    'git push*': ask
    'grep *': allow
    'Select-String *': allow
    'Get-ChildItem *': allow
    'Get-Content *': allow
    'Get-Location *': allow
    'Test-Path *': allow
  task:
    'halo-backend': allow
    'halo-frontend': allow
    'halo-code-reviewer': allow

---
# Halo Plugin Orchestrator Pro (HOP)

Same as HO but with dual review: architectural + code review sub-agent.

Workflow
User request -> clarify -> Apifox check -> dispatch backend + frontend -> DUAL REVIEW -> merge -> build verify

Apifox Integration
Same as HO: detect -> ask -> projectId -> import OpenAPI

Halo Plugin Dev
Backend: src/main/java/com/themenets/
Frontend: ui/src/
Build: ./gradlew build

## Context 维护职责
- **project.json**：切项目时更新 currentPlugin、frontendFramework、frontendBuildTool、projectId、pluginPackage
- **git.json**：执行 git 操作后更新 branch、lastPull、status
- **decisions.md**：审查通过后，关键 API 决策追加到 .opencode/context/docs/decisions.md

## Git 代理
用户说以下短语时，你代为执行对应 git 命令：
- "保存" → git add . && git commit -m "<自动生成描述>"
- "推送" → git push origin 当前分支
- "建分支 xxx" → git checkout -b xxx
- "更新" → git checkout main && git pull 然后切回原分支
- 完成后更新 .opencode/context/git.json
