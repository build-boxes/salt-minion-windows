# escape=`

FROM mcr.microsoft.com/windows/server:ltsc2025

SHELL ["C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", "-NoLogo", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

# ------------------------------------------------------------------
# 1. Set Environment Variables
# ------------------------------------------------------------------
ENV ChocolateyInstall="C:\ProgramData\chocolatey"
ENV PATH="C:\ProgramData\chocolatey\bin;C:\Program Files\Salt Project\Salt;${PATH}"

# ------------------------------------------------------------------
# 2. Install Chocolatey
# ------------------------------------------------------------------
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); `
    if (-not (Test-Path "$env:ChocolateyInstall\bin\choco.exe")) { `
        throw 'Chocolatey installation failed' `
    }

RUN C:\ProgramData\chocolatey\bin\choco.exe --version

# Open Windows Firewall Ports for Salt Communication
RUN New-NetFirewallRule -DisplayName 'Salt Master to Minion 4505' -Direction Inbound -LocalPort 4505 -Protocol TCP -Action Allow; `
    New-NetFirewallRule -DisplayName 'Salt Master to Minion 4506' -Direction Inbound -LocalPort 4506 -Protocol TCP -Action Allow

# ------------------------------------------------------------------
# 3. Install Salt Minion
# ------------------------------------------------------------------
RUN choco install saltminion -y; `
    if ($LASTEXITCODE -ne 0) { `
        throw "Salt Minion installation failed with exit code $LASTEXITCODE" `
    }

# Verify Salt installation
RUN salt-call --version; `
    salt-minion --version

# Expose Ports
EXPOSE 4505 4506

# ------------------------------------------------------------------
# Keep PowerShell as the default shell
# ------------------------------------------------------------------
CMD ["C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"]
