# Proxy toggler

The proxy toggler is a small script which I wrote to save time toggeling the proxy settings 
for npm, git and atom manually, wether I am in home office or in the company office.


##Usage 

    proxy [command]

Commands:
- `on`: sets  proxy configuration
- `off`: unsets proxy configuration
- `-h`: shows the help

If no command is provided then the current proxy network setting is used.
 
I also setup a small configuration in the `.bash_profile` to run the script from everywhere:

    source [PATH]/proxy.sh -i
    alias proxy="~/scripts/proxy.sh"

`-i` in `source [PATH]/proxy.sh -i` just ensures that the script is not running every time you open a new shell prompt. 


##Hint: Configure your default proxy manually

If you try switching the proxy settings `on` and no proxy can be found in the network settings, than it would use 
the default proxy. The default proxy you need to configure first.

Please replace `[YOUR_DEFAULT_PROXY]` in the proxy script with your preferences.

    proxy_default="[YOUR_DEFAULT_PROXY]"
