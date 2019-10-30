export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH
go get -u github.com/rakyll/hey
# This URL might be different
hey -z 5m http://store.52.224.205.174.nip.io/