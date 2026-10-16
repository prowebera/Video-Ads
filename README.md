# Drama Story Image Ad Skill by Aby

Create drama story **image** ads: story, dialogue script, voices, characters, locations, opening frames.
This version does **not** generate video, audio songs or Suno music. It produces reviewable image frames and
prompts that you can take into your own editor or video tool.

Every project gets its own folder with its own review website (`index.html`, plain HTML/CSS/JS). You open it from
the folder, review each step there, leave comments, press **Copy all comments** and paste them into the chat. All
generating happens in the chat, with the image tool you connected.

## 1. Set up your computer

### Windows 10/11

These scripts need **Ubuntu through WSL**. They do not run directly in PowerShell or Command Prompt.

In **PowerShell as Administrator**, run:

```powershell
wsl --install -d Ubuntu
```

Restart if prompted. Open **Ubuntu**, create your Linux username and password, then run:

```bash
sudo apt update
sudo apt install -y git bash python3 jq ffmpeg curl bc
```

Run the remaining commands in **Ubuntu**. Run your agent inside WSL, or configure its shell tools to use WSL. A Windows agent using only PowerShell cannot run this workflow.

Keep the skill, project files and API key in WSL. The `~` paths below mean your **Ubuntu home folder**, not your Windows user folder. [Microsoft WSL setup guide](https://learn.microsoft.com/en-us/windows/wsl/install).

### Linux

On **Ubuntu/Debian**, run:

```bash
sudo apt update
sudo apt install -y git bash python3 jq ffmpeg curl bc
```

On other distributions, install the same tools with your package manager. Run your agent and the commands below in Bash.

### macOS

With [Homebrew](https://brew.sh/) installed, run:

```bash
brew install git python jq ffmpeg bc
```

macOS already includes Bash and curl. Run the commands below in Terminal.

## 2. Install the skill

For **Codex**, run in your macOS/Linux/Ubuntu terminal:

```bash
mkdir -p ~/.codex/skills
git clone https://github.com/abyabraham93/drama-song-creation-skill-by-aby.git ~/.codex/skills/story-image-ad
```

For **Claude Code**, use `~/.claude/skills/story-image-ad` instead and create `~/.claude/skills` first. Other agents: use their supported skills folder.

## 3. Store your kie.ai API key locally

Open `~/.bashrc` on **Linux or Windows WSL**, or `~/.zshrc` on **macOS with the default Zsh shell**. Add this line, replacing the placeholder:

```bash
export KIE_API_KEY="YOUR_KIE_AI_API_KEY"
```

If you use Bash on macOS, use `~/.bashrc`. Save the file and restart your agent. The included scripts can also load the key directly from these files.

The agent needs shell access to this environment and permission to use the local key. It runs the scripts, which send the key to kie.ai for authentication. **Never put the real key in chat, prompts or this repo.**

## 4. Start

Ask your agent: **"Use story-image-ad to create a story ad."** It makes the project folder and tells you to open the project's `index.html` in your browser.

Each step ends with a review on that page: write comments, press **Copy all comments**, paste them into the chat. The page refreshes by itself when the agent updates the project.

Images cost money. The skill asks for approval before every paid batch. See [SKILL.md](SKILL.md) for the workflow and [references/dialogue-ads.md](references/dialogue-ads.md) for dialogue ads.

This version does not generate video, audio songs or Suno music. It stops at the opening frames and prompts.
