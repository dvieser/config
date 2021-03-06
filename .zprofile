#source ~/.profile
export PATH="$PATH:/usr/local/apache-ant-1.9.14/bin"

function parse_git_branch {
  local ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    echo `expr "$ref" : 'refs/heads/\(.*\)'`
  fi
}

function gbacp {
git co -b $1
git add .
git commit -m "$2"
gpb
}

alias be='bundle exec'
alias gpb="git rev-parse --abbrev-ref HEAD | xargs git push origin"
alias gpull="git rev-parse --abbrev-ref HEAD | xargs git pull origin"
alias gpom="git pull origin master"
alias gpod="git pull origin dev"
alias gpum="git pull upstream master"
alias gs="git status"
alias railss="unicorn -p 3000 -c config/unicorn.rb"
alias git_cleanup="git fetch --prune ; git branch --merged | grep -vE 'master|dev' | grep -v '^*' | xargs git branch -d"
alias git_reset="git co .; git clean -d -f"
alias git_releasenotes="git log master..dev --format=%s | grep -v -i ^Merge"
alias webserver="python -m SimpleHTTPServer $portnum > /tmp/web-server.log 2>&1 &"
alias sfdxopen="sfdx force:org:open -u DevHub"
alias lastnote="git log --pretty=format:'%h' -n 1 >> ~/Desktop/lastnote"
alias git_add_witespace="git add -A; git diff --cached -w | git apply --cached -R"
alias git_pull="echo git xxx $(parse_git_branch)"

function catnotes {
    lastnotefile="/Users/dvieser/Development/Salesforce/catfinancial/ant/lastnote"
    lastnote=$(tail -1 $lastnotefile )
    echo "Notes starting from $lastnote"
    git log $lastnote..head --name-only --pretty=short |grep -v Author | grep -v ^commit |grep -v -i merge |grep -v -i conversion | grep -v package.xml | cat -s | perl -pe 's/    /\n## /g' | perl -pe 's/source/   * source/'
    echo >> $lastnotefile
    date >> $lastnotefile
    git log --pretty=format:'%h' -n 1 >> $lastnotefile
}

#source ~/Development/config/.git-prompt.sh
#export PS1='\W ($(parse_git_branch)) '
#export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
##export PS1=' \W$(__git_ps1 " (%s)")\$ '
PROMPT='%/> '

# git prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'

#if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then 
#  source /usr/local/etc/bash_completion.d/git-completion.bash
#fi 

if hash brew 2>/dev/null; then  
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
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# sfdx zsh completion
fpath=(/Users/dvieser/Development/config/salesforce-cli-zsh-completion $fpath)
autoload -U compinit
compinit
