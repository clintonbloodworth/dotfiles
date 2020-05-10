###############################################################################
# Setup
###############################################################################

if not functions -q fisher
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
  curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
  fish -c fisher
end

if status --is-interactive
  set BASE16_SHELL "$HOME/.config/base16-shell/"
  source "$BASE16_SHELL/profile_helper.fish"
end

# https://github.com/mklement0/n-install/issues/21
begin
  if not set -q N_PREFIX
    set -xU N_PREFIX "$HOME/n"
  end
  if not contains -- "$N_PREFIX/bin" $fish_user_paths
    set -U fish_user_paths "$N_PREFIX/bin" $fish_user_paths
  end
end

###############################################################################
# Globals
###############################################################################

set -x EDITOR nvim
set -x MANPAGER "less -i"
set -e FZF_ENABLE_OPEN_PREVIEW
set -U FZF_ALT_C_COMMAND "fd --type d . '$HOME'"
set -U FZF_ALT_C_WITH_HIDDEN_COMMAND "fd --hidden --type d . '$HOME'"
set -U FZF_OPEN_COMMAND "rg -l --hidden --files --no-messages --ignore-file ~/.ignore ~/"
set -U FZF_COMPLETE 3
set PATH "$HOME/.cargo/bin" $PATH
set PATH "$HOME/.gem/ruby/2.6.0/bin" $PATH
set PATH "$HOME/go/bin" $PATH
set PATH "$HOME/Library/Python/2.7/bin" $PATH
set PATH "/usr/local/opt/ruby/bin" $PATH
set PATH "/usr/local/lib/ruby/gems/2.6.0/bin" $PATH
set PATH "/usr/local/bin" $PATH # This should be in PATH by default. After upgrading Fish one day, it disappeared.

###############################################################################
# Aliases
###############################################################################

alias brewfile "$EDITOR ~/.homebrew"
alias cat "bat"
alias copy "cpy"
alias cp "cp -r"
alias diff "colordiff -w"
alias fishrc "$EDITOR ~/.config/fish/config.fish"
alias g!! "gaa && gcn!"
alias g!!! "gaa && gcn! && git push --force"
alias gau 'git add --update'
alias gaa 'git add --all'
alias gc 'git commit -v'
alias gc! 'git commit -v --amend'
alias gcn! 'git commit -v --amend --no-edit'
alias gcfg "$EDITOR $HOME/.gitconfig"
alias gcfgl "$EDITOR $HOME/.gitconfig.local"
alias gcl 'git clone --recurse-submodules'
alias gcls "git clone --depth=1"
alias gco "git checkout"
alias gcp 'git cherry-pick'
alias gcpa 'git cherry-pick --abort'
alias gcpc 'git cherry-pick --continue'
alias gdc 'git diff --cached'
alias gi "git init"
alias gignore "$EDITOR $HOME/.gitignore"
alias gl "git log --color --pretty=format:'%Cgreen%h%Creset %s %Cblue[%an]%Creset %cr' -10"
alias glf "git log --follow"
alias glol "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gm "git merge"
alias gp "git push"
alias gp! "git push --force"
alias gpl "git pull"
alias gr! "git reset --hard"
alias gr "git reset"
alias gra "git remote add origin"
alias grba "git rebase --abort"
alias grbc "git rebase --continue"
alias grbi "git rebase -i `fcs`"
alias grep "rg"
alias grv "git remote --verbose"
alias gs "git status -s"
alias gsh 'git show'
alias help "tldr"
alias hosts "sudo $EDITOR /etc/hosts"
alias ignore "$EDITOR $HOME/.ignore"
alias isup "is-up"
alias json "fx"
alias less "less -i"
alias loc "tokei -e dist -e distribution -e node_modules -e package-lock.json -e distribution -e dist"
alias ls "exa -l --group-directories-first"
alias lsa "ls -a"
alias mb "mackup backup -f"
alias mackupcfg "$EDITOR $HOME/.mackup.cfg $HOME/.mackup"
alias mkdir "mkdir -p"
alias mr "mackup restore -f"
alias ni "npm install"
alias nini "npm init -y"
alias nls "npm ls --depth=0"
alias ns "npm install --save"
alias nsd "npm install --save-dev"
alias nst "npm start"
alias nu "npm uninstall"
alias nup "npm-check -u"
alias online "is-online"
alias repeat "watch --color --differences --interval 0.1 --no-title"
alias rm "trash"
alias serve "http-server"
alias setup "$EDITOR '$HOME/iCloud/Work/Mackup/setup.sh'"
alias snippets "$EDITOR '~/Library/Application Support/Sublime Text 3/Packages/User/Snippets'"
alias dsize "du -shL"
alias src "source ~/.config/fish/config.fish"
alias sshconf "$EDITOR $HOME/.ssh/config"
alias vi "nvim"
alias vimrc "$EDITOR $HOME/.config/nvim/init.vim"
alias watch "entr -c"
alias gsize "gzip-size"

