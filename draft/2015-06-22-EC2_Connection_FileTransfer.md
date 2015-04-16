---
layout: page
title: "Mac OS & Linux Users: Connecting to your EC2 Instance"
comments: true
date: 2014-08-12 18:44:36
---

##Mac OS & Linux Users, connecting to your Amazon EC2 instance at the command line is pretty easy.

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
ssh -i **/path/to/your/key/**EDAMAME.pem ubuntu@ec2-**UNIQUE SET OF NUMBERS**.compute-1.amazonaws.com
```
SUCCESS! You have now logged into your computer in the cloud!

###4. After the first login

After the first login to the EC2, you do not need to repeat the chmod to change permissions for the key.
Every time you start an previously-stopped EC2 instance, there will be a new Public DNS.  To connect to the EC2 after the first login, copy and paste that new Public DNS into "UNIQUE SET OF NUMBERS", open terminal, and paste:

```
ssh -i **/path/to/your/key/**EDAMAME.pem ubuntu@ec2-**UNIQUE SET OF NUMBERS**.compute-1.amazonaws.com
```

###5. Transferring files to the EC2

QP has made some great tutorials on how to transfer materials; they are available [here](http://angus.readthedocs.org/en/2014/amazon/).
