group=brief7_group3
az group create -g $group -l francecentral
username=thewarriors
password='Azuregroup3brief7@'

az network vnet create \
  -n thewarriors \
  -g $group \
  -l francecentral \
  --address-prefixes '192.168.0.0/16' \
  --subnet-name subnet \
  --subnet-prefixes '192.168.1.0/24'
  
az vm availability-set create \
  -n vm-as \
  -l francecentral \
  -g $group

for NUM in 1 2 
do
  az vm create \
    -n vm-group3-0$NUM \
    -g $group \
    -l francecentral \
    --size Standard_B1s \
    --image UbuntuLTS \
    --admin-username $username \
    --admin-password $password \
    --vnet-name thewarriors \
    --subnet subnet \
    --public-ip-address "" \
    --availability-set vm-as \
	  --nsg vm-nsg
done

for NUM in 1 2 
do
  az vm open-port -g $group --name vm-group3-0$NUM --port 80
done

# for NUM in 1 2 
# do
#   az vm extension set \
#     --name CustomScriptExtension \
#     --vm-name vm-group3-0$NUM \
#     -g $group \
#     --publisher Microsoft.Compute \
#     --version 1.8 \
#     --settings '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}'

# done

az network public-ip create \
    --resource-group brief7_group3 \
    --name PublicIP_group3 \
    --sku Standard \
    --zone 1 2 3

az network lb create \
    --resource-group brief7_group3 \
    --name LoadBalancer_group3 \
    --sku Standard \
    --public-ip-address PublicIP_group3 \
    --frontend-ip-name FrontEnd_group3 \
    --backend-pool-name BackEndPool_group3

az network lb probe create \
    --resource-group brief7_group3 \
    --lb-name LoadBalancer_group3 \
    --name HealthProbe_group3 \
    --protocol tcp \
    --port 80 \
    --port 22

az network lb rule create \
    --resource-group brief7_group3 \
    --lb-name LoadBalancer_group3 \
    --name HTTPRule_group3 \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name FrontEnd_group3 \
    --backend-pool-name BackEndPool_group3 \
    --probe-name HealthProbe_group3 \
    --disable-outbound-snat true \
    --idle-timeout 15 \
    --enable-tcp-reset true

az network nsg create \
    --resource-group brief7_group3 \
    --name NSG_group3

az network nsg rule create \
    --resource-group brief7_group3 \
    --nsg-name NSG_group3 \
    --name NSGRuleHTTP_group3 \
    --protocol '*' \
    --direction inbound \
    --source-address-prefix '*' \
    --source-port-range '*' \
    --destination-address-prefix '*' \
    --destination-port-range 80 \
    --access allow \
    --priority 200