###############################################################################
# Bindings
###############################################################################

bind \ef fgrep
bind \eF fgrep_hidden
bind \eo '__fzf_open --editor'
bind yy fish_clipboard_copy
bind Y fish_clipboard_copy
bind p fish_clipboard_paste
bind yw 'commandline -f kill-word yank; fish_clipboard_copy $killring[1]'

###############################################################################
# Functions
###############################################################################

function bi
  for formula in (brew search | fzf -m)
    brew install $formula
  end
end

function bu
  for formula in (brew leaves | fzf -m)
    brew uninstall $formula
  end
end

function ci
  for formula in (brew search --casks | fzf -m)
    brew install --cask $formula
  end
end

function ciu
  for feature in (caniuse --oneline | cut -d '✔' -f 1 | fzf -m --ansi)
    caniuse $feature --long
  end
end

function cu
  for formula in (brew list --cask | fzf -m)
    brew uninstall --cask $formula
  end
end

function fbr -d "Fuzzy checkout a branch"
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function fcoc -d "Fuzzy checkout a commit"
  git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s -e | awk '{print $1;}' | read -l result; and git checkout "$result"
end

function fish_user_key_bindings
  fish_vi_key_bindings
end

function flushdns
  sudo killall -HUP mDNSResponder; sudo killall mDNSResponderHelper; sudo dscacheutil -flushcache
end

function fgrep
  if contains -- --hidden $argv[1]
    set query $argv[2]
    set hidden "--hidden"
  else
    set query $argv[1]
    set hidden "--no-hidden"
  end

  set result (rg "$query" "$hidden" --color ansi --no-heading --no-messages --ignore-file ~/.ignore --line-number --trim \
    | fzf -0 -1 --ansi --exact --delimiter=":" -n 3 )

  set file (echo $result | awk -F: '{print $1}')
  set line (echo $result | awk -F: '{print $2}')

  if test $file
    vi "$file" +"$line"
  end
end

function fgrep_hidden
  fgrep --hidden $argv[1]
end

function fssh
  rg --ignore-case '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | read -l result; and ssh "$result"
end

function mkcd
  mkdir $argv[1] && cd $argv[1]
end

function nu
  set modules (npm list -g --depth 0 --parseable 2> /dev/null | grep node_modules | sed -n -e 's/^.*node_modules\///p' | fzf -m)

  for module in $modules
    npm uninstall -g $module
  end
end

function st -d "Open Sublime Text"
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" $argv
end

function sm -d "Open Sublime Merge"
  "/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge" $argv
end

function update
  echo Homebrew
  brew update
  brew cleanup
  brew bundle --file=~/.homebrew
  brew bundle cleanup --force --file=~/.homebrew
  brew upgrade
  brew upgrade --cask

  echo Fisher
  fisher update

  echo N
  n-update -y

  echo NPM
  npm install -g npm@latest 
  npm update -g

  echo Mackup
  mackup backup -f

  echo MAS
  mas upgrade

  echo NVIM
  nvim +PlugUpgrade +PlugUpdate +qa!
end

