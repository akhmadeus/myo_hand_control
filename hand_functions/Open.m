function Open(s)

%
%But: ouvrir complétement la main
%




% ---------------------création d'un mot de position-------------------

pos_main=0;%<---valeur max de chaque doigts(sauf pouce et rotation pouce)
pos_hex=dec2hex(pos_main);
if length(dec2hex(pos_main))==3
    position_fort=hex2dec(pos_hex(1));
    position_faible=hex2dec(strcat(pos_hex(2),pos_hex(3)));
elseif  length(dec2hex(pos_main))==2
    position_fort=0;
    position_faible=hex2dec(strcat(pos_hex(1),pos_hex(2)));
elseif  length(dec2hex(pos_main))==1
    position_fort=0;
    position_faible=hex2dec(pos_hex(1));
elseif  length(dec2hex(pos_main))==4
    position_fort=hex2dec(strcat(pos_hex(1),pos_hex(2)));
    position_faible=hex2dec(strcat(pos_hex(3),pos_hex(4)));
    
end

%------------------------choix du doigt------------------------------
%rotation pouce
    Pos_mem_faible_Rpouce=hex2dec('E8');%<--- poids faible de la premiere position memoire
    Pos_mem_fort_Rpouce=hex2dec('03');%<--- poids fort de la premiere position memoire
    
%pouce
    Pos_mem_faible_pouce=hex2dec('D0');
    Pos_mem_fort_pouce=hex2dec('07');
    
%index
    Pos_mem_faible_index=hex2dec('B8');
    Pos_mem_fort_index=hex2dec('0B');
    
%majeur
    Pos_mem_faible_majeur=hex2dec('A0');
    Pos_mem_fort_majeur=hex2dec('0F');
    

%annulaire
    Pos_mem_faible_annulaire=hex2dec('88');
    Pos_mem_fort_annulaire=hex2dec('13');
    
%auriculaire
    Pos_mem_faible_auriculaire=hex2dec('70');
    Pos_mem_fort_auriculaire=hex2dec('17');
    


%création de la trame
mot_commande=hex2dec('57');%<--- W
mot_commande2=hex2dec('52');%<--- R
Registre_faible=hex2dec('02');%<--- poids faible du nombre de registre
Registre_fort=hex2dec('00');%<--- poids fort du nombre de registre

%----------------------------CRC16 calcul------------------------------
%rotation pouce / position codeur Rpouce:18000 valeur arbitraire pour
%ressembler a un poing fermé
buf_Rpouce=[mot_commande,mot_commande2,Pos_mem_faible_Rpouce,Pos_mem_fort_Rpouce,Registre_faible,Registre_fort,01,00,00,00,hex2dec('00'),hex2dec('00'),00,00];
[crc16hi_Rpouce,crc16lo_Rpouce]=CRC16(buf_Rpouce);

%pouce / position codeur pouce:13832 valeur arbitraire pour
%ressembler a un poing fermé
buf_pouce=[mot_commande,mot_commande2,Pos_mem_faible_pouce,Pos_mem_fort_pouce,Registre_faible,Registre_fort,01,00,00,00,hex2dec('00'),hex2dec('00'),00,00];
[crc16hi_pouce,crc16lo_pouce]=CRC16(buf_pouce);

%index
buf_index=[mot_commande,mot_commande2,Pos_mem_faible_index,Pos_mem_fort_index,Registre_faible,Registre_fort,01,00,00,00,0,0,00,00];
[crc16hi_index,crc16lo_index]=CRC16(buf_index);

%majeur
buf_majeur=[mot_commande,mot_commande2,Pos_mem_faible_majeur,Pos_mem_fort_majeur,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_majeur,crc16lo_majeur]=CRC16(buf_majeur);

%annulaire
buf_annulaire=[mot_commande,mot_commande2,Pos_mem_faible_annulaire,Pos_mem_fort_annulaire,Registre_faible,Registre_fort,01,00,00,00,position_faible,position_fort,00,00];
[crc16hi_annulaire,crc16lo_annulaire]=CRC16(buf_annulaire);

%auriculaire
buf_auriculaire=[mot_commande,mot_commande2,Pos_mem_faible_auriculaire,Pos_mem_fort_auriculaire,Registre_faible,Registre_fort,01,00,00,00,0,0,00,00];
[crc16hi_auriculaire,crc16lo_auriculaire]=CRC16(buf_auriculaire);


%----------------------ecriture dans la main-------------------------
fwrite(s,[buf_pouce,crc16lo_pouce,crc16hi_pouce]);
pause(1);%<--- attente afin d'ouvrir le pouce avant les autres doigts
fwrite(s,[buf_Rpouce,crc16lo_Rpouce,crc16hi_Rpouce]);%<-- rotation pouce
fwrite(s,[buf_index,crc16lo_index,crc16hi_index]);%<--- index
fwrite(s,[buf_majeur,crc16lo_majeur,crc16hi_majeur]);%<--- majeur
fwrite(s,[buf_annulaire,crc16lo_annulaire,crc16hi_annulaire]);%<--- annulaire
fwrite(s,[buf_auriculaire,crc16lo_auriculaire,crc16hi_auriculaire]);%<--- auriculaire
pause(1.5);%<--- attente pour que le pouce vienne ce mettre au dessu des autres doigts

for i=1:48%<--8*6 égale à 6 fois la lecture de 8 valeurs en hexa (8 valeurs par doigt)
    fread(s,1);%<-- lecture pour ne pas interferer avec les autres lectures du principal
end