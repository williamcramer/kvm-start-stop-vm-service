# kvm-start-stop-vm-service
Systemd  service script to start and stop vm's in a specific sequence 

I created this because I'm running ancient hardware as a firewall. The guests I run effect the network operation, so having them start in a specific sequence improves uptime. When they all start together, my disks get thrashed, so this was an attempt to slow start up and sequence based on what I want to come up 1st.

All your guests should be set to manual started, or they will just autostart together and this service will do nothing.

vm's are listed in a new line separated file stored as /etc/guests.boot.order
These should be stored as virsh sees them.
The script reads the file and attempts to start each vm sequentially after the system reaches a specific point in the boot process.
It waits until the vm's are active, then kicks off the next in sequence.

On shutdown the service tries to shut down the vm's in a specific order, times out after a number of seconds and destroys the vm. You can change the time out by modifiying the shell script.

Several words of warning - I know very little about Linux, shell scripting, services or cats so this is an exeriment for my own use. If you rely on it, test, test, then test it again, then ask your cat to test it.
