#!/bin/bash

# Color codes for display
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (reset)

# Display active screen sessions
display_screen_list() {
clear
echo -e "${BLUE}==============================="
echo -e " Active Screen Sessions"
echo -e "===============================${NC}"

screen -ls | grep -v "Sockets" | awk -v green="$GREEN" -v white="$WHITE" '
NR>1 { printf("%s%s. %s%s\n", white, NR-1, green, $1) }'

echo -e "${BLUE}===============================${NC}"
}

# Open selected screen session
open_screen() {
local session=$(screen -ls | grep -v "Sockets" | awk -v n=$1 'NR==n+1 { print $1 }')

if [ -z "$session" ]; then
echo -e "${RED}Invalid screen number!${NC}"
else
echo -e "${YELLOW}Opening session: ${GREEN}$session${NC}"
screen -r $session
fi
}

# Kill selected screen session
kill_screen() {
local session=$(screen -ls | grep -v "Sockets" | awk -v n=$1 'NR==n+1 { print $1 }')

if [ -z "$session" ]; then
echo -e "${RED}Invalid screen number!${NC}"
else
echo -e "${YELLOW}Killing session: ${GREEN}$session${NC}"
screen -S $session -X quit
fi
}

# Create a new screen session  
create_screen() {  
  read -p "Enter a name for the new screen session: " session_name  
  screen -S $session_name -d -m  
  echo -e "${GREEN}New screen session created: $session_name${NC}"  
}  

# Display menu options  
display_menu() {  
  echo -e "${YELLOW}Options:${NC}"  
  echo -e "1. ${WHITE}Open screen${NC}"  
  echo -e "2. ${WHITE}Kill screen${NC}"  
  echo -e "3. ${WHITE}Create new screen${NC}"  
  echo -e "4. ${WHITE}Exit${NC}"  
}  
  
# Main loop  
while true; do  
  display_screen_list  
  display_menu  
  
  read -p "Choose an option [1-4]: " choice  
  
  case "$choice" in  
   1) read -p "Enter screen number to open: " number  
     open_screen $number  
     ;;  
   2) read -p "Enter screen number to kill: " number  
     kill_screen $number  
     ;;  
   3) create_screen  
     ;;  
   4) echo -e "${GREEN}Exiting. Thank you!${NC}"  
     log_activity "Script exited by user."  
     exit 0  
     ;;  
   *) echo -e "${RED}Invalid option!${NC}" ;;  
  esac  
  
  clear  
done
