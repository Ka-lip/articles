Set the following command as the command line for the WSL profile, so that you don't suffer from shutting down WSL after you close the last WSL terminal.
```cmd
wsl --distribution-id {cc16587a-e98b-4db0-8160-13528336506e} --exec bash -c "dbus-launch true & exec bash"
```
