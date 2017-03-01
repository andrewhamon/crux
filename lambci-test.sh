~/init/gcc
curl -sSL https://github.com/crystal-lang/crystal/releases/download/0.21.0/crystal-0.21.0-1-linux-x86_64.tar.gz | tar -xz -C ~
export PATH=$PATH:~/crystal-0.21.0-1/bin
crystal spec
