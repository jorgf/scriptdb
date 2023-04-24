# scriptDB
## IMPORTANTE
Por enquanto, esse script só funciona para o postresql

## Motivação
Esse script foi pensado inicalmente para resolver um problema bem específico: importar arquivos de dump para o banco de dados local.
Questões: automatizar esse processo de modo que, para um único database, seria necessário executar uma única vez o script. Outro ponto, como eu uso homestead para estudar, o postgres está configurado para ser usado por ela. Assim, é necessário identificar de onde o script está sendo executado (host ou homestead) para que a configuração fique correta. Para isso eu escrevi a função ```definePort()``` que faz a verificação da máquina e define a porta de acordo. Por fim, o principal motivo desse script é estudar e praticar shell script.

## Como usar
Clone o repositório para um diretório local
```
git clone git@github.com:jorgf/scriptdb.git
```
Defina as variáveis de configuração do banco de dados:
```
################ CONFIG 
HOST=""                       # "localhost" if local database   
USER=""                       # Database user
DATABASE=""                   # Database to be created and used to import the dumps
PASSWORD=""                   # Database password
PORT=""                       # Database port
PATH_FILE="dumps/"
DEBUG="0"                     # 0=off, 1=on
COLOR="1"                     # 0=off, 1=on
```
<strong>NOTA:</strong>
- A variável PORT só precisa ser definida se:
    1. você NÃO usar homestead como padrão, nesse caso é necessário definir a porta de conexão
    2. A porta de acesso seja diferente da porta padrão (5432)

    Portanto, se seu banco de dados está na homestead, basta manter a como esta.

<strong>NOTA 2:</strong>

o DATABASE é o nome do banco de dados que você fez o dump, então use o mesmo nome (assim evita uma possível incompatibilidade no projeto). Isto é, se você fez o dump do banco "projeto_final", defina 
```
DATABASE="projeto_final"
```
### Local dos arquivos de dumps
Para que funcione normalmente, é necessário criar um diretório, com nome 'dump', no mesmo diretório do arquivo importSQL.sh. Veja que a variável ```PATH_FILE``` já está direcionando para este diretório.
```
mkdir dump
```
Mova os arquivos de dump (de um mesmo database) para o diretório criado.

Dê permissão de execução para o script 
```
chmod +x importSQL.sh
```

Para executar o script basta digitar no terminal
```
./importSQL.sh
```

## Melhorias futuras
1. Trabalhar com outros bancos de dados
2. Usar arquivos para confirguração do banco de dados
3. Adicionar módulo para fazer dump, assim o script ficaria ainda mais completo, permitindo fazer dump e importar.