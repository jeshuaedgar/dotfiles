# dotfiles

Personal dotfiles managed with chezmoi.

## New Mac setup checklist

- [ ] Sign in to iCloud/App Store (optional, but recommended before app installs)
- [ ] Run the first-run bootstrap script:

  ```bash
  curl -fsSL https://raw.githubusercontent.com/jeshuaedgar/dotfiles/main/scripts/bootstrap-macos.sh | bash
  ```

- [ ] If prompted, allow/install Xcode Command Line Tools (the script handles this automatically and may ask for sudo)

- [ ] Restart Terminal (or open a new shell session)
- [ ] Sign in to 1Password and enable SSH Agent if you use that workflow
- [ ] Grant macOS permissions prompted by installed apps (for example Accessibility for window manager tools)
- [ ] Re-run apply once after permissions and sign-ins:

  ```bash
  chezmoi apply --init
  ```

## Validation commands

After bootstrap, these should succeed:

```bash
chezmoi doctor
command -v brew git curl chezmoi zsh
command -v mise
ssh-add -L
```
