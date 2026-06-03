WSL stops after the last console is closed. To keep it long live, you need the following Powershell script.\
```powershell
Start-Process wsl -ArgumentList "-d Debian --exec sleep infinity" -WindowStyle Hidden
```

You can add it to the scheduler or run it on demand.
