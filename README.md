# pulsemeeter-nightly-script
Script to easily install and update the pulsemeeter nightly version. It basically maintains a cached version of the branch and updates it everytime you execute. It will also show the last 10 commits made to the nightly version.

## Available arguments

Delete the cache file (use this if it errors while getting updates). You may need to confirm the deletion of write-protected git files.

`./script.sh delete-cache`

---

Install without sudo rights.

`./script.sh no-sudo`
