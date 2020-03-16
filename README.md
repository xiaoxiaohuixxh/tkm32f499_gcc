# tkm32f499_gcc
做了个tkm32f499的gcc工程
编译软件下载: https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update
Linux 编译软件下载: gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2
```
wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update/+download/gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2
sudo tar xvf gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2 -C /usr/local/
git clone https://github.com/xiaoxiaohuixxh/tkm32f499_gcc.git
cd tkm32f499_gcc
CROSS_COMPILE=/usr/local/gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi- make
```
