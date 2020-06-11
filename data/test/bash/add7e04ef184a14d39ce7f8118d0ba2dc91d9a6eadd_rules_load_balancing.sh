#!/bin/sh
# ./add_rules_load_balancing.sh rules_load_balancing
# Ajoute une règle de load balancing

# Pointeur
load_balancing=$1

if [ $# -ne 1 ] # Vérifie qu'il y a seulement 1 argument entré
  then
  echo "Erreur : il faut entrer 1 argument."
  echo "./add_rules_load_balancing.sh rules_load_balancing "  
	sudo /bin/cat /etc/pf/load_balancing.conf
  exit 2
fi

# Vérifie s'il existe déjà
	sudo /usr/local/bin/gsed -i '/pass in log on $lan_macro from $lan_ip_macro route-to/d' /etc/pf/load_balancing.conf

# Ajoute la règle load balancing
  sudo /usr/local/bin/gsed -i '/Load_balancing/a pass in log on $lan_macro from $lan_ip_macro route-to' /etc/pf/load_balancing.conf

# Paramètre load_balancing 
	sudo /usr/local/bin/gsed -i "s/pass in log on \$lan_macro from \$lan_ip_macro route-to/pass in log on \$lan_macro from \$lan_ip_macro route-to \{ ${load_balancing} \}/g" /etc/pf/load_balancing.conf

# Teste la config pf.conf
  sudo /sbin/pfctl -nf /etc/pf.conf
  
# La variable $? contient le code retour (0 = vrai et 1 = faux)
if [ "$?" == 0 ] 
  then
# Recharge la configuration, si -nf ne renvoie pas d'errreur
  #sudo /sbin/pfctl -f /etc/pf.conf

  echo " La configuration ne contient pas d'erreur de syntaxe "
  
# Affiche les règles de load balancing
	sudo /bin/cat /etc/pf/load_balancing.conf
  exit 2
else
  echo "Error de syntaxe"
  exit 2
fi