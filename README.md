# minecraft-ec2
This a collection of scripts that I use on my minecraft EC2.

## The EC2 instance
I run my minecraft server on [a t2.medium EC2](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#InstanceDetails:instanceId=i-04ad35287a24f3ddf). It has port 22 open for ssh and port 25565 open for accepting minecraft traffic. I use IP-whitelisting to control who can access it.

I use my `~/.ssh/minecraft.pem` to authenticate when sshing in, e.g.
```sh
ssh -i ~/.ssh/minecraft.pem ubuntu@3.90.250.152
```

#### How to copy files from my machine to the EC2
To copy files from my local machine to the EC2, I use `scp` like so from my local machine:

```sh
scp -i ~/.ssh/minecraft.pem ./backup.sh ubuntu@ec2-3-90-250-152.compute-1.amazonaws.com:/usr/games/minecraft/1.18/01/backup.sh
```

#### The file structure
I append the `.bashrc` from here to the `.bashrc` in the EC2. I install minecraft in the following directory structure:
▾ /usr
  ▾ /games
    ▾ /minecraft
      ▾ 1.17/
        ▾ 01/
          ...
      ▾ 1.18/
        ▾ 01/
          ...

Inside `/usr/games/minecraft`, the first level of directories is the minecraft server version. The second is the ordinal number of the world, starting at 01.

In each world folder ...
* I copy `backup.sh` from my machine to the EC2.
* I find the URL to the server version I want at https://mcversions.net/, and I download it.
  sh
  ```
  wget https://launcher.mojang.com/v1/objects/3cf24a8694aca6267883b17d934efacc5e44440d/server.jar
  ```

#### Updating Java
Newer versions of the minecraft server use newer versions of Java, and so I need to upgrade Java on the EC2 from time to time. I use [sdkman](https://sdkman.io) to do this.

* Install sdkman (only needs to be done once).
  ```sh
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  ```
* Install an up-to-date version of java. I use OpenJDK, and use https://jdk.java.net to find which one that would be.
  ```sh
  sdk install java x.y.z-open
  ```

## The S3 bucket
I use `backup.sh` to back up saves of my world to [an S3 bucket named `jonathan-mohrbacher-minecraft-01`](https://console.aws.amazon.com/s3/buckets/jonathan-mohrbacher-minecraft-01?region=us-east-1&tab=objects). The bucket has the following directory structure:
```
▾ 1.17/
  ▾ 01/
    world-some-timestamp.zip
▾ 1.18/
  ▾ 01/
    world-some-other-timestamp.zip
```

## Running Minecraft
I use the following aliases (from `.bashrc`):
```sh
alias cd-minecraft="cd /usr/games/minecraft/1.18/01"
alias minecraft="cd-minecraft && java -Xms3G -Xmx3G -jar server.jar nogui"
alias backup-minecraft="cd-minecraft && BUCKET_PATH=jonathan-mohrbacher-minecraft-01/1.18/01 ARCHIVE_LIMIT=10 ./backup.sh world"
```
I use `minecraft` to run the game, and `backup-minecraft` to back it up to my S3 bucket.

The `-Xms` flag controls how much memory the game can use when booting, and the `-Xmx` flag controls how much it can use while running. See [this wiki page](https://minecraft.fandom.com/wiki/Tutorials/Setting_up_a_server) for more details. [This article](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/) explains more. A key point: since the t2.medium has 4G memory, I shouldn't use more than 3G for the game.

## Settings
Once the world has booted once, the server creates a bunch of files in the directory it's in. I edit them in place.

#### server.properties
I often change/add certain properties like so:
```
game-mode=creative
level-seed=<whatever level seed looks interesting>
difficulty=peaceful
white-list=true
enforce-whitelist=true
```

#### ops.json
I created an `ops.json` file to give Livia and myself the ability to use commands, (e.g. [disabling the day night cycle](https://www.digminecraft.com/game_commands/stop_time.php)), and to whitelist our accounts (ops are automatically whitelisted). The `level` attribute refers to [permissions](https://minecraft.fandom.com/wiki/Permission_level).
```json
[
  {
    "uuid": "a767fb0d-6a04-4eb9-ab82-ca7082bd3d8a",
    "name": "LiviaLou",
    "level": 4,
    "bypassesPlayerLimit": false
  },
  {
    "uuid": "6f26e739-2eed-44fd-b76a-8dfeec9a75ec",
    "name": "johnnymo87",
    "level": 4,
    "bypassesPlayerLimit": false
  }
]
```
