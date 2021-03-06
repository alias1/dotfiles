#!/usr/bin/env zsh

# Import our common helper scripts
source "${ZSH}/lib/_helpers"

# gpg, git and keybase on macOS:
#   Ref (good): https://github.com/pstadler/keybase-gpg-github#optional-in-case-youre-prompted-to-enter-the-password-every-time
#   Ref (ok)  : https://gist.github.com/danieleggert/b029d44d4a54b328c0bac65d46ba4c65#setup

echo "Loading gpg-agent.."

if ! is_installed "gpg" 1> /dev/null; then
  echo "  gpg not found, skipping.."
  return 1
fi

if ! is_installed "pinentry-mac" 1> /dev/null; then
  echo "  pinentry-mac not found, skipping.."
  return 1
fi

# Ref: https://gnupg.org/documentation/manuals/gnupg-2.0/Invoking-GPG_002dAGENT.html
if [[ -S "${HOME}/.gnupg/S.gpg-agent" ]]; then
  echo "  gpg-agent already running, not starting another"
else
  # Check gpg config parses correctly (Ref: https://linux.die.net/man/1/gpg2)
  if ! gpg --gpgconf-test; then
    echo
    echo "  [ERROR] failed to parse gpg-config, not starting gpg-agent"
    return 1
  fi

  eval $(gpg-agent --daemon --enable-ssh-support)
fi
