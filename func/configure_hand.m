function s = configure_hand(dependencies_path, com_port_name, force_init)

%addpath([dependencies_path filesep 'Alpes_Instrument_matlab']);

delete(instrfind('Port',com_port_name)); % Cancel existing serial communication (any need)?

s=serial(com_port_name);
set(s, 'BaudRate',460800,'DataBits',8,'StopBits',1,...
    'Parity','none','FlowControl','none','TimeOut',1);
fopen(s);
 
% Launch hand proper initilisation function if haven't initialized since
% last off/on.
if ~initialisationtest(s) || force_init;
    initialisation(s);
end
end