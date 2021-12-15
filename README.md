# kvm-start-stop-vm-service
Systemd  service script to start and stop vm's in a specific sequence 


I created this because I'm running ancient hardware as a firewall. The guests I run effect the network operation, so having them start in a specific sequence improves uptime.

vm's are listed in a new line separated file stored as /etc/guests.boot.order
the script reads this and attempts to start each vm sequentially.

On shutdown the service tries to shut down the vm's in a specific order, and times out after 120 seconds. You can change that if you really want to by modifiying the shell script.

Several words of warning - I know very little about shell scripting so this is an exeriment for my own use. If you want to use it, test, test, then test it again, then ask your cat to test it.
