scenario = "创新课3";
active_buttons = 10;                
button_codes = 1,2,3,4,5,6,7,8,9,10;
default_all_responses = false;
default_font_size = 30;
default_trial_type = first_response;
no_logfile = false;
response_matching = simple_matching;
response_logging = log_active;
write_codes = true;
pulse_width = 20; # if parallel port
#code_delay = 30;
pcl_file = "music.pcl";


begin;
text { caption = "+"; font_size = 64; } plus;
picture { text { caption = "+"; font_size = 64; }; x = 0; y = 0;} fixation;
wavefile { filename = ""; preload = false; } wavefile1; 
sound { wavefile wavefile1;} sound1;

trial {
	trial_type = specific_response;
	terminator_button = 10;
    
	picture {
      text { caption = "欢迎您来参加\"音乐与情感\"认知实验\n
您将聆听到16段音乐，
每段音乐前后各睁眼休息15秒，
听音乐过程中请注视屏幕中间白色的\"+\"，
每听完一段音乐后请回答4个问题。\n
本实验一共耗时约45分钟。\n
按空格键开始..."; 
width=1200;height=700;};
      x = 0; y = 0;
   };
	duration = response;
	deltat = 100;
	code = 90;
	port_code = 90;
   response_active = true;
	 
} instruction_trial;

trial {
	picture {
      text {
			caption = "请闭眼放松60秒，滴声后请睁眼继续实验\n请按空格键开始..."; 
			width=1200; height=700;
		};
      x = 0; y = 0;
   };
	deltat = 100;
   duration = response;
	code = 91;
	port_code = 91;
   response_active = true;
	 
} before_ec_trial;

trial {
	stimulus_event {
      picture {
			text {
				caption = "请闭眼，放松60秒，滴声结束睁眼继续实验\n"; 
				width=1200; height=700;
			};
			x = 0; y = 0;
		};
		deltat = 100;
		duration = 60000;
		#duration = 6000;
		code = 92;
		port_code = 92;
   } event3;
	 
} spontaneous_ec_trial;

trial {
   trial_duration = 1000;
	sound { wavefile { filename = "drip.wav"; }; };
	deltat=100;
	duration = 1000;
   code = 93;
	port_code = 93;
} drip_trial;

trial {
	picture {
      text {
			caption = "请注视屏幕中央\"+\"号15秒\n按空格键开始...\n"; 
			width=1200; height=700;
		};
      x = 0; y = 0;
   };
	deltat = 100;
   duration = response;
	code = 94;
	port_code = 94;
   response_active = true;
	 
} before_eo_trial;

trial {  
   
	stimulus_event {
      picture fixation;
		deltat=100;
		duration = 15000;
		code = 51;
		port_code = 51;
   } event2;
	 
} sub_eo_trial;


trial {
   trial_duration = 1000;
	sound { wavefile { filename = "drip.wav"; }; };
   picture fixation;
	deltat=100;
	duration = 1000;
   code = 95;
	port_code = 95;
} plus_trial;

trial {
	picture {
      text {
			caption = "请休息放松，按空格键继续...\n"; 
			width=1200; height=700;
		};
      x = 0; y = 0;
   };
	deltat = 100;
   duration = response;
	code = 96;
	port_code = 96;
   response_active = true;
	 
} relax_trial;

trial {
	picture {
      text {
			caption = "音乐即将开始，请注视屏幕中央\"+\"\n"; 
			width=1200; height=700;
		};
      x = 0; y = 0;
   };
	deltat = 100;
	duration = 3000;
	code = 97;
	port_code = 97;
} before_music_trial;

trial {
	picture {
      text {
			caption = "本轮结束请休息放松30秒，滴声后继续实验\n"; 
			width=1200; height=700;
		};
      x = 0; y = 0;
   };
   deltat = 100;
	duration = 30000;
	code = 98;
	port_code = 98;
} relax_1min_trial;

trial {	 
   #trial_duration = 10000;
   picture fixation;
    
   stimulus_event {
      sound sound1;
		deltat = 2000;
		#duration = 10000;
   } event1;
    	
} main_trial;

trial {   
	
	picture {
		text {
			font_size = 30;
			caption = "这段音乐让你感觉愉悦、开心的程度\n请按键1~9选择";
		};
		x = 0; y = 200;
		bitmap { filename = "qn21.bmp"; };
		x = 0; y = 0;
	};
	time = 1000;
	duration = response;
	code = 31;
	port_code = 31;
	response_active = true;
} qn1_trial;

trial {   
	
	picture {
		text {
			font_size = 30;
			caption = "这段音乐让你感觉刺激、兴奋的程度\n请按键1~9选择";
		};
		x = 0; y = 200;
		bitmap { filename = "qn2.bmp"; };
		x = 0; y = 0;
	};
	time = 1000;
	duration = response;
	code = 32;
	port_code = 32;
	response_active = true;
} qn2_trial;

trial {   
	
	picture {
		text {
			font_size = 30;
			caption = "这段音乐让你感觉的喜欢程度\n请按键1~5选择";
		};
		x = 0; y = 200;
		bitmap { filename = "qn23.bmp"; };
		x = 0; y = 0;
	};
	time = 1000;
	duration = response;
	code = 33;
	port_code = 33;
	response_active = true;
} qn3_trial;

trial {   
	
	picture {
		text {
			font_size = 30;
			caption = "这段音乐让你感觉的熟悉程度\n请按键1~5选择";
		};
		x = 0; y = 200;
		bitmap { filename = "qn24.bmp"; };
		x = 0; y = 0;
	};
	time = 1000;
	duration = response;
	code = 34;
	port_code = 34;
	response_active = true;
} qn4_trial;


trial {
	picture {
       text { caption = "实验结束，感谢参加心理学实验\n"; 
width=1200;height=700;};
       x = 0; y = 0;
    };
    deltat = 100;
    duration = 5000;	 
	 code = 99;
	 port_code = 99;
	 
} end_trial;

