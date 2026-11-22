# Coding with WSL2, VS Code and Visual Studio

**Q**: How to use VS Code on Win11 with WSL2 and Ubuntu 24.04 for ai-assited programming of asp.net 10 projects?
Give me a detailed overview, where to install which product.
Tell exactly how to manage the solution, git and docker.

## 0. Recommended architecture

Use **Windows 11 for the graphical tools** and **Ubuntu 24.04 inside WSL2 for development tools, source code, Git, .NET, and Docker commands**.

```text
Windows 11
├── Visual Studio Code
├── Windows Terminal
├── Docker Desktop
└── Browser

WSL2 / Ubuntu 24.04
├── .NET 10 SDK
├── Git
├── GitHub CLI
├── project source code
├── dotnet tools
└── Docker CLI connected to Docker Desktop
```

The important rule is:

> Open the project from WSL and use the WSL-based VS Code session. Do not keep the repository under `C:\...` or `/mnt/c/...`.

Projects stored inside the Linux filesystem, such as `/home/<user>/src`, generally have much better performance and fewer file-permission and file-watching problems than projects stored on a mounted Windows drive[[1]](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)[[2]](https://code.visualstudio.com/docs/remote/wsl).

---

## 1. Install the Windows components

### 1.1 Enable WSL2

Open **PowerShell as Administrator**:

```powershell
wsl --install
wsl --update
wsl --set-default-version 2
```

Install Ubuntu 24.04 if it was not installed automatically:

```powershell
wsl --install -d Ubuntu-24.04
```

Check the installation:

```powershell
wsl --list --verbose
```

You should see something similar to:

```text
NAME            STATE           VERSION
Ubuntu-24.04    Running         2
```

Create a normal Linux user when Ubuntu starts. Do not use `root` for daily development.

---

### 1.2 Install Visual Studio Code on Windows

Install the **Windows version** of VS Code from:

<https://code.visualstudio.com/>

During installation, enable:

- Add to PATH
- Add “Open with Code” to the context menu
- Register Code as an editor for supported file types

Do **not** install a separate Linux copy of VS Code inside Ubuntu. VS Code itself runs on Windows; its server and extensions run inside WSL.

---

### 1.3 Install the VS Code extensions

Install these in the Windows VS Code UI:

- **WSL** — Microsoft
- **C# Dev Kit** — Microsoft
- **C#** — Microsoft
- **GitHub Copilot**
- **GitHub Copilot Chat**
- **Docker** — Microsoft
- **REST Client** or **Thunder Client**, optionally
- **EditorConfig for VS Code**, optionally
- **GitLens**, optionally

When connected to WSL, VS Code will show which extensions need to be installed remotely. Install the following in the **WSL extension host**:

- C# Dev Kit
- C#
- Docker
- GitHub Copilot and Copilot Chat, if VS Code requests remote installation
- Any extension that operates on source files or invokes Linux tools

The lower-left corner should show something similar to:

```text
WSL: Ubuntu-24.04
```

If it does not, you are probably editing the project in a normal Windows session.

---

## 2. Install Docker Desktop on Windows

Install **Docker Desktop for Windows**:

<https://docs.docker.com/desktop/setup/install/windows-install/>

During installation, select the **WSL 2 backend**.

After installation:

1. Start Docker Desktop.
2. Open **Settings → General**.
3. Enable **Use the WSL 2 based engine**.
4. Open **Settings → Resources → WSL Integration**.
5. Enable integration for **Ubuntu-24.04**.

Do not install a second Docker daemon with `apt` inside Ubuntu. With Docker Desktop integration, the Linux Docker CLI communicates with Docker Desktop's engine. Installing another daemon often creates conflicting sockets, ports, and storage.

Docker's WSL documentation describes this integration model[[1]](https://docs.docker.com/desktop/features/wsl/).

Verify from Ubuntu:

```bash
docker version
docker compose version
docker run --rm hello-world
```

The normal arrangement is:

```text
Ubuntu docker CLI
        │
        ▼
Docker Desktop / WSL2 backend
        │
        ▼
Containers and images
```

Docker Desktop is installed on **Windows**, but `docker` and `docker compose` are used from the **Ubuntu terminal** and VS Code's WSL terminal.

---

## 3. Configure Ubuntu for .NET 10 development

Start Ubuntu:

```powershell
wsl -d Ubuntu-24.04
```

Then update packages:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y git curl wget unzip zip jq ca-certificates \
    build-essential openssh-client
```

### Install the .NET 10 SDK

Install the **.NET 10 SDK inside Ubuntu**, not merely the runtime:

```bash
sudo apt install -y dotnet-sdk-10.0
```

If Ubuntu cannot find that package, configure the appropriate Microsoft or Ubuntu package source according to the current Microsoft installation documentation, then repeat the command:

<https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu-install>

Avoid mixing multiple .NET installation methods. For example, do not simultaneously use Snap, a Microsoft package feed, and the `dotnet-install.sh` script unless you deliberately understand the resulting PATH and SDK-selection behavior.

Verify:

```bash
dotnet --info
dotnet --list-sdks
dotnet --list-runtimes
```

You should see a 10.0 SDK and ASP.NET Core 10 runtime.

For development, the SDK is sufficient. You do not normally need to install `aspnetcore-runtime-10.0` separately because the SDK includes the required runtime components.

---

## 4. Recommended filesystem layout

Inside Ubuntu:

```bash
mkdir -p ~/src
mkdir -p ~/work
cd ~/src
```

Use a structure such as:

```text
/home/christoph/src/
└── Acme.Product/
    ├── Acme.Product.slnx
    ├── Directory.Build.props
    ├── Directory.Packages.props
    ├── global.json
    ├── .editorconfig
    ├── .gitignore
    ├── README.md
    ├── docs/
    ├── src/
    │   ├── Acme.Product.Api/
    │   ├── Acme.Product.Application/
    │   ├── Acme.Product.Domain/
    │   └── Acme.Product.Infrastructure/
    ├── tests/
    │   ├── Acme.Product.Api.Tests/
    │   └── Acme.Product.Application.Tests/
    └── deploy/
        └── docker/
```

Access it from Windows only through VS Code Remote WSL or, when necessary, through:

```text
\\wsl$\Ubuntu-24.04\home\christoph\src
```

Do not use `/mnt/c/Users/...` as the primary location for a .NET repository.

---

# Solution management

## 5. Create or clone the solution

For a new solution:

```bash
cd ~/src
mkdir Acme.Product
cd Acme.Product

dotnet new sln -n Acme.Product
dotnet new globaljson --sdk-version 10.0.100 --roll-forward latestFeature
dotnet new gitignore
dotnet new editorconfig
```

The exact installed SDK version may differ. Check it first:

```bash
dotnet --version
```

Then create projects:

```bash
mkdir -p src tests

dotnet new webapi \
  -n Acme.Product.Api \
  -o src/Acme.Product.Api

dotnet new classlib \
  -n Acme.Product.Domain \
  -o src/Acme.Product.Domain

dotnet new classlib \
  -n Acme.Product.Application \
  -o src/Acme.Product.Application

dotnet new classlib \
  -n Acme.Product.Infrastructure \
  -o src/Acme.Product.Infrastructure

dotnet new xunit \
  -n Acme.Product.Api.Tests \
  -o tests/Acme.Product.Api.Tests
```

Add projects to the solution:

```bash
dotnet sln Acme.Product.slnx add \
  src/Acme.Product.Api/Acme.Product.Api.csproj \
  src/Acme.Product.Domain/Acme.Product.Domain.csproj \
  src/Acme.Product.Application/Acme.Product.Application.csproj \
  src/Acme.Product.Infrastructure/Acme.Product.Infrastructure.csproj \
  tests/Acme.Product.Api.Tests/Acme.Product.Api.Tests.csproj
```

Add references according to your architecture:

```bash
dotnet add src/Acme.Product.Application reference \
  src/Acme.Product.Domain

dotnet add src/Acme.Product.Infrastructure reference \
  src/Acme.Product.Application \
  src/Acme.Product.Domain

dotnet add src/Acme.Product.Api reference \
  src/Acme.Product.Application \
  src/Acme.Product.Infrastructure

dotnet add tests/Acme.Product.Api.Tests reference \
  src/Acme.Product.Api
```

For an existing repository:

```bash
cd ~/src
git clone git@github.com:OWNER/REPOSITORY.git
cd REPOSITORY
code .
```

`code .` is the preferred way to open the current WSL directory in a WSL-connected VS Code window[[1]](https://code.visualstudio.com/docs/remote/wsl-tutorial).

---

## 6. Use solution-level MSBuild files

Put common settings in `Directory.Build.props`:

```xml name=Directory.Build.props
<Project>
  <PropertyGroup>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <AnalysisLevel>latest</AnalysisLevel>
  </PropertyGroup>
</Project>
```

For central NuGet package management, create `Directory.Packages.props`:

```xml name=Directory.Packages.props
<Project>
  <PropertyGroup>
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>

  <ItemGroup>
    <!-- Add package versions here. -->
  </ItemGroup>
</Project>
```

Use:

```bash
dotnet restore
dotnet build
dotnet test
dotnet format --verify-no-changes
```

A useful daily validation sequence is:

```bash
dotnet restore
dotnet build --no-restore
dotnet test --no-build
dotnet format --verify-no-changes
```

In VS Code, open the `.slnx` or solution directory. C# Dev Kit should display the solution and projects in the Solution Explorer.

---

# Git management

## 7. Install and configure Git inside WSL

Use the Linux Git installation for repositories stored in WSL:

```bash
sudo apt install -y git gh
```

Configure identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
git config --global init.defaultBranch main
git config --global fetch.prune true
git config --global pull.rebase false
```

Check the configuration:

```bash
git config --global --list
git --version
```

Do not use Windows Git and WSL Git interchangeably on the same working tree.

---

## 8. Configure GitHub authentication

The simplest option is GitHub CLI:

```bash
gh auth login
```

Choose:

1. GitHub.com
2. SSH or HTTPS
3. Browser authentication when offered

For SSH, verify:

```bash
ssh -T git@github.com
```

Clone repositories into WSL:

```bash
cd ~/src
git clone git@github.com:OWNER/REPOSITORY.git
```

Use a branch-per-task workflow:

```bash
git switch -c feature/add-orders-api
```

Before committing:

```bash
git status
dotnet build
dotnet test
git diff
```

Commit focused changes:

```bash
git add .
git commit -m "Add orders API"
git push -u origin feature/add-orders-api
```

Then create a pull request:

```bash
gh pr create --fill
```

Useful commands:

```bash
git fetch --all --prune
git switch main
git pull --ff-only
git switch feature/my-change
git rebase main
```

Add a repository `.gitattributes` file to standardize line endings:

```gitattributes name=.gitattributes
* text=auto
*.sh text eol=lf
*.cs text eol=lf
*.csproj text eol=lf
*.json text eol=lf
*.yml text eol=lf
*.yaml text eol=lf
```

Never commit:

- `.env`
- passwords
- API keys
- certificates
- connection strings containing credentials
- `bin/`
- `obj/`
- `.vs/`
- local database files

Use `appsettings.Development.json`, user secrets, environment variables, or a local secret manager.

---

# Docker management

## 9. Development Dockerfile

A typical multi-stage ASP.NET Dockerfile is:

```dockerfile name=src/Acme.Product.Api/Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["src/Acme.Product.Api/Acme.Product.Api.csproj", "src/Acme.Product.Api/"]
COPY ["src/Acme.Product.Application/Acme.Product.Application.csproj", "src/Acme.Product.Application/"]
COPY ["src/Acme.Product.Domain/Acme.Product.Domain.csproj", "src/Acme.Product.Domain/"]
COPY ["src/Acme.Product.Infrastructure/Acme.Product.Infrastructure.csproj", "src/Acme.Product.Infrastructure/"]

RUN dotnet restore "src/Acme.Product.Api/Acme.Product.Api.csproj"

COPY . .
WORKDIR "/src/src/Acme.Product.Api"
RUN dotnet publish "Acme.Product.Api.csproj" \
    -c Release \
    -o /app/publish \
    --no-restore

FROM runtime AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Acme.Product.Api.dll"]
```

The paths assume the Docker build context is the repository root.

Create `.dockerignore`:

```text name=.dockerignore
**/bin/
**/obj/
.git/
.vscode/
.vs/
TestResults/
*.user
*.suo
.env
```

Build and run:

```bash
docker build -t acme-product-api:local .
docker run --rm -p 8080:8080 acme-product-api:local
```

Open:

```text
http://localhost:8080
```

---

## 10. Use Docker Compose for dependencies

Use Compose for services such as PostgreSQL, SQL Server, Redis, or message brokers.

```yaml name=compose.yaml
services:
  api:
    build:
      context: .
      dockerfile: src/Acme.Product.Api/Dockerfile
    ports:
      - "8080:8080"
    environment:
      ASPNETCORE_ENVIRONMENT: Development
      ConnectionStrings__Default: Host=postgres;Port=5432;Database=acme;Username=acme;Password=acme-dev-only
    depends_on:
      postgres:
        condition: service_healthy

  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: acme
      POSTGRES_USER: acme
      POSTGRES_PASSWORD: acme-dev-only
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U acme -d acme"]
      interval: 5s
      timeout: 5s
      retries: 10

volumes:
  postgres-data:
```

Commands:

```bash
docker compose up --build
docker compose up -d postgres
docker compose logs -f api
docker compose ps
docker compose down
```

To delete the development database volume:

```bash
docker compose down -v
```

Do not use `down -v` casually; it deletes persisted development data.

Inside Compose, connect to `postgres`, not `localhost`. From the host, use `localhost:5432`.

For local development, a common split is:

```text
.NET API runs directly in WSL
PostgreSQL/Redis/etc. run in Docker
```

This gives fast ASP.NET hot reload while still providing reproducible infrastructure. Run the entire stack in Docker when testing production-like behavior.

---

# AI-assisted programming

## 11. Configure GitHub Copilot

Sign in to GitHub in VS Code and install:

- GitHub Copilot
- GitHub Copilot Chat

Use Copilot for:

- explaining unfamiliar code
- generating tests
- proposing refactorings
- creating API contracts
- reviewing diffs
- writing Docker and CI configuration
- finding likely edge cases

For multi-file changes, ask it to:

1. Inspect the solution.
2. Describe the intended changes.
3. Propose a plan.
4. Modify one logical area at a time.
5. Run `dotnet build` and `dotnet test`.
6. Show the resulting diff.

Do not blindly accept agent-generated changes. Review:

- authentication and authorization
- SQL and database migrations
- input validation
- deserialization
- file access
- Docker permissions
- dependency versions
- logging of secrets or personal data

Create project instructions, for example:

```text name=.github/copilot-instructions.md
# Project instructions

- Target .NET 10 and ASP.NET Core 10.
- Use nullable reference types and implicit usings.
- Treat compiler warnings as errors.
- Keep controllers thin; put business logic in Application services.
- Put persistence code in Infrastructure.
- Add or update tests for behavior changes.
- Do not add secrets, credentials, or real connection strings.
- Run `dotnet build`, `dotnet test`, and `dotnet format --verify-no-changes`
  before considering a task complete.
- Prefer async APIs and pass CancellationToken where appropriate.
```

You can also ask Copilot Chat to generate or improve this file. Project-specific Copilot instructions and configuration are supported by VS Code and GitHub Copilot documentation[[1]](https://docs.github.com/en/copilot/how-tos/configure-personal-settings/configure-in-ide)[[2]](https://code.visualstudio.com/docs/editing/ai-powered-suggestions).

---

# Daily workflow

## 12. Start work

From Windows Terminal:

```powershell
wsl -d Ubuntu-24.04
```

Inside Ubuntu:

```bash
cd ~/src/Acme.Product
git switch main
git pull --ff-only
git switch -c feature/my-task
code .
```

In the VS Code WSL terminal:

```bash
dotnet restore
docker compose up -d postgres
dotnet watch --project src/Acme.Product.Api
```

Open the application at the URL printed by ASP.NET Core.

---

## 13. Finish work

```bash
dotnet format
dotnet build
dotnet test
git diff
git status
git add .
git commit -m "Implement my task"
git push -u origin feature/my-task
gh pr create --fill
```

Before opening the pull request, inspect the complete change:

```bash
git diff main...HEAD
```

---

## 14. Where each product should be installed

| Product            | Install location                            | Purpose                                |
| ------------------ | ------------------------------------------- | -------------------------------------- |
| Windows 11         | Windows                                     | Host operating system                  |
| WSL2               | Windows feature                             | Linux virtualization layer             |
| Ubuntu 24.04       | WSL2                                        | Development environment                |
| VS Code            | Windows                                     | Graphical editor                       |
| WSL extension      | Windows VS Code                             | Connects VS Code to Ubuntu             |
| C# Dev Kit         | WSL VS Code session                         | C# and solution support                |
| .NET 10 SDK        | Ubuntu/WSL                                  | Build and run ASP.NET projects         |
| Git                | Ubuntu/WSL                                  | Source control                         |
| GitHub CLI         | Ubuntu/WSL                                  | GitHub authentication and PRs          |
| Docker Desktop     | Windows                                     | Docker engine, GUI, images, containers |
| Docker CLI/Compose | Available through WSL integration           | Container commands                     |
| GitHub Copilot     | VS Code, including WSL session as requested | AI-assisted development                |

The resulting workflow is: **Windows hosts the UI and Docker engine; Ubuntu owns the code and development toolchain; VS Code connects the two through Remote WSL.**

## Visual Studio

Visual Studio and VS Code approach WSL differently. While VS Code uses a client-server model over the WSL IPC bridge, Visual Studio runs as a Windows host process and accesses your Ubuntu filesystem via SMB/UNC paths (`\\wsl$\` or `\\wsl.localhost\`).

---

**Method 1: Direct UNC Pathing (Recommended for Quick Opening)**

You can open the solution directly in Visual Studio using the Windows path pointing to your Ubuntu filesystem:

1. In Visual Studio, go to **File > Open > Project/Solution** (or `Ctrl + Shift + O`).
2. In the file picker's address bar, type your WSL distribution path:
   `\\wsl.localhost\Ubuntu-24.04\home\<your-username>\<path-to-your-project>`
3. Select your `.sln` or `.csproj` file and click **Open**.

_Alternative via Terminal:_ You can also launch it directly from your Ubuntu terminal in VS Code:

```bash
cmd.exe /c start devenv.exe "$(wslpath -w ./YourApp.sln)"
```

---

**Method 2: Target WSL2 for Running & Debugging**

Once the project is loaded into Visual Studio, configure it to run directly inside your Ubuntu 24.04 runtime:

1. Ensure the **.NET Core Debugging with WSL 2** component is installed in Visual Studio (via the Visual Studio Installer > _ASP.NET and web development_ workload).
2. Open your project's `launchSettings.json` file inside Visual Studio.
3. Add a `WSL` profile alongside your standard profiles:

```json
{
  "profiles": {
    "WSL": {
      "commandName": "WSL2",
      "distributionName": "Ubuntu-24.04",
      "launchBrowser": true,
      "launchUrl": "https://localhost:5001",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

4. In the top Debug target dropdown menu in Visual Studio, select **WSL** as your active target and hit **F5** to start debugging directly inside your Linux environment.

---

**Performance Tip**
Cross-OS file system calls (editing Windows files mounted at `/mnt/c/` from Linux, or vice versa) introduce disk I/O latency. Keep your project files in the Linux native file system (`/home/username/...`) for high-speed AI indexing in VS Code, and rely on Visual Studio's `\\wsl.localhost\` provider to read them seamlessly.

For a walkthrough on setting up .NET development inside WSL, watch [Build & Debug C++ on WSL 2 (Windows 11) — Visual Studio & VS Code (Step-by-Step)](https://www.youtube.com/watch?v=XnD35kvIN1U), which details configuring cross-platform workflows, target systems, and toolchains between VS Code and Visual Studio.

### Sources:

1. [Docker Desktop WSL 2 backend on Windows | Docker Docs](https://docs.docker.com/desktop/features/wsl/)
2. [Install Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)
3. [Set up a WSL development environment | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)
4. [Developing in WSL - Visual Studio Code](https://code.visualstudio.com/docs/remote/wsl)
5. [Remote development in WSL - Visual Studio Code](https://code.visualstudio.com/docs/remote/wsl-tutorial)
6. [Install .NET on Ubuntu - Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu-install)
7. [C# Dev Kit FAQ - Visual Studio Code](https://code.visualstudio.com/docs/csharp/cs-dev-kit-faq)
8. [Configuring GitHub Copilot in your environment](https://docs.github.com/en/copilot/how-tos/configure-personal-settings/configure-in-ide)
