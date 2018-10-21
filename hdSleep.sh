# Este script verifica se o HD está sendo utilizado (leitura ou escrita) para poder colocá-lo
# em modo sleep (como se fosse stand by).

# CUIDADO! A LOCALIZAÇÃO ATÉ DOS COMENTÁRIOS PODE FALHAR O CÓDIGO!
# A quantidade de espaços, principalmente com caracter '=', pode mudar a função da instrução.s

# Exemplo uso comando grep: grep -i "hd" VerificaUsoHd.sh 

# 'dstat -D sda' exibe o uso do HD per meio de uma tabela com algumas outras informações.
# É preciso verificar se o HD é REALMENTE a unidade montada em SDA na tabela de partições. Se não for, subtitua pela devida (SDB, SDC, etc).
sudo timeout 10 dstat -D sda > auxTemp.txt

# O comando TIMEOUT acima aguarda até que o comando dstat acima envie leituras fidedignas do uso da unidade


# sudo sleep 5 #NAO USADO


#Aqui eu queria pegar somente as linhas em que não houve ação do Hd, mas esta seção não é mais útil na atual lógica.
stringOciosa="VAZIO"
sudo grep -E [0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:print:]][[:space:]]+[0][[:space:]]+[0] auxTemp.txt > saidaGrepOcioso.txt
stringOciosa=$(cat saidaGrepOcioso.txt)
#echo 'string ociosa eh: '$stringOciosa



# contagemStringAtivaEmLeitura é uma variável que identifica quantas linhas de leitura ocorrendo no Hd foram identificadas. 
# contagemStringAtivaEmEscrita é uma variável que identifica quantas linhas de escrita ocorrendo no Hd foram identificadas.
# As variáveis acima descritas são preenchidas sob o parâmetro '-c' do comando grep. Isto é, elas recebem apenas a QUANTIDADE de linhas combinando com a sequência.
contagemStringAtivaEmLeitura=3
contagemStringAtivaEmEscrita=3
stringAtiva=$(sudo grep -E [0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:print:]][[:space:]]+[1-9]*[0-9]*[a-zA-Z]*[[:space:]]+[1-9]+[0-9]*[a-zA-Z]* auxTemp.txt)
contagemStringAtivaEmLeitura=$(sudo grep -Ec [0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:print:]][[:space:]]+[1-9]+[0-9]*[a-zA-Z]*[[:space:]]+[1-9]*[0-9]*[a-zA-Z]* auxTemp.txt)
contagemStringAtivaEmEscrita=$(sudo grep -Ec [0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:space:]]+[0-9]+[[:print:]][[:space:]]+[1-9]*[0-9]*[a-zA-Z]*[[:space:]]+[1-9]+[0-9]*[a-zA-Z]* auxTemp.txt)
#echo 'string ativa eh: '$stringAtiva



# Em scripts shell, há diferença no 'if' para comparação de strings e a comparação de inteiros. A lógica OU booleana abaixo é parao comparador Greater Than.
# Se o HD está sendo utilizado, não interrompa. Caso contrario, desligue-o.
if [ $contagemStringAtivaEmLeitura -gt 2 -o $contagemStringAtivaEmEscrita -gt 2 ] 
then
	# echo 'Entrou no IF true. String ociosa eh: '$stringOciosa
	# echo 'Entrou no IF true. String ativa eh: '$stringAtiva
	stringOciosa=$stringOciosa
else
	sudo hdparm -Y /dev/sda
	# echo 'Entrou no IF false. String ociosa eh: '$stringOciosa
	# echo 'Entrou no IF false. String ativa eh: '$stringAtiva
fi
