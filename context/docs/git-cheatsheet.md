# Git 速查表

日常总控会帮你操作 Git，你基本不用手动。这里只是备查。

## 常用命令

| 场景 | 命令 |
|------|------|
| 保存进度 | `git add . && git commit -m "说明"` |
| 推送到远端 | `git push origin 当前分支名` |
| 开新分支 | `git checkout -b feat-xxx` |
| 拿最新代码 | `git checkout main && git pull` |
| 合并到当前分支 | `git merge main` |
| 当前状态 | `git status` |

## 冲突标记

```
<<<<<<< HEAD
你的代码
=======
别人的代码
>>>>>>> branch-name
```

删掉不要的部分 + 标记符号，保留正确的，保存后 `git add . && git commit -m "fix conflict"`

## 不要做的事

- ❌ 直接在 main 分支改代码
- ❌ `git push -f`（强制推送）
- ❌ 提交 jar、node_modules 等大文件
