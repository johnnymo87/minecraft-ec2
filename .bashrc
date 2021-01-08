alias cd-minecraft="cd /usr/games/minecraft"
alias minecraft="cd-minecraft && java -Xms2G -Xmx4G -jar mcserver.jar nogui"
alias backup-minecraft="cd-minecraft && MINECRAFT_BUCKET=jonathan-mohrbacher-minecraft-01 MINECRAFT_ARCHIVE_LIMIT=10 ./backup.sh world"
