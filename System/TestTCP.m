% server
clear;
clc;


tcpipServer = tcpip('0.0.0.0',30000,'NetworkRole','Server');
set(tcpipServer,'OutputBufferSize',64*20000*8);
fopen(tcpipServer);
data = 1:64*20000;
index = 1;
while(1)
    data(1) = index;
    index = index + 1;
    fwrite(tcpipServer,data(:),'double');
end
fclose(tcpipServer);