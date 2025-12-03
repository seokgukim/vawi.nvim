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
- Windows 및 WSL을 지원합니다.
- 컴파일된 바이너리와 소스 코드를 함께 제공합니다.

- Automatically switches IME to English when entering Normal mode.
- Supports Windows and WSL.
- Provides both compiled binaries and source code.

## Notes

이 플러그인은 Neovim을 사용할 때 한글과 영어 IME를 전환해야 하는 **Windows** 사용자를 위해 특별히 설계되었습니다.  
**Linux** 또는 **macOS**를 사용 중인 경우, 다음과 같은 IME 전환을 위한 다른 플러그인이 있습니다:

This plugin is specifically designed for **Windows** users who need to switch between Hangul and English IME while using Neovim.  
If you are using **Linux** or **macOS**, there are other options available for IME switching, such as:

- [im-select.nvim](https://github.com/keaising/im-select.nvim)
- [im-switch.nvim](https://github.com/drop-stones/im-switch.nvim)
