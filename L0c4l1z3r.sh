#!/bin/bash

banner() {
  echo ' #         ###          #                #           #####  '       
  echo ' #        #   #   ####  #    #  #       ##   ###### #     # #####  '
  echo ' #       #     # #    # #    #  #      # #       #        # #    # '
  echo ' #       #     # #      #    #  #        #      #    #####  #    # '
  echo ' #       #     # #      ####### #        #     #          # #####  '
  echo ' #        #   #  #    #      #  #        #    #     #     # #   #  '
  echo ' #######   ###    ####       #  ###### ##### ######  #####  #    # '
  echo ''
  echo '  _   _     _   _   _   _   _   _   _   _ '
  echo ' / \ / \   / \ / \ / \ / \ / \ / \ / \ / \'
  echo '( B | y ) ( B | l | 4 | d | s | c | 4 | n )'
  echo ' \_/ \_/   \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/'
  echo ''
  echo 'Use: ./L0c4l1z4.sh "dominio ou lista.txt"'
  echo ''
}

portas=80,443,1000-2000,8000-9999,10000-12000

# Verifica se o primeiro argumento foi fornecido
if [ -z "$1" ]; then
  banner
  echo "Nenhum argumento fornecido."
  exit 1
fi

# Verifica se o primeiro argumento é um arquivo
if [ -f "$1" ]; then
    for i in $(cat $1);do
        if nmap -sn "$i" | grep "Host is up" >/dev/null; then
            echo "Enumerando portas"
            nmap --open -sS -T4 -p "$portas" "$i" | tee portas.txt > /dev/null
            a=$(cat portas.txt | grep "/tcp" | cut -d "/" -f1 | tr '\n' ',' | sed 's/,$//')
			echo "Portas abertas:" $a
            echo "Enumerando Servidores Web"
            nmap --open -sV -sC -T4 --script http-headers,http-title,ssl-cert --script-args http.useragent="L0c4l1z3r",http-headers.useget -p "$a" "$i" | tee "$i-servidores-web.txt"
            httpx -u "$i" -title -sc -silent -ports "$a" | tee "httpx-$i-servidores-web.txt"
        else
            echo "IP inativo: $i"
        fi
    done

else
    if nmap -sn "$1" | grep "Host is up" >/dev/null; then
	    echo "Enumerando portas"
        nmap --open -sS -T4 -p"$portas" "$1" | tee portas.txt > /dev/null
        a=$(cat portas.txt | grep "/tcp" | cut -d "/" -f1 | tr '\n' ',' | sed 's/,$//')
		echo "Portas abertas:" $a
		echo "Enumerando Servidores Web"
        nmap --open -sV -sC -T4 --script http-headers--script-args http.useragent="L0c4l1z3r" -p"$portas" "$1" | tee "$1-servidores-web.txt"
        echo "Enumerando HTTPX Servidores Web"
		httpx -u "$1" -title -sc -silent -ports $a | tee "httpx-$1-servidores-web.txt"
    else
        echo "IP inativo: $1"
    fi
fi