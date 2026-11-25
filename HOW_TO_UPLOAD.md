# 上传到 GitHub 的完整步骤（照着点就行）

本目录已经准备好全部文件，你只需要：

1. 新建仓库
2. 上传文件
3. 发一个 Release

---

## 一、新建仓库

1. 浏览器打开 https://github.com
2. 右上角 **+** → **New repository**
3. 填写：
   - **Repository name**：`factorio-instant-tools`
   - **Description**：`Instant batch destroy / copy / move with ghost preview and planning zones`
   - 选择 **Public**
   - **不要**勾选 Add a README（我们有自己的）
4. 点 **Create repository**

---

## 二、上传文件

1. 进入刚建好的仓库页面
2. 点 **Add file** → **Upload files**
3. 把 `D:\factorio-instant-tools\` 里面的**这些**拖进去：

```
README.md
LICENSE
CHANGELOG.md
instant-tools_1.0.0\        （整个文件夹）
instant-tools_1.0.0.zip     （发布包）
```

4. 下方填写提交信息：`Initial release`
5. 点 **Commit changes**

---

## 三、发 Release

1. 仓库右侧点 **Releases** → **Create a new release**
2. 填写：
   - **Choose a tag**：`v1.0.0`（选 Create new tag on publish）
   - **Release title**：`Instant Tools 1.0.0`
   - **Description**：把下面这段贴进去：

```
Instant batch destroy / copy / move for Factorio 2.1.

Features:
- Batch destroy (refunds buildings and contents)
- Batch copy (optional container contents)
- Batch move (keeps contents)
- Ghost preview + smart anchor + rotation
- Undo last move
- Map planning zones

Hotkeys: Alt+M / Alt+C / Alt+R / Alt+X / Alt+U / Alt+P / Alt+O
All rebindable in Settings -> Controls -> Mods.

Install: download the zip and put it into %APPDATA%\Factorio\mods
```

3. 在最下面的 **Attach binaries** 上传 `instant-tools_1.0.0.zip`
4. 点 **Publish release**

---

## 四、完成

别人可以在 Releases 页面直接下载 zip，放进 mods 文件夹即可使用。

## 提示

- 上传时如果 GitHub 打不开，先打开 Clash（用之前修复好的节点）。
- 以后更新版本：改 `instant-tools_1.0.0\info.json` 里的 `version`，文件夹改名，重新打包，再发一个新 Release 即可。
