function vitesse=lecture_vitesse(doigt,s)

%------------------------choix du doigt----------------------------------------

%valeurs en hexa recuperer par la formule dans le pdf protocole
%registre 27:VITESSE_MOTEUR

if doigt==0,%rotation pouce
    Pos_mem_faible=hex2dec('03');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('04');%<--- poids fort de la premiere position memoire
    
elseif doigt==1,%pouce
    Pos_mem_faible=hex2dec('EB');
    Pos_mem_fort=hex2dec('07');
    
elseif doigt==2,%index
    Pos_mem_faible=hex2dec('D3');
    Pos_mem_fort=hex2dec('0B');
    
elseif doigt==3,%majeur
    Pos_mem_faible=hex2dec('BB');
    Pos_mem_fort=hex2dec('0F');
    
elseif doigt==4,%annulaire
    Pos_mem_faible=hex2dec('A3');
    Pos_mem_fort=hex2dec('13');
    
elseif doigt==5,%auriculaire
    Pos_mem_faible=hex2dec('8B');
    Pos_mem_fort=hex2dec('17');
    
end

%-------------------------------------------------------------------
mot_commande=hex2dec('52');%<--- R
mot_commande2=hex2dec('44');%<--- D
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

%CRC16 calcul
buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
[crc16hi,crc16lo]=CRC16(buf);

flushinput(s);

fwrite(s,[buf,crc16lo,crc16hi]);
response = fread(s,12);

%% My version, should be faster, Konstantin:
fs = repmat('%02X', 1, 4);
vitesse_hex = sprintf(fs,response(10:-1:7));
vitesse=hex2dec(vitesse_hex);

vitesse = vitesse/100;

return;



