---
layout: page
title: "Mac OS & Linux Users: Connecting to your EC2 Instance"
comments: true
date: 2015-06-22 18:44:36
---

##Mac OS & Linux Users, connecting to your Amazon EC2 instance at the command line is pretty easy.
###0. Find your EC2's Public DNS:
Before you can connect to your EC2 instance you first need to find its Public DNS. This essentially acts as an address for your EC2 instance so that your local computer can access it. Go to [AWS](http://aws.amazon.com/) and sign into the Console. Select EC2, and then view your running instances. On this page, click on your instance and find it's public DNS under the "Description" tab.

![PublicDNS](../img/EC2_Public_DNS.png)

###1. Open a Terminal:

**MAC Users:** Terminal is under: Applications --> Utilities
**Linux Users:** Press Ctrl + Alt + t

You will need to know the location of your **key pair** you created when you launched your instance.  Usually this will be in your "Downloads" folder, but you may want to move it elsewhere.

You will need to know what your Public DNS is for your EC2 Instance.

###2. Enter the following command into the terminal:

```
chmod 400 **/path/to/your/key/**EDAMAME.pem
```

###3. Enter the following command into the terminal:

```
ssh -i **/path/to/your/key/**EDAMAME.pem ubuntu@"your public DNS"
```
SUCCESS! You have now logged into your computer in the cloud!

###4. After the first login

After the first login to the EC2, you do not need to repeat the chmod to change permissions for the key.
Every time you start an previously-stopped EC2 instance, there will be a new Public DNS.  To connect to the EC2 after the first login, copy and paste that new Public DNS in the corresponding place below:

```
ssh -i **/path/to/your/key/**EDAMAME.pem ubuntu@"your public DNS"
```

###5. Transferring files to and from the EC2

Next we will go over how to copy a file from your personal computer to your EC2 instance using `scp`. The usage is very similar to `ssh`.
````
scp -i "/path/to/your/keyfile.pem" "path/ to/the/file/you/want/to/copy" ubuntu@"your public DNS":"/path/where/to /copy/the/file"
````
Just like with `ssh` we have to identify the keyfile using `-i` so that `scp` can connect to our EC2 instance. Then we specify two more arguments. First, we need to give the file path of the file we want to copy to our instance. Then, we specify where we are copying the file to. We give the address of the instance with `ubuntu@"yourpuclicDNS"` following by the keypath using `:"/path/where/to/copy/the/file"`. If we want to copy a file from the EC2 instance to our personal computer we just switch the second and third arguments as follows.
````
scp -i "path to your keyfile.pem" ubuntu@"your public DNS":"path to the file you want to copy" "path where to save the file on your computer"
````
Now you have the tools work with your EC2 instance!
