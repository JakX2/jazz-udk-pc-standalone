# v4.8.3: Direct compiler retry after two-minute timeout

The first v4.8.3 builder ran `UDKMobile.exe make` through PowerShell `Start-Process -PassThru -RedirectStandardOutput ...` and `WaitForExit(120000)`. On the development PC it timed out after two minutes, then reported restoring the previous JazzPC controller source and compiled `JazzPC.u`.

**The timeout is not evidence that the code failed to compile.** Review the saved logs before drawing that conclusion:

```text
C:\UDK\UDK-2010-12\_JazzPCMod\HideTouch483Backups\20261103_200754_128\Compiler_stdout.txt
C:\UDK\UDK-2010-12\_JazzPCMod\HideTouch483Backups\20261103_200754_128\Compiler_stderr.txt
```

A direct compilation test has been prepared, with a simple batch invocation rather than a waiting PowerShell subprocess. The source is unchanged from [v4.8.3](../Source/v4.8.3/JazzPCController.uc).

## Safe retry

1. Close Jazz and the UDK editor. Back up your existing controller and compiled package.
2. Extract the direct-build test package into the **full** December 2010 UDK root, with the `Tools` directory preserved.
3. Run `Stage_HideTouch_v4_8_3.cmd`. It backs up both the prior `.uc` and `.u`, installs the known v4.8.3 source and removes only the old compiled mod package to force a rebuild.
4. Run `Compile_HideTouch_v4_8_3_Direct.cmd`. It uses the previously successful `Binaries\Win32\UDKMobile.exe make -log` command in the foreground, without the PowerShell 120-second timer.
5. Check `MobileGame\Logs\Launch.log` for `JazzPC - Release` and `Success - 0 error(s), 0 warning(s)`, and confirm `MobileGame\Script\JazzPC.u` was generated.
6. On success, launch the PC test map. WASD and F9 should still work; test F10 and the `JazzTouchSticksStatus` console command.
7. If compilation or gameplay fails, close the engine and run `Restore_HideTouch_v4_8_3.cmd`.

The ZIP has passed file-integrity and source-checksum checks, but compilation **still needs a test on Windows**.

## Why this is separate from source changes

The failed installer restored the old controller, so there is no basis to change `JazzPCController.uc` to fix a timeout. Investigate runtime process behavior and compiler logs first. Do not delete any original Jazz `.mobile` or `.upk` content, or publish Epic/UDK binaries.

For transparency: the direct-build package's tools are available in the conversation attachment, not included as a distributable game on GitHub.
