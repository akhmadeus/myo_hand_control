function [mm,m1] = configure_myo(dependencies_path)
%% Add dependencies
addpath([dependencies_path filesep 'MyoMex-master']);
cur_folder = pwd;
cd([dependencies_path filesep 'myo-sdk-win-0.9.0']); 
sdk_path = pwd; % root path to Myo SDK
cd(cur_folder);

disp('Installing myo-mex...');
install_myo_mex;
build_myo_mex(sdk_path); % builds myo_mex
countMyos = 1;

disp('Creating myo-mex object...');
mm = MyoMex(countMyos);
m1 = mm.myoData(1);
pause(0.1); % wait briefly for the first data frame to come in
disp('Myo-mex object created. Don''t forget to delete it by ''mm.delete'' if following code is interrupted by error');

if m1.isStreaming
    disp('MYO is streaming');
else
    disp('Something wrong. Streaming is off');
end

end %function