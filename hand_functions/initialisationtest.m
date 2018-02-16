function [result]= initialisationtest(s)
result=0;

%------------------------création de la trame principal----------------------

%toujours vrais pour une écriture sur un doigt sans lecture
mot_commande=hex2dec('52');%<--- R
mot_commande2=hex2dec('44');%<--- D

Pos_mem_faible=hex2dec('64');
Pos_mem_fort=hex2dec('00');

Registre_faible=hex2dec('01');%<--- poids faible du nombre de registre
Registre_fort=hex2dec('00');%<--- poids fort du nombre de registre

%--------------------------------CRC16 calcul--------------------------------

%se referer au programme CRC16 si besion d'explication
buf=[mot_commande,mot_commande2,Pos_mem_faible,Pos_mem_fort,Registre_faible,Registre_fort];
[crc16hi,crc16lo]=CRC16(buf);


%-----------------------------ecriture dans la main--------------------------
flushinput(s);
fwrite(s,[buf,crc16lo,crc16hi]);

%------------------------------------lecture --------------------------
response = fread(s,12);
test = response(7);
% for i=1:11
%     fread(s,1);
%     if i==6
%         test=fread(s,1);
%     end
% end


if test==1
    result=1;
end
end


