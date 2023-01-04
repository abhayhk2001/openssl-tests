## Setup OpenSSL - OpenSSL is preconfigured with RedHat(8)
# Check the version
openssl version
# is > 1.1.1e continue else upgrade openssl

# Install dependecies
sudo -i
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
rpm -ql epel-release
dnf repolist -v
dnf update -y

dnf group install "Development Tools" -y
dnf install wget cpuid cmake openssl-devel -y

wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/linux/nasm-2.15.05-0.fc31.x86_64.rpm
rpm -i nasm-2.15.05-0.fc31.x86_64.rpm

# check if output matches requirement 
cpuid -1 | egrep 'VAES|VPCLM|GFNI|AVX512F|AVX512IFMA'
    #   AVX512F: AVX-512 foundation instructions = true
    #   AVX512IFMA: fused multiply add           = true
    #   VAES instructions                        = true
    #   VPCLMULQDQ instruction                   = true
cd /home/anand_navchetana 

git clone https://github.com/intel/ipp-crypto.git && cd ipp-crypto
git checkout ippcp_2021.6

cd sources/ippcp/crypto_mb
cmake . -Bbuild -DCMAKE_INSTALL_PREFIX=/usr

cd build
make -j && make install

cd /home/anand_navchetana

git clone https://github.com/intel/intel-ipsec-mb.git && cd intel-ipsec-mb
git checkout v1.3

make -j && make install NOLDCONFIG=y

cd /home/anand_navchetana

git clone https://github.com/intel/QAT_Engine.git && cd QAT_Engine
git checkout v0.6.16

./autogen.sh && ./configure --enable-qat_sw
make -j && make install

# openssl engine for expected output
openssl version -e
# ENGINESDIR: "/usr/lib/x86_64-linux-gnu/engines-1.1"

ldconfig && openssl engine -v qatengine

# Setup
dnf install yum-utils make gcc bzip2-devel libffi-devel zlib-devel -y
yum install python3 python3-pip -y
pip3 install pandas

cd /home/anand_navchetana
### Without Github - (gz file of run.txt and run-rhel.sh shared)
### Unzip and upload to the test sytem, change directory to one containing the file

### With Github
git clone https://github.com/abhayhk2001/open-ssl-tests
cd open-ssl-tests/initial-tests
git pull

# Run
rm results/*
mkdir results
python3 run-prod.txt

# Installing Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
tar -xzvf node_exporter-1.4.0.linux-amd64.tar.gz
sudo useradd -rs /bin/false nodeusr
sudo mv node_exporter-1.4.0.linux-amd64/node_exporter /usr/local/bin/node_exporter
sudo vim /etc/systemd/system/node-exporter.service
sudo systemctl daemon-reload
sudo systemctl start node-exporter
sudo systemctl status node-exporter
sudo systemctl enable node-exporter

# Test Node exporter
curl http://localhost:9100/metrics
