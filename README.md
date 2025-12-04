# vawi.nvim

Vim Auto Windows IME (Hangul) switch for Neovim.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "seokgukim/vawi",
    config = function()
        require("vawi").setup()
    end,
}
```

## Features

- 자동으로 Normal 모드로 진입할 때 IME를 영어로 전환합니다.
- 옵션으로 Insert 모드 진입 시 이전 IME 상태를 복원합니다.
- Windows 및 WSL을 지원합니다.
- 컴파일된 바이너리와 소스 코드를 함께 제공합니다.

- Automatically switches IME to English when entering Normal mode.
- Optionally restores previous IME state when entering Insert mode.
- Supports Windows and WSL.
- Provides both compiled binaries and source code.

## Configuration

```lua
require("vawi").setup({
    -- Insert 모드를 나갈 때 자동으로 IME를 영어로 전환 (기본값: true)
    -- Automatically switch to English IME when leaving Insert mode (Default: true)
    auto_trigger = true,

    -- Insert 모드로 들어올 때 이전 IME 상태 복원 (기본값: false)
    -- Restore previous IME state when entering Insert mode (Default: false)
    keep_state = false,
})
```

## Commands

| Command                                | 설명                     | Description                                 |
| -------------------------------------- | ------------------------ | ------------------------------------------- |
| `VawiToggle`                           | IME 상태를 전환합니다    | Toggle IME state                            |
| `VawiHangul`                           | 한글 IME로 전환합니다    | Switch IME to Hangul                        |
| `VawiEnglish`                          | 영어 IME로 전환합니다    | Switch IME to English                       |
| `VawiAuto[Toggle/Enable/Disable]`      | 자동 전환 동작 변경      | Control auto-switching behavior             |
| `VawiKeepState[Toggle/Enable/Disable]` | 이전 상태 복원 동작 변경 | Control previous state restoration behavior |

## Notes

이 플러그인은 Neovim을 사용할 때 한글과 영어 IME를 전환해야 하는 **Windows** 사용자를 위해 특별히 설계되었습니다.  
**Linux** 또는 **macOS**를 사용 중인 경우, 다음과 같은 IME 전환을 위한 다른 플러그인이 있습니다:

This plugin is specifically designed for **Windows** users who need to switch between Hangul and English IME while using Neovim.  
If you are using **Linux** or **macOS**, there are other options available for IME switching, such as:

- [im-select.nvim](https://github.com/keaising/im-select.nvim)
- [im-switch.nvim](https://github.com/drop-stones/im-switch.nvim)
