function acc = Test(data,Fs,trials_num,test_num,CSPMatrix,trainedClassifier)
%TEST 此处显示有关此函数的摘要
%   此处显示详细说明
    nbFilterPairs = 10;
    acc = zeros(7,7);
    for ii = 1:7
        for jj = (ii+1):7
        classes = [1,2,3,4,5,6,7];
        classes(jj) = [];
        classes(ii) = [];
        test_sets = zeros(Fs,62,test_num*5);
        test_labels = zeros(1,test_num*5);
        train_num = trials_num - test_num;
        for i = 1:5
            test_sets(:,:,(i-1)*test_num+1:i*test_num) = data{classes(i)}(:,:,train_num+1:trials_num);
            test_labels((i-1)*test_num+1:i*test_num) = ones(1,test_num)*classes(i);
        end

        test_res = zeros(test_num*5, 7);

        for i = 1:5
            for j = (i+1):5
                EEG_test.x = test_sets;
                test_features = extractCSP(EEG_test, CSPMatrix{classes(i),classes(j)}, nbFilterPairs);
                test_features(:,21) = [];
                y = trainedClassifier{classes(i),classes(j)}.predictFcn(test_features);
                for k = 1:length(y)
                    if y(k) == 1
                        test_res(k,classes(i)) = test_res(k,classes(i)) + 1;
                    else
                        test_res(k,classes(j)) = test_res(k,classes(j)) + 1;
                    end
                end

            end
        end

        [a, res] = max(test_res');
        sucess = 0;
        for i = 1:5*test_num
            if res(i) == test_labels(i)
                sucess = sucess+1;
            end
        end

        acc(ii,jj) = sucess/(test_num*5);
        % disp([num2str(ii),',',num2str(jj),' 识别率为： ', num2str(acc)])
        end
    end
end

