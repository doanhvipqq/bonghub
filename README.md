# 🎨 Bóng X UI Library

[![Version](https://img.shields.io/badge/version-1.0.0-purple)](https://github.com/yourusername/BongX-UI-Library)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Roblox](https://img.shields.io/badge/platform-Roblox-red)](https://www.roblox.com)

> Thư viện UI cao cấp cho Roblox Script Hub - Tương thích 100% với RedzHub API

## ✨ Tính Năng

- 🎨 **3 Theme tích hợp sẵn**: Darker, Dark, Purple
- 💾 **Auto-save**: Tự động lưu cấu hình
- 🎯 **API đơn giản**: Dễ sử dụng, tương thích RedzHub
- 🌈 **Smooth animations**: Hiệu ứng mượt mà
- 📱 **Draggable UI**: Có thể kéo window
- 🎭 **200+ Icons**: Lucide icon library

## 🚀 Cài Đặt

### Sử dụng từ GitHub (Khuyến nghị)

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/BongX-UI-Library/main/BongX-UI-Library.lua"))()
```

## 📖 Hướng Dẫn Sử Dụng

### 1. Tạo Window

```lua
local Window = Library:MakeWindow({
    Title = "Bóng X Hub",
    SubTitle = "by Bóng X - Trần Đức Doanh",
    SaveFolder = "BongX_Config.json"
})
```

### 2. Tạo Tab

```lua
local MainTab = Window:MakeTab({
    Title = "Main",
    Icon = "home"
})
```

### 3. Thêm Elements

#### Section (Header)
```lua
MainTab:AddSection("Auto Farm")
```

#### Paragraph (Info Display)
```lua
local Status = MainTab:AddParagraph({
    Title = "Status",
    Content = "Ready to farm!"
})

-- Update nội dung
Status:SetDesc("Farming...")
```

#### Toggle
```lua
local AutoFarm = MainTab:AddToggle({
    Name = "Auto Farm Level",
    Description = "Tự động farm level",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

-- Set giá trị
AutoFarm:Set(true)
```

#### Dropdown
```lua
local Weapon = MainTab:AddDropdown({
    Name = "Select Weapon",
    Options = {"Melee", "Sword", "Gun", "Blox Fruit"},
    Default = "Melee",
    Callback = function(value)
        print("Selected:", value)
    end
})

-- Thay đổi giá trị
Weapon:Set("Sword")
```

#### Button
```lua
MainTab:AddButton({
    Name = "Refresh Character",
    Description = "Reset nhân vật",
    Callback = function()
        print("Button clicked!")
    end
})
```

#### Discord Invite Card
```lua
MainTab:AddDiscordInvite({
    Name = "Bóng X Hub",
    Description = "Join để nhận update!",
    Logo = "rbxassetid://YOUR_IMAGE_ID",
    Invite = "https://discord.gg/yourinvite"
})
```

## 🎨 Themes

Library hỗ trợ 3 theme:

1. **Darker** (Default) - Tối đậm, Purple accent
2. **Dark** - Tối vừa, Blue accent  
3. **Purple** - Purple themed

## 📂 Cấu Trúc Project

```
BongX-UI-Library/
├── BongX-UI-Library.lua    # Main library file
├── README.md               # Tài liệu
└── examples/
    └── demo.lua           # File demo
```

## 🔄 Workflow Upload lên GitHub

### Bước 1: Upload File

1. Tạo repository mới trên GitHub: `BongX-UI-Library`
2. Upload file `BongX-UI-Library.lua`
3. Upload file `README.md` này
4. Commit với message: "Initial release v1.0.0"

### Bước 2: Lấy Raw URL

Sau khi upload, GitHub sẽ cung cấp Raw URL:
```
https://raw.githubusercontent.com/YOURUSERNAME/BongX-UI-Library/main/BongX-UI-Library.lua
```

### Bước 3: Thay URL trong GRAVITY-SKIDDED-OLD-BACKUP.txt

Tìm dòng (line 2209):
```lua
L_1_[16] = loadstring(game:HttpGet(L_1_[2]({
    "https://raw.githubus",
    "ercontent.com/TBoyRo";
    "blox727/Ui/refs/head";
    "s/main/UiRedzHub.lua"
})))()
```

Thay bằng:
```lua
L_1_[16] = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/BongX-UI-Library/main/BongX-UI-Library.lua"))()
```

## 🎯 API Reference

### Window Methods

| Method | Parameters | Description |
|--------|-----------|-------------|
| `MakeTab()` | `{Title, Icon}` | Tạo tab mới |
| `Minimize()` | `boolean` | Minimize/Maximize window |

### Tab Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `AddSection()` | `string` | `Section` | Thêm section header |
| `AddParagraph()` | `{Title, Content}` | `Paragraph` | Thêm text display |
| `AddToggle()` | `{Name, Default, Callback}` | `Toggle` | Thêm toggle button |
| `AddDropdown()` | `{Name, Options, Default, Callback}` | `Dropdown` | Thêm dropdown menu |
| `AddButton()` | `{Name, Callback}` | `Button` | Thêm button |
| `AddDiscordInvite()` | `{Name, Logo, Invite}` | `Frame` | Thêm Discord card |

### Element Methods

#### Paragraph
- `SetTitle(string)` - Đổi title
- `SetDesc(string)` - Đổi description
- `Set(title, desc)` - Đổi cả 2
- `Destroy()` - Xóa element

#### Toggle
- `Set(boolean)` - Set trạng thái
- `Destroy()` - Xóa element

#### Dropdown
- `Set(string)` - Chọn option
- `Refresh(table)` - Update options list
- `Destroy()` - Xóa element

## 🛠️ Tương Thích

- ✅ **Executor**: Synapse X, Script-Ware, Fluxus, Delta
- ✅ **Game**: Blox Fruits, Any Roblox game
- ✅ **Platform**: PC, Mobile (limited)

## 📝 Changelog

### v1.0.0 (18/01/2026)
- 🎉 Initial release
- ✨ 3 themes tích hợp
- 🎨 Full RedzHub API compatibility
- 📱 Telegram: @doanhvip1

## 👑 Credit

- **Developer**: Bóng X - Trần Đức Doanh
- **Telegram**: [@doanhvip1](https://t.me/doanhvip1)
- **Inspired by**: RedzHub UI Library

## 📄 License

MIT License - Tự do sử dụng và chỉnh sửa

## 💎 Support

Nếu bạn thích project này:
- ⭐ Star repo trên GitHub
- 📱 Join [Telegram](https://t.me/doanhvip1) để nhận update
- 🐛 Report bugs qua Issues

---

**Made with 💜 by Bóng X - Trần Đức Doanh**
