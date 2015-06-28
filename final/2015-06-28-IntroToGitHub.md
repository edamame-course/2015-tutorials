#How to get started with GitHub
Compiled by Ashley Shade for EDAMAME2015   
[EDAMAME-2015 wiki](https://github.com/edamame-course/2015-tutorials/wiki)

***
EDAMAME tutorials have a CC-BY [license](https://github.com/edamame-course/2015-tutorials/blob/master/LICENSE.md). _Share, adapt, and attribute please!_
***

##Overarching Goal
* This tutorial will contribute towards building **computing literacy**, specifically towards computing workflow development and version control.

##Learning Objectives
* Set up a GitHub Account
* Intialize a GitHub Account using the command line
* Pull a repository
* Basic git commands:  `pull`, `push`, `status`, `add`, `commit`
* Markdown syntax for text-to-html conversion

***
_Preamble_:  GitHub provices excellent resources, and most of this tutorial points to exisiting GitHub documentation.   

##1.  Create a GitHub [account](https://github.com).

##2.  Set up Git on your [personal computer](https://help.github.com/articles/set-up-git/)
*  Download git by clicking on the link
*  Configure git using `git config`.  Note there are separate instructions for Mac, Windows, and Linux users.
*  Authenticate with GitHub.  We suggest using [HTTPS for cloning](https://help.github.com/articles/which-remote-url-should-i-use/#cloning-with-https-recommended), and [cache-ing](https://help.github.com/articles/caching-your-github-password-in-git/) your GitHub password. Note there are separate instructions for Mac, Windows, and Linux users.

##3.  Clone a repository
*  Navigate to the EDAMAME [2015-tutorials](https://github.com/edamame-course/2015-tutorials) repository.  
* On the right hand side there is a box labeled "HTTPS clone URL."  Copy the link.
* Follow the directions from [GitHub](https://help.github.com/articles/cloning-a-repository/) to use `git clone` to clone the repo.
*  This protocol can be used to clone any public repository.  For EDAMAME repos, you can `pull` to get the most up-to-date materials from GitHub, but you cannot `push` to edit those resources and have your edits tracked to the main repository, because you are not part of the EDAMAME team.  

##4.  Basic git commands
*  There is are a few youtube video tutorials that are a good introduction to git and version control.  Here is [one](https://www.youtube.com/watch?v=0fKg7e37bQE).  We recommend that you work through the video with the instructor, pausing and starting again as needed, to get started with Git.
* All git commands start with `git`.  Git commands will only work within git repositories (you can't use them on any old directory on your computer).
 
* The sequence of adding new files / updating a repo.
  - There is a sequence that is used to add something new to a github repo.  First, you use `git status` to determine if your files on your computer are different from the files on the remote git repository.  If it is different, use `git pull` to make sure you are working with the most recent files, which will prevent conflicting edits with your team mates.
  - Then, use `git add` to add the new file to an existing repository. 
  ```
  git add FILENAME
  ```
  - Use `git commit` to stage the file for tracking. A brief message after the `-m` flag must be provided to share with users what the new update is about.  It should probably be more specific than the example below.
  ```
  git commit -m "update file"
  ```
  - Use `git push` to push your local _tracked_ changes to the remote repository

##5.  Writing workflows in Markdown for use on GitHub
* Markdown is a syntax for fast text-to-html conversion so that it is readable and web-ready.
* The extension of a markdown document is ".md".  GitHub will automatically render documents with .md extension to be pretty on the web interface.
* You can use any text editor to write a mark down document.  Two nice open ones are [sublime](http://www.sublimetext.com/) and [atom](https://atom.io/).
* Take a look a this document "raw" to have an exampe of what markdown looks like without rendering. 
* Here is one [cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) for Markdown syntax; there are many!
* _Fun Exercise!_ : Create a markdown document and post it to a new GitHub repository that you've created.

***
##Help and other resources
* GitHub [Glossary](https://help.github.com/articles/github-glossary/) of Git terms and jargon.
* GitHub has a [Bootcamp](https://help.github.com/categories/bootcamp/) series of tutorials for getting started.
* GitHub curated page of [learning resources](https://help.github.com/articles/good-resources-for-learning-git-and-github/)
* At the bottom of all GitHub documentation, there is an button to[Contact a Human](https://github.com/contact)
* [Markdown](http://daringfireball.net/projects/markdown/) documentation and official site.


