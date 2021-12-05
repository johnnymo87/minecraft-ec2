alias cd-minecraft="cd /usr/games/minecraft/1.18/01"
alias minecraft="cd-minecraft && java -Xms2G -Xmx4G -jar server.jar nogui"
alias backup-minecraft="cd-minecraft && BUCKET_PATH=jonathan-mohrbacher-minecraft-01/1.18/01 ARCHIVE_LIMIT=10 ./backup.sh world"
