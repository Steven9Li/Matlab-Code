% TANN脚本，时间集成和帧间集成
clear;
clc;


test_data = rand(39,400);

res1 = TimeAcc(test_data, 20 ,19);

res = FrameAcc(res1);