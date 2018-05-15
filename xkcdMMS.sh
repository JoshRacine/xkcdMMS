#!/bin/bash

# List of phone numbers to send to, sepereted by commas, be sure to use one of the gateways below for the proper carrier.
textlist="2221115555@vzwpix.com,7775559999@pm.sprint.com"

# Location to store the count for the most recent xkcd
counterFile="/var/counters/xkcd"

######## cell email gateways ########
# Project-Fi: number@msg.fi.google.com
# AT&T: number@txt.att.net
# T-Mobile: number@tmomail.net
# Verizon: number@vzwpix.com
# Sprint: number@messaging.sprintpcs.com or number@pm.sprint.com
# Virgin Mobile: number@vmobl.com
# Tracfone: number@mmst5.tracfone.com
# Metro PCS: number@mymetropcs.com
# Boost Mobile: number@myboostmobile.com
# Cricket: number@sms.mycricket.com
# Nextel: number@messaging.nextel.com
# Alltel: number@message.alltel.com
# Ptel: number@ptel.com
# Suncom: number@tms.suncom.com
# Qwest: number@qwestmp.com
# U.S. Cellular: number@email.uscc.net
#####################################

# Parse out Json
json=$(curl -s https://xkcd.com/info.0.json | python -m json.tool);
url=$(echo "${json}" | grep '"img":' | cut -c 13- | sed 's/...$//');
altText=$(echo "${json}" | grep '"alt":' | cut -c 13- | sed 's/...$//' | sed 's/\\\"/\"/g');
basename=$(echo $url | sed 's/.*xkcd.com\/comics\///')
number=$(echo "${json}" | grep '"num":' | cut -c 12- | sed 's/..$//');

if [[ "$number" -gt "$(cat $counterFile)" ]]; then
  curl -s -o $basename $url
  echo "$altText" | mail -a $basename $textlist
  rm -f $basename
  echo $number > /var/counters/xkcd
fi
