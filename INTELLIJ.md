# IntelliJ IDEA — Notes

## Installation

- Manual tarball install to `/opt/intellij/` (root-owned), not apt/snap/flatpak/Toolbox
- Launcher symlink: `/usr/local/bin/idea` → `/opt/intellij/bin/idea.sh`
- Bundled JBR runtime ships with the IDE

Steps:
1. Download `ideaIU-*.tar.gz` from JetBrains
2. `sudo tar -xzf ideaIU-*.tar.gz -C /opt` (extracts to `/opt/intellij`)
3. `sudo ln -s /opt/intellij/bin/idea.sh /usr/local/bin/idea`

## Storage Layout

| Path | Contents |
|---|---|
| `/opt/intellij/` | IDE installation |
| `~/.config/JetBrains/IntelliJIdea*/` | settings, JDKs, recent projects |
| `~/.cache/JetBrains/IntelliJIdea*/` | caches, indexes, logs |
| `~/.local/share/JetBrains/IntelliJIdea*/` | installed plugins |

## Notes

- Codeium API key stored in plaintext in `options/other.xml` — keep configs out of version control
