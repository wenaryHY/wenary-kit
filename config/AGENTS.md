# 全局指令

适用范围：本文件由 `~/.config/opencode/opencode.jsonc` 的 `instructions` 字段加载，**对所有工作目录全局生效**，不依赖任何特定项目。

## 核心行为

- **回应语言**：交流用中文，复杂逻辑的注释写中文；变量名、函数名用英文
- **风格**：均衡 —— 给出结论 + 简要理由，避免过度解释
- **应用范围**：
  - 用户自己主导的项目（个人项目、你负责的团队项目）→ 全局规则生效
  - 第三方仓库（开源贡献、他人项目）→ 优先遵守该项目的规范，不要强加个人规则
- **工具选择**：用 `rg` 而非 `grep`，用 `fd` 而非 `find`
- **安全**：删除文件、force push、hard reset 等破坏性操作前先询问
- **效率**：独立的工具调用并行执行，有依赖关系的串行
- **禁止凭空假设**：改代码/写文档前，先读现有代码确认实际情况，不要假设

## 通用规范

- **Markdown 表格**：每一行必须独立换行，否则无法渲染
  ```
  | 列1 | 列2 |     ← 正确
  |---|---|
  | 数据 | 数据 |
  ```
  ```
  | 列1 | 列2 ||---|---|| 数据 | 数据 |     ← 错误
  ```

- **禁止 emoji**：代码、注释、文档、UI 文本中一律不使用 emoji

## 代码规范

- **缩进**：遵循项目已有的 formatter/linter 配置（Prettier、rustfmt、gofmt 等），不要与格式化工具对抗
- **禁止 `any`**：用 `unknown` 并做类型收窄
- **无魔法数字**：硬编码数值必须提取为命名常量
- **函数尽量短**：单一职责，不超过 40 行；如果函数描述需要"并"字，考虑拆分
- **测试**：默认 TDD（先写测试后写实现）；如果项目已有专有测试框架则用专有框架
- **错误处理**（语言级矩阵）：

  | 语言 | 错误处理方式 |
  |---|---|
  | Rust | `Result<T, E>` |
  | TypeScript / Python / Java / Go | 如果能构造类似 Rust `Result<T, E>` 的公共函数/模式，则套用；否则用该语言原生的错误处理机制 |
  | 其他语言 | 使用该语言约定俗成的错误处理方式 |

- **Review 原则**：可维护性优先 —— 审查时检查：函数长度 ≤ 40 行？禁止 `any`？魔法数字已提取？每个可能失败的操作都有错误处理？命名描述意图而非实现？无明显重复？

## 质量保障

- **DRY 原则**：相同逻辑出现 3 次以上，或跨模块边界出现 2 次，就抽取公共部分
- **Makefile**：项目根目录放 Makefile 作为统一命令入口
- **配置文件格式**：优先用 YAML / TOML，而非 JSON
- **日志**：统一日志输出风格

## 包管理器与工具链

- 前端：`pnpm` > `npm` > `yarn`
- Python：`uv`
- 其他语言使用该语言的官方或社区推荐工具

## Commit 与分支命名

- **Commit message**：中文
- **分支名格式**：`type/issue编号-描述`，例如 `feat/123-用户登录`、`fix/456-空指针`

## 办公任务

- **Office 文件**：Word / Excel / PPT 需按规范的格式输出，注意排版、样式、页眉页脚
- **文本处理**：Markdown、日志分析、文本提取等任务，优先给出可直接运行的命令或脚本

## 行为约定

每次回复前，先快速判断当前对话是否明显匹配某个 skill：

- 明显匹配 → 直接按对应 skill 流程执行
- 明显不匹配 → 直接过，不用逐条扫下表
- 不确定 → 快速扫触发表确认

命中规则：

1. **强匹配**（关键词、文件类型、动作意图都对得上一个 skill）：直接用 skill 工具加载该 skill 并按它的流程执行，不要先问"要不要用"。
2. **弱匹配**（场景相关但用户没明示）：在回复末尾加一行提示，格式固定：
   `> 提示：可以用 \`<skill-name>\` skill —— [一句价值说明]。`
