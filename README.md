# minecraft-ec2

This a collection of scripts I use on my minecraft EC2.

#### Using scp

To copy files from the EC2 to your local machine, use `scp` like so from your local machine:

```sh
cp -i ~/.ssh/minecraft.pem ubuntu@ec2-52-71-254-110.compute-1.amazonaws.com:/home/ubuntu/.bashrc .
```
