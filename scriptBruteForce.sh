#!/bin/bash

minAgo=${1:-60}
failToAlert=${2:-0}

rawLog=$(journalctl -g "pam_unix\(su:auth\): authentication failure" --since "$minAgo minutes ago")
if [[ "$rawLog" == "-- No entries --" ]]; then
 echo "Zero Brute Force Attacks over the course of $minAgo minutes"
else
mapfile -t logFailAuth < <( echo -e "$rawLog" )

declare -A bruteCount
declare -A ipRuser

for ((i=0; i<${#logFailAuth[@]}; i++))
do
 j=${logFailAuth[i]}
 jruser=$(echo "${j##*ruser=}")
 jruser=$(echo "${jruser%%rhost*}")
 
 juser=$(echo "${j##*user=}")
 
 jip=$(echo "$j" | awk '{print $4}')
 
 keyFailAuth="$jruser to $juser"
 arrFailAuth[i]=$keyFailAuth
 
 if [[ ! -v ipRuser[$keyFailAuth] ]]; then
  ipRuser[$keyFailAuth]="$jip"
 else
  if [[ "${ipRuser[$keyFailAuth]}" != *"$jip"* ]]; then
   ipRuser[$keyFailAuth]="${ipRuser[$keyFailAuth]}|$jip"
  fi
 fi
 
done


for i in "${arrFailAuth[@]}"
do

 if [[ ! -v bruteCount[$i] ]]; then
# echo "Make new key $i"
  bruteCount[$i]=1
 else
# echo "Increment value in key $i"
  ((countUpd=${bruteCount[$i]}+1))
  bruteCount[$i]=$countUpd
 fi
done

for key in "${!bruteCount[@]}"
do
 if [[ $failToAlert -le "${bruteCount[$key]}" ]]; then
  echo "|Brute Force Attack: $key |Number of failed authentication attempts: ${bruteCount[$key]} |From: ${ipRuser[$key]}"
 fi
done
fi

