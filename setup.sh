#!/bin/bash
sudo apt-get update
sudo apt-get install -y golang-go python3 python3-pip jq curl git build-essential sqlmap
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/hakluke/haktrails@latest
go install github.com/003random/getJS/v2@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/hahwul/dalfox/v2@latest
go install github.com/tomnomnom/gf@latest
mkdir -p ~/.gf
git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf/Gf-Patterns
cp ~/.gf/Gf-Patterns/*.json ~/.gf
go install github.com/projectdiscovery/urlfinder@latest
echo "Setup completed successfully. Ensure your PATH includes \$GOPATH/bin."
