# Rust 高可维护项目设计规范

来源：用户提供的 Rust 最佳实践白皮书

## 1. 项目结构与组织
- Workspace vs 单 Crate 的选择标准
- 扁平化 Workspace 目录结构
- 可见性控制（pub(crate)）封装
- 条件编译（cfg-if、include_str!、features）

## 2. 错误处理与恐慌策略
- Panic 与 Result 的选用边界
- thiserror 定义强类型错误枚举
- 启动阶段显式 Panic 断言
- anyhow 顶层错误聚合与上下文附加

## 3. 测试策略
- #[cfg(test)] 内联单元测试
- 文档测试（Doc Tests）保证 API 与文档同步
- mockall 模拟外部依赖
- 独立集成测试 Crate

## 4. 异步与并发
- spawn_blocking 处理同步阻塞操作
- 互斥原语选择指南（std::sync::Mutex vs tokio::sync::Mutex vs RwLock vs DashMap）
- Send + Sync + 'static 并发安全结构
- CancellationToken 优雅关闭

## 5. 生命周期与所有权
- 用 Arc/String 替代生命周期参数
- Cow 实现写时拷贝优化
- &str 与 String 的选择场景

## 6. Trait 与设计模式
- Newtype 模式强化类型安全
- impl Trait 静态依赖注入
- AsRef/Deref 实现智能指针
- PhantomData 编译期类型状态机

## 7. 配置管理与环境差异
- serde 类型安全配置解析
- figment 多环境配置中心
- 条件编译注入测试配置

## 8. 持续集成与工具链
- workspace.lints 统一代码守卫
- cargo deny 依赖许可审查
- vergen 编译元数据注入
- cargo-llvm-cov 覆盖率门限

## 9. Web 前端与 WASM 集成
- wasm-bindgen 双端交互
- 2026 前端框架选型（Leptos/Dioxus/Yew）
- wasm-bindgen-futures 异步浏览器 API
- 多端同构共享 core Crate
- wasm-bindgen-test 无头浏览器测试

## 附录：常见陷阱
- UTF-8 字符切片 Panic
- tokio::select! 取消安全性陷阱
- 泛型单态化代码膨胀
