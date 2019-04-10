#!/bin/bash
##############USMAN AKRAM "FA05-BTN-005" (~*Lucky*~) BTN-6########
######COMSATS INSTITUTE OF INFORMATION TECHNOLOGY - ABBOTTABAD####
echo -e "****************Welcome*************"
###############################IPTABLE SERVICES PROGRAM BEGINS HERE###############################
checkstatus()
 {
  opt_checkstatus=1
 while [ $opt_checkstatus != 7 ]
      do
       clear
  #echo -e "\nChoose the Option Bellow!!!\n
  echo -e "\n\t*****Note: Save your Iptables before stop/Restart the iptables Services*****\n"
  echo -e "   1. Save the iptables\n
   2. Status of Iptables\n
   3. Start iptables Services\n
   4. Stop iptables Services\n
   5. Restart iptable Services\n
   6. Flush iptables (**Use Carefully_it will remove all the rules from iptables**)\n
   7. Go back to Main Menu"
  read opt_checkstatus
  case $opt_checkstatus in
   1) echo -e "*******************************************************\n" 
               /etc/init.d/iptables save 
      echo -e "\n*******************************************************\n"
    echo -e "Press Enter key to Continue..."
    read temp;;
   2) echo -e "*******************************************************\n"
               /etc/init.d/iptables status 
      echo -e "*******************************************************"
                                echo -e "Press Enter key to Continue..."
                                     read temp;;
   3) echo -e "*******************************************************\n"  
               /etc/init.d/iptables start 
      echo -e "*******************************************************\n"
                                 echo -e "Press Enter key to Continue..."
                                       read temp;;
   
   4) echo -e "*******************************************************\n"
               /etc/init.d/iptables stop
      echo -e "*******************************************************\n"
                                echo -e "Press Enter key to Continue..."
                                     read temp;;
     
             5) echo -e "*******************************************************\n"
                      /etc/init.d/iptables restart 
      echo -e "*******************************************************\n"
                                echo -e "Press Enter key to Continue..."
                                     read temp;;
   6) iptables -F 
   echo -e "*******************************************************"
   echo -e "All the Rules from the Iptables are Flushed!!!"
   echo -e "*******************************************************\n"
                                echo -e "Press Enter key to Continue..."
                                 read temp;;
   7) main;;
   *) echo -e "Wrong Option Selected!!!"
  esac
 done
 }
###############################BUILD FIREWALL PROGRAM BEGINS FROM HERE############################### 
buildfirewall()
 {
  ###############Getting the Chain############
  echo -e "Using Which Chain of Filter Table?\n
  1. INPUT
  2. OUTPUT
  3. Forward"
  read opt_ch
  case $opt_ch in
   1) chain="INPUT" ;;
   2) chain="OUTPUT" ;;
   3) chain="FORWARD" ;;
   *) echo -e "Wrong Option Selected!!!"
  esac
 
  #########Getting Source IP Address##########
  #Label
   
  echo -e "
  1. Firewall using Single Source IP\n
  2. Firewall using Source Subnet\n
  3. Firewall using for All Source Networks\n"
  read opt_ip
   
  case $opt_ip in
   1) echo -e "\nPlease Enter the IP Address of the Source"
   read ip_source ;;
   2) echo -e "\nPlease Enter the Source Subnet (e.g 192.168.10.0/24)"
   read ip_source ;;
   3) ip_source="0/0" ;;
   #4) ip_source = "NULL" ;;
   *) echo -e "Wrong Option Selected"
  esac
  #########Getting Destination IP Address##########
   echo -e "
  1. Firewall using Single Destination IP\n
                2. Firewall using Destination Subnet\n
         3. Firewall using for All Destination Networks\n"
  
     read opt_ip
              case $opt_ip in
        1) echo -e "\nPlease Enter the IP Address of the Destination"
                     read ip_dest ;;
               2) echo -e "\nPlease Enter the Destination Subnet (e.g 192.168.10.0/24)"
                     read ip_dest ;;
               3) ip_dest="0/0" ;;
        #4) ip_dest = "NULL" ;;
               *) echo -e "Wrong Option Selected"
       esac
       ###############Getting the Protocol#############
       echo -e "
       1. Block All Traffic of TCP
       2. Block Specific TCP Service
       3. Block Specific Port
       4. Using no Protocol"
       read proto_ch
       case $proto_ch in
        1) proto=TCP ;;
        2) echo -e "Enter the TCP Service Name: (CAPITAL LETTERS!!!)"
       read proto ;;
        3) echo -e "Enter the Port Name: (CAPITAL LETTERS!!!)" 
       read proto ;;
        4) proto="NULL" ;;
        *) echo -e "Wrong option Selected!!!"
       esac
 
       #############What to do With Rule############# 
       echo -e "What to do with Rule?
       1. Accept the Packet
       2. Reject the Packet
       3. Drop the Packet
       4. Create Log"
       read rule_ch
       case $rule_ch in 
        1) rule="ACCEPT" ;;
        2) rule="REJECT" ;;
        3) rule="DROP" ;;
        4) rule="LOG" ;;
       esac
###################Generating the Rule####################
echo -e "\n\tPress Enter key to Generate the Complete Rule!!!"
read temp
echo -e "The Generated Rule is \n"
if [ $proto == "NULL" ]; then
 echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -j $rule\n"
 gen=1
else
 echo -e "\niptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule\n"
 gen=2
fi 
echo -e "\n\tDo you want to Enter the Above rule to the IPTABLES? Yes=1 , No=2"
read yesno
if [ $yesno == 1 ] && [ $gen == 1 ]; then
 iptables -A $chain -s $ip_source -d $ip_dest -j $rule
else if [ $yesno == 1 ] && [ $gen == 2 ]; then
 iptables -A $chain -s $ip_source -d $ip_dest -p $proto -j $rule         
   
else if [ $yesno == 2 ]; then
 
 main
fi
fi
fi
}
      
main()
{
 ROOT_UID=0
 if [ $UID == $ROOT_UID ];
 then
 clear
 opt_main=1
 while [ $opt_main != 4 ]
 do
echo -e "/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\n" 
#############Check Whether the iptables installed or not############ 
 echo -e "\t*****Main Menu*****\n
 1. Check Iptables Package\n
 2. Iptables Services\n
 3. Build Your Firewall with Iptables\n
 4. Exit"
 read opt_main
 case $opt_main in
  1) echo -e "******************************"
    rpm -q iptables 
     echo -e "******************************" ;;
  2) checkstatus ;;
  3) buildfirewall ;;
  4) exit 0 ;;
  *) echo -e "Wrong option Selected!!!"
 esac
done
else
 echo -e "You Must be the ROOT to Perfom this Task!!!"
fi
}
main
exit 