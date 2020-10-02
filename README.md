# Secure User Creation
Creating a local user on Desktops on an enterprise network with Active Directory. There are two modules in this script - 

#Secure Password Generator
That generates a 256-bit key and encrypts the password and stores the key and the encrypted on a shared drive on a NAS.
#Secure user creation and auditing
This module is added in the Group Policy, with necessary WMI filters, and creates a user on all the workstations in the organization and simultaneously creates a CSV file on a shared path and keeps updating it with the Local Users and their attributes for auditing.

