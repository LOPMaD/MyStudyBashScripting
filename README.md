# My Scripting Studies
This repository contains my bash scripts (and possibly other languages in the future). It serves as a way to track my progress in scripting.

# scriptBruteForce.sh

**Warning:** I've only tested this script on Ubuntu, so if you want to use it on a different distribution, keep in mind it may not work correctly.

**What is this script for?**

The logic is simple: you set it up in cron to run every 15-30 minutes, and it will alert you if a Brute Force attack occurred during that time — for example, if some user tried to log in as another user and failed authentication 50 or more times within a 15-minute window. When triggered, the script shows which user attempted the login, which account they were targeting, the number of failed attempts, and the IP address it came from.

**Running the script:**

./scriptBruteForce.sh [int - number of minutes to filter] [int - number of failed attempts required to trigger an alert; defaults to 0, meaning it will show all failed attempts as brute force every time — mainly useful for testing]

**Example:**

./scriptBruteForce.sh 15 50

**Execution example:**

<img width="853" height="116" alt="image" src="https://github.com/user-attachments/assets/6b7568c2-b483-41fb-bacf-8c65c3850c22" />

**My note:**

I'm just getting started, so there's probably a much simpler way to do this, and I'm not yet a Linux master — my filter might miss some edge cases I haven't thought of.