3. **无匹配**：什么都不加，按常规回复。

每次回复**最多一条**弱匹配提示。强匹配直接执行不算提示额度。

如果用户已经在用某个 skill 流程，不要再推荐同主题的其他 skill。

## 触发表

> 入口形式：opencode 通过 skill 工具按名调用，不是 `/x` slash 命令。下表里写的就是 skill 名。

### 工程流程（mattpocock）

| Skill | 触发情境 |
|---|---|
| `tdd` | 写新功能或修 bug，需要 red-green-refactor 节奏 |
| `diagnose` | 报 bug、报错、行为异常、性能回退 |
| `grill-with-docs` | 启动新功能但规格不清，需要对照已有领域语言/ADR 拷问方案 |
| `grill-me` | 用户说"拷问我"、想压力测试自己的设计 |
| `zoom-out` | "X 是怎么工作的"、想看高层架构、对一段代码不熟 |
| `improve-codebase-architecture` | 代码异味在累积、想找重构机会 |
| `to-prd` | 当前对话已经描述了一个功能，需要落成 PRD |
| `to-issues` | 已经有方案/计划，需要拆成可独立领取的 issue |
| `triage` | 处理 issue 列表、过滤 bug 报告 |
| `caveman` | 用户说"caveman 模式"、"省 token"、"简短点" |
| `handoff` | 会话快结束、要交接给下一个 agent |
| `prototype` | "先做个 demo 看看"、想在不下决心前快速试一版 |
| `write-a-skill` / `writing-skills` / `skill-creator` | 出现重复工作流、值得固化成 skill |
| `setup-matt-pocock-skills` | 进入新项目首次需要配置 issue tracker / 标签 / 领域文档 |

### 官方工具（anthropics）

| Skill | 触发情境 |
|---|---|
| `claude-api` | 代码引入 `anthropic` / `@anthropic-ai/sdk`、调 Claude API、问 prompt caching |
| `frontend-design` | 做网页 UI、落地页、仪表盘、React 组件 |
| `webapp-testing` | 用 Playwright 测网页 |
| `web-artifacts-builder` | 做复杂的多组件 HTML artifact（含 shadcn/ui） |
| `mcp-builder` | 写 MCP server |
| `pdf` / `docx` / `pptx` / `xlsx` | 用户提到对应文件类型或要产出对应文档 |
| `canvas-design` | 做海报、视觉静态艺术品 |
| `algorithmic-art` | p5.js 生成式艺术、流场、粒子 |
| `brand-guidelines` | 应用 Anthropic 品牌色/字体 |
| `doc-coauthoring` | 写规范、提案、决策文档 |
| `internal-comms` | 写状态报告、内部更新、FAQ、事故复盘 |
| `slack-gif-creator` | 给 Slack 做动图 |
| `theme-factory` | 给 artifact 套主题 |

### 开发工作流（superpowers）

| Skill | 触发情境 |
|---|---|
| `brainstorming` | 创意/需求探索阶段 —— **写代码前如果意图不明，必须先用** |
| `dispatching-parallel-agents` | 出现 2 个以上互不依赖的任务 |
| `executing-plans` | 已有写好的实施计划要执行 |
| `subagent-driven-development` | 复杂多步任务在当前会话内推进 |
| `finishing-a-development-branch` | 实现完了、测试过了，要决定怎么合入 |
| `requesting-code-review` | 完成大功能、合入前要 review |
| `receiving-code-review` | 收到 review 反馈，要处理 |
| `systematic-debugging` | 卡在 debug、需要结构化方法 |
| `test-driven-development` | 写实现前先写测试 |
| `using-git-worktrees` | 需要隔离的工作区、跨分支并行 |
| `using-superpowers` | 第一次接触这套 skills，需要导览 |
| `verification-before-completion` | 准备宣称"完成/修好/通过"前 —— 先验证再说 |
| `writing-plans` | 拿到规格、动代码前要先写计划 |

### 前端/部署（vercel）

