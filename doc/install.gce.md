install.gce.md
============

```bash
sudo apt-get update
sudo apt-get install gcc g++ make libpcre3-dev libssl-dev tmux emacs libncurses5-dev libreadline-dev libffi-dev libyaml-dev valgrind git-core libxml2-dev libxslt-dev ntp sqlite3 libsqlite3-dev bzip2
sudo apt-get install nodejs
sudo ln -s /usr/bin/nodejs /usr/bin/node
curl https://www.npmjs.org/install.sh | sudo sh
sudo apt-get install graphviz
curl -O http://nginx.org/download/nginx-1.7.1.tar.gz
./configure --prefix=/usr/local/nginx --with-http_realip_module --with-http_gzip_static_module --with-http_stub_status_module


git clone https://github.com/hatemogi/gvdoodle
ln -s /home/hatemogi/gvdoodle /usr/local/gvdoodle

```