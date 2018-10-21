# Este script verifica se o HD está sendo utilizado (leitura ou escrita) para poder colocá-lo
# em modo sleep (como se fosse stand by).

# Exemplo uso comando grep: grep -i "hd" VerificaUsoHd.sh 

# exibe o uso do HD per meio de uma tabela com algumas outras informações.
# É preciso verificar se o HD é REALMENTE a unidade montada em SDA na tabela de partições. Se não for, subtitua pela devida (SDB, SDC, etc).
sudo timeout 5 dstat -D sda > auxTemp.txt

# O comando TIMEOUT aguarda até que o comando dstat acima envie leituras fidedignas do uso da unidade
# sudo sleep 5 #NAO USADO


stringOciosa="VAZIO"
sudo grep -E [0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:print:]][[:space:]]+[0][[:space:]]+[0] auxTemp.txt > saidaGrepOcioso.txt
stringOciosa=$(cat saidaGrepOcioso.txt)
#echo 'string ociosa eh: '$stringOciosa



stringAtiva="VAZIO"
sudo grep -E [0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:print:]][[:space:]]+[1-9]+[0-9]*[mM]*[[:space:]]+[1-9]+[0-9]*[mM]* auxTemp.txt > saidaGrepAtivo.txt
stringAtiva=$(cat saidaGrepAtivo.txt)
#echo 'string ativa eh: '$stringAtiva



# Se o HD está sendo utilizado, não interrompa. Caso contrario, desligue-o.
if [ "$stringAtiva" > "0" ]
then
	#echo 'Entrou no IF true. String ociosa eh: '$stringOciosa
	#echo 'Entrou no IF true. String ativa eh: '$stringAtiva
	stringOciosa=$stringOciosa
else
	sudo hdparm -Y /dev/sda
	#echo 'Entrou no IF false. String ociosa eh: '$stringOciosa
	#echo 'Entrou no IF false. String ativa eh: '$stringAtiva
fi