| Skill | 触发情境 |
|---|---|
| `vercel-react-best-practices` | 写或重构 React/Next.js 代码 |
| `vercel-composition-patterns` | 组件 boolean prop 增多、做组件库 API |
| `vercel-react-view-transitions` | 路由切换动画、共享元素动效、`startViewTransition` |
| `vercel-react-native-skills` | React Native / Expo 开发 |
| `deploy-to-vercel` | "部署到 vercel"、"给我个预览链接" |
| `vercel-cli-with-tokens` | 用 token 操作 Vercel CLI |
| `web-design-guidelines` | "review 我的 UI"、"检查可访问性"、UX 审计 |

### UI 打磨

| Skill | 触发情境 |
|---|---|
| `impeccable` | 设计、重设计、批评、打磨任何前端界面 |

### opencode 自身

| Skill | 触发情境 |
|---|---|
| `customize-opencode` | 编辑 `opencode.json(c)`、`.opencode/`、`~/.config/opencode/`，配置 agent / skill / plugin / MCP / 权限 |

## 元约束

- 推荐文案保持中文、简短、给出**具体价值**，不要空洞地说"试试这个 skill"。
- 同一会话里同一个 skill 提示**只发一次**，除非情境明显切换。
- 如果用户对推荐表达不满（"别再推荐了"、"安静点"），本会话内停止弱匹配推荐。
- 强匹配仍然要执行 —— 那是任务本身要求，不是噪音。

## 命名原则

优先级：**正确性 >> 准确性 >> 统一性**

- **正确性优先**：名称必须准确描述其用途、返回值、副作用。允许超长命名，不因简短牺牲正确性。
- **准确性其次**：名称应足够精确，避免歧义。一个名称对应一个概念。
- **统一性最后**：同一概念在项目中保持一致，但不因统一而接受错误或模糊的命名。
- **命名即注释**：改函数逻辑时必须同步检查命名是否需要更新，否则命名会误导人

### 正例
- `SESSION_STORAGE_KEY_FOR_PREVIEW_PARAMETERS_PASSED_TO_NEW_TAB` — 长但完全描述用途
- `validateThemeSlugIsInstalledAndSafeForPreviewRendering` — 精确描述校验逻辑
- `calculatePopoverPositionRelativeToFabButtonRect` — 纯函数不以 `use` 开头

### 反例
- `usePopoverPosition` — 纯计算函数，不应以 React Hook 前缀 `use` 开头
- `data` / `item` / `result` — 无具体含义

## GitHub 安全红线

- **严禁提交任何 AI 辅助痕迹**：commit message 保持中性，不提及任何 AI 工具、模型、skill、agent 名称
- **严禁提交 API key / token / 密码**：所有凭据走环境变量或 gitignored 文件
- **严禁提交 docs/private/ 以外的非公开信息**：`docs/private/` 已 gitignore，放敏感文档
- **修改 opencode 配置（AGENTS.md、opencode.jsonc 等）不提交到项目仓库**：这些是本地工具配置

## 三层边界（Always / Ask First / Never）

所有 Agent 必须遵守：

**✅ Always do（直接做，不用问）：**
- 只改与当前任务直接相关的文件
- 改代码前先读一遍现有代码再动手
- 改完后必须运行测试/构建验证并展示输出
- 按项目已有的代码风格和命名规范写

**⚠️ Ask first（必须先问）：**
- 修改数据库 schema 或迁移文件
- 新增第三方依赖
- 修改 CI/CD 配置
- 重构非任务目标的代码
- 改动超出当前任务范围的文件

**🚫 Never do（硬停止，绝不做）：**
- 不改与任务无关的文件（git diff --stat 确认）
- 不改 node_modules、vendor、dist、build 等目录
- 不删除或禁用已有测试
- 不绕过安全检查

## 约束写法原则（"X，不 Y"）

所有指令应遵循：
- 说是做什么，而不是只说不做什么
- 给出正向要求 + 排除路径，避免模糊
- 坏例子：不要改太多
- 好例子：只改 src/auth/register.ts，不动 src/api/ 和 src/models/