% TANN�ű���ʱ�伯�ɺ�֡�伯��
clear;
clc;


test_data = rand(39,400);

res1 = TimeAcc(test_data, 20 ,4);

res = FrameAcc(res1);