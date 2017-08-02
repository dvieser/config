#source ~/.profile
alias be='bundle exec'
alias gpb="git rev-parse --abbrev-ref HEAD | xargs git push origin"
alias gpull="git rev-parse --abbrev-ref HEAD | xargs git pull origin"
alias gpom="git pull origin master"
alias gpum="git pull upstream master"
alias gs="git status"
alias railss="unicorn -p 3000 -c config/unicorn.rb"
alias git_cleanup="git fetch --prune ; git branch --merged | grep -vE 'master|dev' | grep -v '^*' | xargs git branch -d"
alias git_releasenotes="git log master..dev --format=%s | grep -v -i ^Merge"
alias webserver="python -m SimpleHTTPServer $portnum > /tmp/web-server.log 2>&1 &"
alias sfdxopen="sfdx force:org:open -u DevHub"

#export PS1='\w$(parse_git_branch) > '

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

#if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
#  GIT_PROMPT_THEME=Single_line
#  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
#fi

#if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
#fi

# git tab completion (homebrew)
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
    . `brew --prefix`/etc/bash_completion.d/git-completion.bash
    export PS1='$(__git_ps1) \W\$ '
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

function parse_git_branch {
  local ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    echo : `expr "$ref" : 'refs/heads/\(.*\)'`
  fi
}

function gbacp {
git co -b $1
git add .
git commit -m "$2"
gpb
}
