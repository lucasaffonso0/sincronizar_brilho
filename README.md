# Sincronização de Brilho entre Monitores

Este projeto é um serviço que ajusta automaticamente o brilho do segundo monitor com base no brilho do monitor principal (notebook). Ele utiliza o `systemd` para garantir que o script seja executado após o reinício do sistema, garantindo que o brilho do segundo monitor sempre acompanhe o brilho do notebook.

## Funcionalidade

- **Sincronização de Brilho**: O script monitora as alterações no brilho do notebook e ajusta automaticamente o brilho do segundo monitor (se conectado).
- **Uso do systemd**: O serviço é gerido pelo `systemd`, o que significa que ele será iniciado automaticamente após o boot e estará sempre rodando em segundo plano.
- **Suporte a múltiplos monitores**: Funciona com monitores primários (notebook) e secundários conectados ao sistema.

## Dependências

- `xrandr`: Utilizado para controlar o brilho dos monitores.
- `inotify-tools`: Usado para monitorar alterações no brilho do notebook.

## Instalação

### Passo 1: Clone o repositório

Primeiro, clone este repositório no seu computador:

```bash
git clone https://github.com/seu-usuario/sincronizacao-brilho.git
```
Acesse o diretório do projeto
```bash 
cd sincronizacao-brilho
```
### Passo 2: Execute o script de instalação

O projeto contém um script de instalação que irá instalar as dependências necessárias, copiar os arquivos para os diretórios corretos e configurar o serviço systemd.

Execute o seguinte comando para rodar o script de instalação:

```bash
sudo ./install.sh
```
O script fará o seguinte:

- Instalará as dependências xrandr e inotify-tools.
- Copiará o script sincronizar_brilho.sh para o diretório /usr/local/bin/.
- Copiará o arquivo de serviço sincronizar_brilho.service para o diretório /etc/systemd/system/.
- Habilitará e iniciará o serviço automaticamente.

### Passo 3: Verifique o status do serviço
Após a instalação, você pode verificar se o serviço está funcionando corretamente com o seguinte comando:

```bash
sudo systemctl status sincronizar_brilho.service
```
Se tudo estiver correto, o status mostrará que o serviço está ativo e em execução.

### Como Funciona
- Detecção de Monitores: O script usa xrandr para identificar o monitor principal (notebook) e o segundo monitor (se houver).
- Ajuste de Brilho: O script monitora a alteração do brilho do notebook através do inotifywait e, quando o brilho do notebook é alterado, o brilho do segundo monitor é ajustado automaticamente para acompanhar.
- Sistema systemd: O serviço é gerido pelo systemd, garantindo que o script seja executado após o reinício do sistema.
### Personalização
- __Alterar o shell no serviço__: O arquivo de serviço sincronizar_brilho.service utiliza o __shell zsh__ por padrão para executar o script ajustar_brilho.sh. Caso o seu sistema utilize outro shell, como o bash, você pode ajustar a linha ExecStart no arquivo de serviço. Para isso, edite o arquivo /etc/systemd/system/sincronizar_brilho.service e substitua o caminho do zsh pelo caminho do seu shell, por exemplo:

Para usar o bash:
```bash
ExecStart=/bin/bash /usr/local/bin/ajustar_brilho.sh
```
Ou, se você estiver usando outro shell, altere conforme necessário.

- Se você precisar ajustar o usuário que executa o serviço, edite o arquivo sincronizar_brilho.service e altere o valor da linha User=lucas para o seu usuário.
- O serviço pode ser modificado para monitorar múltiplos monitores secundários, se necessário.

# Contribuições
Se você tiver sugestões ou correções para melhorar o projeto, fique à vontade para criar uma issue ou enviar um pull request! As contribuições são sempre bem-vindas.