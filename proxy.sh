#!/bin/bash

# ------------------- just colors ---------------------------------------
yellow=`tput setaf 3`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`
# ------------------- just colors ---------------------------------------

# --------------- proxy settings ---------------------------------------
proxy_settings() {
  http_proxy=`scutil --proxy | awk '\
    /HTTPEnable/ { enabled = $3; } \
    /HTTPProxy/ { server = $3; } \
    /HTTPPort/ { port = $3; } \
    END { if (enabled == "1") { print "http://" server ":" port; } }'`

  export HTTP_PROXY="${http_proxy}"
}

proxy_default="[YOUR_DEFAULT_PROXY]"
proxy_settings
proxy=$HTTP_PROXY
# --------------- proxy settings ---------------------------------------

usage () {
  printf -- "\n---------------------------------------------------------------\n"
  printf "${cyan}Sets and unsets proxy configuration for npm, git adn apm if installed.\n"
  printf "\nusage: proxy [command]${reset}"
  printf "\ncommand is one of:"
  printf "${green}\non${reset}: sets  proxy configuration"
  printf "${green}\noff${reset}: unsets proxy configuration"
  printf "${green}\n-h${reset}: shows this help"
  printf "\nif no command is provided then the current proxy network settings are used"
  printf -- "\n---------------------------------------------------------------\n\n"
}

output_current_proxy_settings () {
  printf "${green}Current proxy settings:${reset}"
  printf -- "\n-----------------------------------------------------"
  printf "${cyan}\n- git http.proxy: %s" $(git config --global --get http.proxy)
  printf "\n- git https.proxy: %s" $(git config --global --get https.proxy)
  printf "\n- npm http.proxy: %s" $(npm config get proxy)
  printf "\n- npm https.proxy: %s" $(npm config get https-proxy)

  if [ $(which apm) ]
    then
      printf "\n- apm http.proxy: %s" $(apm config get http-proxy)
      printf "\n- apm https.proxy: %s" $(apm config get https-proxy)
  fi

  printf -- "${reset}\n-----------------------------------------------------\n\n"
}

turn_proxy_on () {
  printf -- "${green}\n... Switching on ...\n${reset}"

  # set default proxy if no network config available
  if [[ -z "$HTTP_PROXY" ]]
    then
      printf "${yellow}      No network settings for proxy found.
      Using default: %s\n${reset}" $proxy_default

      proxy=$proxy_default
  fi

  npm config set proxy $proxy
  npm config set https-proxy $proxy
  npm config set strict-ssl false

  git config --global http.proxy $proxy
  git config --global https.proxy $proxy

  if [ $(which apm) ]
    then
      apm config set http-proxy $proxy
      apm config set https-proxy $proxy
      apm config set strict-ssl false
  fi

  printf "${green}... Done \n\n${reset}"
}

turn_proxy_off () {
  printf -- "${green}\n... Switching off ...\n${reset}"
  npm config delete proxy
  npm config delete https-proxy
  npm config set strict-ssl false

  git config --global --unset http.proxy
  git config --global --unset https.proxy

  if [ $(which apm) ]
    then
      apm config delete http-proxy
      apm config delete https-proxy
      apm config set strict-ssl false
  fi

  printf "${green}... Done \n\n${reset}"
}


#-------------------- RUN -------------------------------------
case $1 in
  off )
    turn_proxy_off
    output_current_proxy_settings
    ;;
  on )
    turn_proxy_on
    output_current_proxy_settings
    ;;
  -i )
    printf "init"
    ;;
  -h | --h | -help )
    usage
    ;;
  * )
    printf "${yellow}\n... Evaluating proxy settings ... ${reset}"
    if [ $HTTP_PROXY ]
      then
      turn_proxy_on
    else
      turn_proxy_off
    fi
    output_current_proxy_settings
    ;;
esac
#-------------------------------------------------------------
