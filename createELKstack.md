#Install Java JDK
sudo apt-get install -y openjdk-8-jdk

#Install wget and HTTPS support for apt
sudo apt-get install -y wget apt-transport-https

#Import the Elasticsearch Signing Key
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

#Create ELK 7.x repository
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

#Install Elasticsearch 7.0.0 
sudo apt update
sudo apt -y install elasticsearch

#Install curl command to check if Elasticsearch is running. Note that Elasticsearch listens on tcp port 9200 by default.
sudo apt -y install curl

#IN THIS STEP YOU MUST CREATE AND ATTACHE DISK FROM AZURE TO THE PATH ---> /datadrive/data
#Instructions: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal

#Create data folder for Elasticsearch data.
sudo mkdir /datadrive/data

#Copy repository Elasticsearch to new directory.
sudo cp -r /var/lib/elasticsearch /datadrive/data
chown -R elasticsearch:elasticsearch /datadrive/data

#Set basic configuration in Elasticsearch.yml
sudo sed -i "1i network.host: 127.0.0.1" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "2i node.master: true" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "3i node.data: true" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "4i http.port: 9200" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "93i xpack.security.enabled: true" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "94i #xpack.security.authc.realms.ldap.ldap1.order: 0" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "95i #xpack.security.authc.realms.ldap.ldap1.enabled: true" /etc/elasticsearch/elasticsearch.yml
sudo sed -i '96i #xpack.security.authc.realms.ldap.ldap1.url: "ldap://10.234.106.52:636"' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '97i #xpack.security.authc.realms.ldap.ldap1.bind_dn: "SAP_LDAP_User_QA@ic"' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '98i #xpack.security.authc.realms.ldap.ldap1.bind_password: "INSERT_PASSWORD_HERE"' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '99i #xpack.security.authc.realms.ldap.ldap1.user_search.base_dn: "DC=ic"' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '100i #xpack.security.authc.realms.ldap.ldap1.user_search.filter: "(sAMAccountName={0})"' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '101i #xpack.security.authc.realms.ldap.ldap1.group_search.base_dn: "OU=LH,OU=Azure,OU=Zabezpieczen,OU=Grupy,DC=ic"' /etc/elasticsearch/elasticsearch.yml
sudo sed -i '102i #xpack.security.authc.realms.ldap.ldap1.files.role_mapping: "/etc/elasticsearch/role_mapping.yml"' /etc/elasticsearch/elasticsearch.yml
sudo sed -i "s|/var/lib/elasticsearch|/datadrive/data|g" /etc/elasticsearch/elasticsearch.yml

#This step cannot be done automatically. You must enter the machine and execute this command manually.
#Create passwords for Elasticsearch users. Save all your passwords anywhere. Unfortunately you will not be able to see them later.
cd /usr/share/elasticsearch/bin/	
sudo ./elastisearch-setup-passwords interactive 

#Start Elasticsearch on system boot
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

#Install Logstash 7.0.0
sudo apt -y install logstash 

#Set basic configuration in logstash.yml
sudo sed -i '219 s/#xpack.monitoring.enabled: false/xpack.monitoring.enabled: true/g' /etc/logstash/logstash.yml 
sudo sed -i '220 s/#xpack.monitoring.elasticsearch.username/xpack.monitoring.elasticsearch.username/g' /etc/logstash/logstash.yml
sudo sed -i '221 s/#xpack.monitoring.elasticsearch.password: password/xpack.monitoring.elasticsearch.password: PASTE-PASSWORD-FOR-LOGSTASHSYSTEM/g' /etc/logstash/logstash.yml
sudo sed -i '222 s/#xpack.monitoring.elasticsearch.hosts: ["https://es1:9200", "https://es2:9200"]/xpack.monitoring.elasticsearch.hosts: ["http://localhost:9200"]/g' /etc/logstash/logstash.yml
sudo sed -i '222 s/#xpack.monitoring.collection.pipeline.details.enabled/xpack.monitoring.collection.pipeline.details.enabled/g' /etc/logstash/logstash.yml

#Start Logstash 7.0.0  on system boot
sudo systemctl enable logstash
sudo systemctl start logstash

#Install Kibana 7.0.0
sudo apt -y install kibana

#Setting the basic parameters in the Kibana configuration file
sudo sed -i "1i server.port: 5601" /etc/kibana/kibana.yml
sudo sed -i "2i server.host: 0.0.0.0" /etc/kibana/kibana.yml
sudo sed -i '3i elasticsearch.hosts: "http://localhost:9200"' /etc/kibana/kibana.yml
sudo sed -i '49 s/#elasticsearch.username/elasticsearch.username/g' /etc/kibana/kibana.yml
sudo sed -i '50 s/#elasticsearch.password: "pass"/elasticsearch.password: "PASTE-PASSWORD-FOR-KIBANA"/g' /etc/kibana/kibana.yml

#Start Kibana on system boot
sudo systemctl enable kibana
sudo systemctl start kibana

#Start APM-Server
sudo apt -y install apm-server
sudo sed -i '7 s/host: "localhost:8200"/host: "0.0.0.0:8200"/g' /etc/apm-server/apm-server.yml
sudo sed -i '283 s/#username: "elastic"/username: "elastic"/g' /etc/apm-server/apm-server.yml
sudo sed -i '284 s/#password: "changeme"/password: "elastic"/g' /etc/apm-server/apm-server.yml
sudo systemctl enable apm-server
sudo systemctl start apm-server
