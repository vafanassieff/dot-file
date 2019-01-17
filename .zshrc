
export ZSH=/home/omnilink/.oh-my-zsh
ZSH_THEME="omnilink"
unsetopt inc_append_history
unsetopt share_history
source $ZSH/oh-my-zsh.sh

plugins=(
  git
)

# Env

export MAIL42=vafanass@student.42.fr
export USER42=vafanass

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH=$PATH:~/bin
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_omnilink'
export NODE_ENV="dev"
export DATA_ENV="dev"

source ~/.alias/custon_env

## Alias

alias c='clear'
alias ll='ls -la'
alias zconf='vim ~/.zshrc'
alias vconf='vim ~/.vimrc'
alias zshsource="source ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"
alias docker-ip="docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | sed 's/ \// /'"
alias docker-ls="docker container ls --format='table {{.Names}}\t{{.ID}}\t{{.Image}}'"
alias dc="docker-compose"

# Stupid Alias

alias vin="vim"

source ~/.alias/ssh_gcp

## Functions

my-ip() {
  curl http://www.ip-api.com/json/ | jq
}

traefik-pwd() {
  htpasswd -nb $1 $2 | sed -e s/\\$/\\$\\$/g
}

dayms() {
  date -r $(($1 / 1000))
  }

dayus() {
  date -r $(($1 / 1000000))
  }

day() {
  date -r $1
}

refresh-gcp () {
	rm -f ~/.gcp.tmp
	gcloud compute instances list --format json > ~/.gcp.tmp
	COUNT=$(cat ~/.gcp.tmp | jq length)
	echo Got $COUNT Google Cloud Plateform instance

	COUNT=`expr $COUNT - 1`
	a=0
	ALL_CMD=""

	while [[ $a -le $COUNT ]]
	do
		SSH_CMD=$(cat ~/.gcp.tmp| jq --argjson a "$a" -r -c '"alias ssh-gcp_" + .[$a].name + "=!ssh afa@" + .[$a].networkInterfaces [0].accessConfigs[0].natIP + " -i ~/.ssh/id_omnilink!"' | tr ! \')
		ALL_CMD="$ALL_CMD$SSH_CMD\n"
    	a=`expr $a + 1`
	done

	echo $ALL_CMD > ~/.alias/ssh_gcp
	echo Source new gcp ssh alias
	source ~/.alias/ssh_gcp
	rm -f ~/.gcp.tmp
	echo Done √
}

docker_log_file () {
  echo "" > $(docker inspect --format='{{.LogPath}}' $1)
}
