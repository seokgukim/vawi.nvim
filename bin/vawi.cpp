#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <imm.h>
#include <string.h>

#pragma comment(lib, "imm32.lib")

#ifndef IMC_GETCONVERSIONMODE
#define IMC_GETCONVERSIONMODE 0x0001
#endif
#ifndef IME_CMODE_HANGUL
#define IME_CMODE_HANGUL 0x0001
#endif

bool GetHangulState(HWND hwnd, bool* isHangul) {
    // Try ImmGetContext
    HIMC hImc = ImmGetContext(hwnd);
    if (hImc) {
        DWORD conv, sent;
        if (ImmGetConversionStatus(hImc, &conv, &sent)) {
            *isHangul = (conv & IME_CMODE_HANGUL) != 0;
            ImmReleaseContext(hwnd, hImc);
            return true;
        }
        ImmReleaseContext(hwnd, hImc);
    }

    // Try WM_IME_CONTROL
    HWND hIme = ImmGetDefaultIMEWnd(hwnd);
    if (hIme) {
        LRESULT conv = SendMessage(hIme, WM_IME_CONTROL, IMC_GETCONVERSIONMODE, 0);
        *isHangul = (conv & IME_CMODE_HANGUL) != 0;
        return true;
    }
    
    return false;
}

void ToggleHangulMode(HWND hwndForeground, int action) {
    if (!hwndForeground) hwndForeground = GetForegroundWindow();

    DWORD targetThreadId = GetWindowThreadProcessId(hwndForeground, NULL);
    DWORD currentThreadId = GetCurrentThreadId();
    BOOL attached = FALSE;
    
    if (targetThreadId && targetThreadId != currentThreadId) {
        attached = AttachThreadInput(currentThreadId, targetThreadId, TRUE);
    }

    // Try to get the focused window in that thread
    HWND hwndFocus = hwndForeground;
    GUITHREADINFO gti = {0};
    gti.cbSize = sizeof(GUITHREADINFO);
    if (GetGUIThreadInfo(targetThreadId, &gti)) {
        if (gti.hwndFocus) {
            hwndFocus = gti.hwndFocus;
        }
    }

    bool shouldToggle = false;

    if (action == 2) {
        shouldToggle = true;
    } else {
        bool isHangul = false;
        if (GetHangulState(hwndFocus, &isHangul)) {
            bool targetHangul = (action == 1);
            if (isHangul != targetHangul) {
                shouldToggle = true;
            }
        }
    }

    if (shouldToggle) {
        INPUT inputs[2] = {};
        
        inputs[0].type = INPUT_KEYBOARD;
        inputs[0].ki.wVk = 0x15; // VK_HANGUL
        inputs[0].ki.wScan = MapVirtualKey(0x15, 0);
        inputs[0].ki.dwFlags = 0; // Key down
        
        inputs[1].type = INPUT_KEYBOARD;
        inputs[1].ki.wVk = 0x15;
        inputs[1].ki.wScan = inputs[0].ki.wScan;
        inputs[1].ki.dwFlags = KEYEVENTF_KEYUP;
        
        SendInput(2, inputs, sizeof(INPUT));
    }

    if (attached) {
        AttachThreadInput(currentThreadId, targetThreadId, FALSE);
    }
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {
    int action = 2; // Default toggle
    
    if (lpCmdLine && *lpCmdLine) {
        char cmd[256] = {0};
        strncpy_s(cmd, sizeof(cmd), lpCmdLine, _TRUNCATE);
        _strlwr_s(cmd, sizeof(cmd));
        
        if (strstr(cmd, "off") || strstr(cmd, "en")) {
            action = 0;
        } else if (strstr(cmd, "on") || strstr(cmd, "hangul") || strstr(cmd, "kr")) {
            action = 1;
        }
    }
    
    ToggleHangulMode(GetForegroundWindow(), action);
    return 0;
}
