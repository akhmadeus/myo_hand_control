function position=lecture_position(s,doigt)
%
%Lit la valeur du registre position pour un doigt
%

%Meme principe que dans tous les autres programmes lier aux doigts

if doigt==0,%rotation pouce
    Pos_mem_faible=hex2dec('02');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('04');%<--- poids fort de la premiere position memoire
    
elseif doigt==1,%pouce
    Pos_mem_faible=hex2dec('EA');
    Pos_mem_fort=hex2dec('07');
    
elseif doigt==2,%index
    Pos_mem_faible=hex2dec('D2');
    Pos_mem_fort=hex2dec('0B');
    
elseif doigt==3,%majeur
    Pos_mem_faible=hex2dec('BA');
    Pos_mem_fort=hex2dec('0F');
    
elseif doigt==4,%annulaire
    Pos_mem_faible=hex2dec('A2');
    Pos_mem_fort=hex2dec('13');
    
elseif doigt==5,%auriculaire
    Pos_mem_faible=hex2dec('8A');
    Pos_mem_fort=hex2dec('17');
    
end

mot_commande=hex2dec('52');
mot_commande2=hex2dec('44');

registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);


flushinput(s);

fwrite(s,[buf,crc16lo,crc16hi]);
response = fread(s,12);

%% My version, should be faster:
fs = repmat('%02X', 1, 4);
position_hex = sprintf(fs,response(10:-1:7));
position=hex2dec(position_hex);

end


    