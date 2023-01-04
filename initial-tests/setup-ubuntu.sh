openssl version
# is > 1.1.1e continue else upgrade openssl

# Install dependecies
sudo apt install autoconf build-essential libtool cmake cpuid libssl-dev pkg-config git wget -y

wget http://archive.ubuntu.com/ubuntu/pool/universe/n/nasm/nasm_2.15.05-1_amd64.deb
sudo dpkg -i nasm_2.15.05-1_amd64.deb

# check if output matches requirement 
cpuid -1 | egrep 'VAES|VPCLM|GFNI|AVX512F|AVX512IFMA'
    #   AVX512F: AVX-512 foundation instructions = true
    #   AVX512IFMA: fused multiply add           = true
    #   VAES instructions                        = true
    #   VPCLMULQDQ instruction                   = true

cd ~

git clone https://github.com/intel/ipp-crypto.git && cd ipp-crypto
git checkout ippcp_2021.6

cd sources/ippcp/crypto_mb
cmake . -Bbuild -DCMAKE_INSTALL_PREFIX=/usr

cd build
make -j && sudo make install

cd ~

git clone https://github.com/intel/intel-ipsec-mb.git && cd intel-ipsec-mb
git checkout v1.3

make -j && make install NOLDCONFIG=y

cd ~

git clone https://github.com/intel/QAT_Engine.git && cd QAT_Engine
git checkout v0.6.16

./autogen.sh && ./configure --enable-qat_sw
make -j && sudo make install

# openssl engine for expected output
openssl version -e
# ENGINESDIR: "/usr/lib/x86_64-linux-gnu/engines-1.1"

openssl engine -v qatengine

# Setup
sudo apt install python python3-pip -y && pip install pandas
git clone https://github.com/abhayhk2001/open-ssl-tests

# Run
cd open-ssl-tests/initial-tests
rm results/*
mkdir results
python run-prod.txt