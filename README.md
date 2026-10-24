# 灯光设计与演示文稿工作区

用于个人照明提案、酒店与住宅方案汇报，以及可编辑 PowerPoint 的制作规范。

## 四个上游 Skill

| Skill | 上游来源 | 主要用途 | 输出 |
| --- | --- | --- | --- |
| PPT Master | https://github.com/hugohe3/ppt-master | 原生可编辑 PowerPoint | .pptx |
| guizang-ppt-skill | https://github.com/op7418/guizang-ppt-skill | 中文网页演讲、杂志与瑞士风格 | HTML |
| Frontend Slides | https://github.com/zarazhangrui/frontend-slides | 风格预览、网页幻灯片 | HTML |
| Humanize PPT | https://github.com/LearnPrompt/humanize-ppt | 原始材料整理、演讲结构与质量检查 | 制作简报与检查报告 |

这些 Skill 不是同一种渲染器。客户交付默认选择可编辑 .pptx；网页演讲仅在明确需要时使用。

## 安装

在自己的 Windows PowerShell 中下载本库，然后运行：

```powershell
.\scripts\install-skills.ps1
```

脚本会从上述上游仓库完整下载，检查 SKILL.md，并安装到当前用户的 Codex skills 目录。已有同名技能会跳过，不覆盖。若网络或目录权限不允许，脚本会停止并显示失败，不会报告安装成功。

安装后在下一轮任务检查是否可调用。运行依赖以各上游说明为准；复制 Skill 文件不等于安装了 Python、Node 或图像服务等运行依赖。

**当前状态：仓库已准备安装脚本，尚未在本机联网执行安装。**

## 工作规范

见 [PPT 制作规范](docs/presentation-workflow.md)。

公开仓库只保存通用规范与工具入口。客户 PDF、施工图、报价、效果图及项目成品留在本地，不提交到本库。

上游代码不在本库复制分发。使用和再分发时遵守各上游 LICENSE。
