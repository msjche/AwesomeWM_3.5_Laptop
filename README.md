# AwesomeWM_Laptop

I've created a folder "PROFILES" that contain folders, widgets and libraries for two separate AwesomeWM configurations

Since these two configs do not use the same themes or paths, i've decided to move to this system

Installation:

	git clone https://github.com/msjche/AwesomeWM_Laptop.git ~/.config/awesome
	cd ~/.config/awesome && cp -r AwesomeWM_Laptop/* .
Optional:
	rm -r AwesomeWM_Laptop

if you want any specific PROFILE:

	cd ~/.config/awesome

and create symlinks as follows:

For "msjche" theme
![Alt text](msjche.png?raw=true "Title")
ln -s PROFILES/msjche/* .

For "Default" theme
![Alt text](default.png?raw=true "Title")
ln -s PROFILES/default/* .

from there you should be able to reload Awesome and have the new system. Enjoy!

MJ
