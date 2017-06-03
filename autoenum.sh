#!/bin/bash
#########################################
# The Auto Enumeration Toolkit (AET)     #
# Written by: Ahmed Samir                #
#########################################
#
# this is tool used to automate the enumeration phase for one host or multihosts

echo "*****************************************************"
echo "*                  _       ____    ________         *"
echo "*                 / \     |  __|  |__    __|        *"
echo "*                / _ \    | |__      |  |           *"
echo "*               / /_\ \   |  __|     |  |           *"
echo "*              / _____ \  | |__      |  |           *"
echo "*              \/     \/  |____|     |__|           *"
echo "*                                                   *"
echo "* AET Auto Enumeration Toolkit Ver. 1.0             *"
echo "* used to scan open ports and services version      *"
echo "* and get the available exploits for the vulnerable *"
echo "* services in your hosts and list the directories   *"
echo "* in your web services                              *"
echo "* Coded by Ahmed Samir                              *"
echo "* Cyber Security Trainee                            *"
echo "* eng.asaar2008@gmail.com                           *"
echo "* Tel +201148444485                                 *"
echo "* Supervised by Sameh El-Hakim                      *"
echo "*****************************************************"

PS3="please choose one from the above options:"
select opt1 in "single IP address" "list of IP addresses" "exit" 
do 
case $REPLY in
1)echo "enter the project name:"
read project
echo "enter the IP address:"
read host

mkdir -p ./$project/$host #making directory for files result
mkdir -p ./$project/$host/screenshots #making directory for screenshots 
echo "*****************************************************"
echo "* The Open Ports in the remote host                 *"
echo "*****************************************************"
nmap -n -sS -p 1-32343 $host
scrot ./$project/$host/screenshots/portscan.png
nmap -n -sS -p 1-32343 $host > ./$project/$host/portscan #port scan results
nmap -n -sV -p 1-32343 $host > ./$project/$host/version #version scan results
echo "*****************************************************"
echo "* The Operating System Details                      *"
echo "*****************************************************"
nmap -n -O $host|tail -8|head -4 #operating system details
#the number of hosted web services and working port number
scrot ./$project/$host/screenshots/osdetails.png
echo "*****************************************************"
echo "* The Services Version in the remote host           *"
echo "*****************************************************"
nmap -n -sV -p 1-32343 $host -oX ./$project/$host/nmapxml #nmap output xml file format
scrot ./$project/$host/screenshots/serviceversion.png
web=`cat ./$project/$host/version |grep Apache |wc -l`
#echo "*****************************************************"
#echo "* The number of hosted web services and its ports   *"
#echo "*****************************************************"
#echo $web
scrot ./$project/$host/screenshots/web.png
echo "*****************************************************"
echo "* The available exploits for vulnerable services    *"
echo "*****************************************************"
for line1 in `cat ./$project/$host/nmapxml|tr '<' '\n'|grep cpe:|cut -d: -f 3,5|uniq`
do
service=`echo $line1 | tr ':' ' '`
screenshot=`echo $line1 | tr ':' '-'`
num=`echo $service |wc -w`
#echo $num
if [ $num -gt 1 ]
then
echo "*****************************************************"
echo "* The available exploits for $service *"
echo "*****************************************************"
searchsploit $service |uniq
fi
scrot ./$project/$host/screenshots/$screenshot.png
done

if [ $web -ge 1 ]
then 
echo "*****************************************************"
echo "* There are $web web services hosted in this host   *"
echo "*****************************************************"

#for x in `cat ./$project/$host/version|grep Apache|tr -s " "|cut -d " " -f6`
#do
#searchsploit Apache $x
#done
else 
echo "there is no web service in this host"
fi
#port number in a list to loop 
for ports in `cat ./$project/$host/version|grep Apache |cut -d / -f1`
do
echo "*****************************************************"
echo "* The web service port is: $ports                   *"
echo "*****************************************************"

echo "*****************************************************"
echo "* The Directories of the web service                *"
echo "*****************************************************"
dirb http://$host:$ports/ #list directories in the web server
scrot ./$project/$host/screenshots/directories$ports.png
echo "*****************************************************"
echo "* The Vulnerabilities of the web service            *"
echo "*****************************************************"
nikto -host http://$host/ -port $ports
scrot ./$project/$host/screenshots/webvuln$ports.png
done 

