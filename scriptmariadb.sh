# Create MariaDB server and firewall rule

# Variable block
let "randomIdentifier=$RANDOM*$RANDOM"
location="francecentral"
resourceGroup="brief7_group3"
tag="create-mariadb-server-and-firewall-rule"
server="group3-mariadb-server-$randomIdentifier"
sku="GP_Gen5_2"
login="thewarriors"
password="Azuregroup3brief7@"
# Specify appropriate IP address values for your environment
# to limit / allow access to the MariaDB server
startIp=192.168.1.4
endIp=192.168.1.5

echo "Using resource group $resourceGroup with login: $login, password: $password..."

# Create a MariaDB server in the resource group
# Name of a server maps to DNS name and is thus required to be globally unique in Azure.
echo "Creating $server in $location..."
az mariadb server create --name $server --resource-group $resourceGroup --location $location --admin-user $login --admin-password $password --sku-name $sku

# Configure a firewall rule for the server 
echo "Configuring a firewall rule for $server for the IP address range of $startIp to $endIp"
az mariadb server firewall-rule create --resource-group $resourceGroup --server $server --name AllowIps --start-ip-address $startIp --end-ip-address $endIp
