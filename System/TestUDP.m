<<<<<<< HEAD
clear;
clc;

% portA=9090; 
% ipA='127.0.0.1'; 
% portB=9090;
% 
% %A 接受， B 来自
% udpReceive=udp(ipA,portA,'LocalPort',portB);
% set(udpReceive,'TimeOut',30);
% set(udpReceive,'InputBufferSize',8192);
% udpReceive.EnablePortSharing = 'on';
% fopen(udpReceive);
% index = 1;
% 
% data = str2double(fscanf(udpReceive));
% plot(data);
% title('Server 1');
% %pause(0.1)
% 
% clear ipA portA  portB
% fclose(udpReceive);
% delete(udpReceive);

ipA = '192.168.1.202'; 
portA = 10008;
ipB = '192.168.1.77';
portB = 10007;
uA = udp(ipB,portB,'LocalPort',portA);
set(uA,'OutputBufferSize',64*1000*20*8);
set(uA,'TimeOut',100);
fopen(uA);
t = 1:64*1000*20;

index = 1;
while(1)
    t(1) = index;
    disp(num2str(t(1)))
    
    index = index + 1;
    fwrite(uA,t(:),'double');
    %%fprintf(uA,t);
    %pause(1);
end

fclose(uA)
delete(uA)
clear uA
% 
% ipA='192.168.0.5'; 
% portA=8080;
% ipB='192.168.0.3';
% portB=8080;
% handles.udpB=udp(ipA,portA,'LocalPort',portB);
% set(handles.udpB,'TimeOut',10);
% set(handles.udpB,'InputBufferSize',8192);
% fopen(handles.udpB);
%  
% for t = 1:15
%     a1 = str2double(fscanf(handles.udpB));
%     set(handles.edit1,'string',a1);
%     pause(0.1);
% end
=======
clear;
clc;

% portA=9090; 
% ipA='127.0.0.1'; 
% portB=9090;
% 
% %A 接受， B 来自
% udpReceive=udp(ipA,portA,'LocalPort',portB);
% set(udpReceive,'TimeOut',30);
% set(udpReceive,'InputBufferSize',8192);
% udpReceive.EnablePortSharing = 'on';
% fopen(udpReceive);
% index = 1;
% 
% data = str2double(fscanf(udpReceive));
% plot(data);
% title('Server 1');
% %pause(0.1)
% 
% clear ipA portA  portB
% fclose(udpReceive);
% delete(udpReceive);

ipA = '192.168.1.202'; 
portA = 10008;
ipB = '192.168.1.77';
portB = 10007;
uA = udp(ipB,portB,'LocalPort',portA);
set(uA,'OutputBufferSize',64*1000*20*8);
set(uA,'TimeOut',100);
fopen(uA);
t = 1:64*1000*20;

index = 1;
while(1)
    t(1) = index;
    disp(num2str(t(1)))
    
    index = index + 1;
    fwrite(uA,t(:),'double');
    %%fprintf(uA,t);
    %pause(1);
end

fclose(uA)
delete(uA)
clear uA
% 
% ipA='192.168.0.5'; 
% portA=8080;
% ipB='192.168.0.3';
% portB=8080;
% handles.udpB=udp(ipA,portA,'LocalPort',portB);
% set(handles.udpB,'TimeOut',10);
% set(handles.udpB,'InputBufferSize',8192);
% fopen(handles.udpB);
%  
% for t = 1:15
%     a1 = str2double(fscanf(handles.udpB));
%     set(handles.edit1,'string',a1);
%     pause(0.1);
% end
>>>>>>> first