#for services in `nmap -n -sV  10.0.0.204 |tr -s " "|cut -d " " -f 4,5,6,7,8`
#do
#echo "the service version is: $services"

#done
echo "*******************************************************************"
echo "* The Enumeration results exist in ./$project/$host directory *"
echo "*******************************************************************"
;;

2)echo "enter the project name:"
read project
echo "enter the file path which contains list of IP adresses:"
read path

#nmap -n -sS -p 1-32343 -iL $path #port scan list of ips from file
#nmap -n -sV -p 1-32343 -iL $path #version scan list of ips from file
let i=0

for host in `cat $path`
do
echo $host
let i=$i+1
mkdir -p ./$project/$host #making directory for files result
mkdir ./$project/$host/screenshots #making directory for screenshots 
echo "*****************************************************"
echo "* The Open Ports in the remote host                 *"
echo "*****************************************************"
nmap -n -sS -p 1-32343 $host
scrot ./$project/$host/screenshots/portscan.png
nmap -n -sS -p 1-32343 $host > ./$project/$host/portscan #port scan results
nmap -n -sV -p 1-32343 $host > ./$project/$host/version #version scan results
echo "*****************************************************"
echo "* The Operating System Details                      *"
echo "*****************************************************"
nmap -n -O $host|tail -8|head -4 > ./$project/$host/osdetails#operating system details
#the number of hosted web services and working port number
scrot ./$project/$host/screenshots/osdetails.png
echo "*****************************************************"
echo "* The Services Version in the remote host           *"
echo "*****************************************************"
nmap -n -sV -p 1-32343 $host -oX ./$project/$host/nmapxml #nmap output xml file format
scrot ./$project/$host/screenshots/serviceversion.png
web=`cat ./$project/$host/version |grep Apache |wc -l`
#echo "*****************************************************"
#echo "* The number of hosted web services and its ports   *"
#echo "*****************************************************"
#echo $web
scrot ./$project/$host/screenshots/web.png
echo "*****************************************************"
echo "* The available exploits for vulnerable services    *"
echo "*****************************************************"
for line1 in `cat ./$project/$host/nmapxml|tr '<' '\n'|grep cpe:|cut -d: -f 3,5|uniq`
do
service=`echo $line1 | tr ':' ' '`
screenshot=`echo $line1 | tr ':' '-'`
num=`echo $service |wc -w`
#echo $num
if [ $num -gt 1 ]
then
echo "*****************************************************"
echo "* The available exploits for $service *"
echo "*****************************************************"
searchsploit $service |uniq > ./$project/$host/exploits
fi
scrot ./$project/$host/screenshots/$screenshot.png
done

if [ $web -ge 1 ]
then 
echo "*****************************************************"
echo "* There are $web web services hosted in this host   *"
echo "*****************************************************"

#for x in `cat ./$project/$host/version|grep Apache|tr -s " "|cut -d " " -f6`
#do
#searchsploit Apache $x
#done
else 
echo "there is no web service in this host"
fi
#port number in a list to loop 
for ports in `cat ./$project/$host/version|grep Apache |cut -d / -f1`
do
echo "*****************************************************"
echo "* The web service port is: $ports                   *"
echo "*****************************************************"

echo "*****************************************************"
echo "* The Directories of the web service                *"
echo "*****************************************************"
dirb http://$host:$ports/ -o ./$project/$host/directories #list directories in the web server
scrot ./$project/$host/screenshots/directories$ports.png
echo "*****************************************************"
echo "* The Vulnerabilities of the web service            *"
echo "*****************************************************"
nikto -host http://$host/ -port $ports
scrot ./$project/$host/screenshots/webvuln$ports.png
done 

#for services in `nmap -n -sV  10.0.0.204 |tr -s " "|cut -d " " -f 4,5,6,7,8`
#do
#echo "the service version is: $services"

#done
echo "*******************************************************************"
echo "* The Enumeration results exist in ./$project/$host directory *"
echo "*******************************************************************"
#echo $i
done
;;

3)exit
;;
esac
done

