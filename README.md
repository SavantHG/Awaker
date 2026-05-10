# Awaker

Awaker is a lightweight Windows utility that helps keep your work PC awake during long-running tasks, downloads, meetings, or other periods when you need the machine to remain active.

## What It Does

Awaker runs a small background VBScript that periodically toggles Scroll Lock to simulate activity. You can choose an end time, and the tool will stop automatically when that time is reached.

## Files

- `controller.vbs` - Starts or disables Awaker and asks for the end time.
- `worker.vbs` - Runs silently in the background and keeps the PC active.
- `state.txt` - Stores whether Awaker is enabled and the configured end time.

## Requirements

- Windows
- Windows Script Host enabled

## Usage

1. Keep all files in the same folder.
2. Double-click `controller.vbs`.
3. Choose **Yes** when asked whether to enable the script.
4. Enter the end time in `HH:MM` 24-hour format, for example:

   ```text
   18:30
   ```

5. Awaker will run silently in the background until the configured end time.

To disable Awaker, run `controller.vbs` again and choose **No**.

## Configuration

The current state is stored in `state.txt`:

```text
ENABLED=True
END_TIME=18:30
```

You can edit this file manually if needed, but using `controller.vbs` is recommended.

## Notes

- Awaker uses Scroll Lock key toggling, so the Scroll Lock indicator may briefly change.
- The tool is intended for keeping your own PC awake while you are actively responsible for the session.
- If `state.txt` is missing, `worker.vbs` recreates it with default settings.
