function close_motion_prop(pos,s)

%
%But: faire bouger un doigt à la position demandée
%

% --------------création d'un mot de position pour chaque doigt-----------------
%rotation pouce

    pos_hex1=dec2hex(pos(1));%<---transformation de la position en hexa
    %                         gère la taille du mot en hexa dut au faite que 
    %                         l'on renverse le mot donc que si le mot est plus 
    %                         petit que 4 (le max) alors les zeros utiles
    %                         serons au début et donc supprimé par matlab 
    length_pos1 = length(pos_hex1);
    if length_pos1==3%<-- si taille du mot est de trois alors le mot de 
        %                          poids fort seras la position 3 du mot et '0' 
        position_fort_Rpouce=hex2dec(pos_hex1(1));
        position_faible_Rpouce=hex2dec(strcat(pos_hex1(2),pos_hex1(3)));
    elseif  length_pos1==2%<-- si taille du mot est de deux alors le mot de 
        %                          poids fort seras '00'
        position_fort_Rpouce=0;
        position_faible_Rpouce=hex2dec(strcat(pos_hex1(1),pos_hex1(2)));
    elseif  length_pos1==1%<-- si taille du mot est de un alors le mot de 
        %                          poids fort seras '00' et celui de poids
        %                          faible sera position 1 du mot et '0'
        position_fort_Rpouce=0;
        position_faible_Rpouce=hex2dec(pos_hex1(1));
    elseif  length_pos1==4%<-- si taille du mot est de quatre alors 
        %                               c'est parfait on retourne le mot
        %                               directement
        position_fort_Rpouce=hex2dec(strcat(pos_hex1(1),pos_hex1(2)));
        position_faible_Rpouce=hex2dec(strcat(pos_hex1(3),pos_hex1(4)));

    end

%pouce
    pos_hex2=dec2hex(pos(2));%<---transformation de la position en hexa
    %                         gère la taille du mot en hexa dut au faite que 
    %                         l'on renverse le mot donc que si le mot est plus 
    %                         petit que 4 (le max) alors les zeros utiles
    %                         serons au début et donc supprimé par matlab 
    length_pos2 = length(pos_hex2);
    if length_pos2==3%<-- si taille du mot est de trois alors le mot de 
        %                          poids fort seras la position 3 du mot et '0' 
        position_fort_pouce=hex2dec(pos_hex2(1));
        position_faible_pouce=hex2dec(strcat(pos_hex2(2),pos_hex2(3)));
    elseif  length_pos2==2%<-- si taille du mot est de deux alors le mot de 
        %                          poids fort seras '00'
        position_fort_pouce=0;
        position_faible_pouce=hex2dec(strcat(pos_hex2(1),pos_hex2(2)));
    elseif  length_pos2==1%<-- si taille du mot est de un alors le mot de 
        %                          poids fort seras '00' et celui de poids
        %                          faible sera position 1 du mot et '0'
        position_fort_pouce=0;
        position_faible_pouce=hex2dec(pos_hex2(1));
    elseif  length_pos2==4%<-- si taille du mot est de quatre alors 
        %                               c'est parfait on retourne le mot
        %                               directement
        position_fort_pouce=hex2dec(strcat(pos_hex2(1),pos_hex2(2)));
        position_faible_pouce=hex2dec(strcat(pos_hex2(3),pos_hex2(4)));

    end

%index
    pos_hex3=dec2hex(pos(3));%<---transformation de la position en hexa
    %                         gère la taille du mot en hexa dut au faite que 
    %                         l'on renverse le mot donc que si le mot est plus 
    %                         petit que 4 (le max) alors les zeros utiles
    %                         serons au début et donc supprimé par matlab 
    length_pos3 = length(pos_hex3);
    if length_pos3==3%<-- si taille du mot est de trois alors le mot de 
        %                          poids fort seras la position 3 du mot et '0' 
        position_fort_index=hex2dec(pos_hex3(1));
        position_faible_index=hex2dec(strcat(pos_hex3(2),pos_hex3(3)));
    elseif  length_pos3==2%<-- si taille du mot est de deux alors le mot de 
        %                          poids fort seras '00'
        position_fort_index=0;
        position_faible_index=hex2dec(strcat(pos_hex3(1),pos_hex3(2)));
    elseif  length_pos3==1%<-- si taille du mot est de un alors le mot de 
        %                          poids fort seras '00' et celui de poids
        %                          faible sera position 1 du mot et '0'
        position_fort_index=0;
        position_faible_index=hex2dec(pos_hex3(1));
    elseif  length_pos3==4%<-- si taille du mot est de quatre alors 
        %                               c'est parfait on retourne le mot
        %                               directement
        position_fort_index=hex2dec(strcat(pos_hex3(1),pos_hex3(2)));
        position_faible_index=hex2dec(strcat(pos_hex3(3),pos_hex3(4)));

    end

%majeur
    pos_hex4=dec2hex(pos(4));%<---transformation de la position en hexa
    %                         gère la taille du mot en hexa dut au faite que 
    %                         l'on renverse le mot donc que si le mot est plus 
    %                         petit que 4 (le max) alors les zeros utiles
    %                         serons au début et donc supprimé par matlab 
    length_pos4 = length(pos_hex4);
    if length_pos4==3%<-- si taille du mot est de trois alors le mot de 
        %                          poids fort seras la position 3 du mot et '0' 
        position_fort_majeur=hex2dec(pos_hex4(1));
        position_faible_majeur=hex2dec(strcat(pos_hex4(2),pos_hex4(3)));
    elseif  length_pos4==2%<-- si taille du mot est de deux alors le mot de 
        %                          poids fort seras '00'
        position_fort_majeur=0;
        position_faible_majeur=hex2dec(strcat(pos_hex4(1),pos_hex4(2)));
    elseif  length_pos4==1%<-- si taille du mot est de un alors le mot de 
        %                          poids fort seras '00' et celui de poids
        %                          faible sera position 1 du mot et '0'
        position_fort_majeur=0;
        position_faible_majeur=hex2dec(pos_hex4(1));
    elseif  length_pos4==4%<-- si taille du mot est de quatre alors 
        %                               c'est parfait on retourne le mot
        %                               directement
        position_fort_majeur=hex2dec(strcat(pos_hex4(1),pos_hex4(2)));
        position_faible_majeur=hex2dec(strcat(pos_hex4(3),pos_hex4(4)));

    end

%annulaire
    pos_hex5=dec2hex(pos(5));%<---transformation de la position en hexa
    %                         gère la taille du mot en hexa dut au faite que 
    %                         l'on renverse le mot donc que si le mot est plus 
    %                         petit que 4 (le max) alors les zeros utiles
    %                         serons au début et donc supprimé par matlab 
    length_pos5 = length(pos_hex5);
    if length_pos5==3%<-- si taille du mot est de trois alors le mot de 
        %                          poids fort seras la position 3 du mot et '0' 
        position_fort_annulaire=hex2dec(pos_hex5(1));
        position_faible_annulaire=hex2dec(strcat(pos_hex5(2),pos_hex5(3)));
    elseif  length_pos5==2%<-- si taille du mot est de deux alors le mot de 
        %                          poids fort seras '00'
        position_fort_annulaire=0;
        position_faible_annulaire=hex2dec(strcat(pos_hex5(1),pos_hex5(2)));
    elseif  length_pos5==1%<-- si taille du mot est de un alors le mot de 
        %                          poids fort seras '00' et celui de poids
        %                          faible sera position 1 du mot et '0'
        position_fort_annulaire=0;
        position_faible_annulaire=hex2dec(pos_hex5(1));
    elseif  length_pos5==4%<-- si taille du mot est de quatre alors 
        %                               c'est parfait on retourne le mot
        %                               directement
        position_fort_annulaire=hex2dec(strcat(pos_hex5(1),pos_hex5(2)));
        position_faible_annulaire=hex2dec(strcat(pos_hex5(3),pos_hex5(4)));

    end
%auriculaire
    pos_hex6=dec2hex(pos(6));%<---transformation de la position en hexa
    %                         gère la taille du mot en hexa dut au faite que 
    %                         l'on renverse le mot donc que si le mot est plus 
    %                         petit que 4 (le max) alors les zeros utiles
    %                         serons au début et donc supprimé par matlab 
    length_pos6 = length(pos_hex6);
    if length_pos6 == 3%<-- si taille du mot est de trois alors le mot de 
        %                          poids fort seras la position 3 du mot et '0' 
        position_fort_auriculaire=hex2dec(pos_hex6(1));
        position_faible_auriculaire=hex2dec(strcat(pos_hex6(2),pos_hex6(3)));
    elseif  length_pos6==2%<-- si taille du mot est de deux alors le mot de 
        %                          poids fort seras '00'
        position_fort_auriculaire=0;
        position_faible_auriculaire=hex2dec(strcat(pos_hex6(1),pos_hex6(2)));
    elseif  length_pos6==1%<-- si taille du mot est de un alors le mot de 
        %                          poids fort seras '00' et celui de poids
        %                          faible sera position 1 du mot et '0'
        position_fort_auriculaire=0;
        position_faible_auriculaire=hex2dec(pos_hex6(1));
    elseif  length_pos6==4%<-- si taille du mot est de quatre alors 
        %                               c'est parfait on retourne le mot
        %                               directement
        position_fort_auriculaire=hex2dec(strcat(pos_hex6(1),pos_hex6(2)));
        position_faible_auriculaire=hex2dec(strcat(pos_hex6(3),pos_hex6(4)));

    end

%------------------------choix du doigt----------------------------------------

%valeurs en hexa recuperées par la formule dans le pdf protocole
%rotation pouce

Pos_mem_faible_Rpouce= 232; %hex2dec('E8');%<--- poids faible de la premiere position memoire
Pos_mem_fort_Rpouce= 3; %hex2dec('03');%<--- poids fort de la premiere position memoire

%pouce
Pos_mem_faible_pouce= 208; %hex2dec('D0');
Pos_mem_fort_pouce= 7; %hex2dec('07');

%index
Pos_mem_faible_index= 184; %hex2dec('B8');
Pos_mem_fort_index= 11; %hex2dec('0B');

%majeur
Pos_mem_faible_majeur= 160; %hex2dec('A0');
Pos_mem_fort_majeur= 15; %hex2dec('0F');


%annulaire
Pos_mem_faible_annulaire= 136; %hex2dec('88');
Pos_mem_fort_annulaire= 19; %hex2dec('13');

%auriculaire
Pos_mem_faible_auriculaire= 112; %hex2dec('70');
Pos_mem_fort_auriculaire= 23; %hex2dec('17');

%------------------------création de la trame principal----------------------

%toujours vrais pour une écriture sur un doigt sans lecture
mot_commande = 87; %hex2dec('57') <--- W
mot_commande2 = 82; %hex2dec('52') <--- R
Registre_faible = 2; %hex2dec('02') <--- poids faible du nombre de registre
Registre_fort = 0; %hex2dec('00') <--- poids fort du nombre de registre

%--------------------------------CRC16 calcul--------------------------------

%----------------------------CRC16 calcul------------------------------
%rotation pouce / position codeur Rpouce:18000 valeur arbitraire pour
%ressembler a un poing fermé

buf_Rpouce=[mot_commande,mot_commande2,Pos_mem_faible_Rpouce,Pos_mem_fort_Rpouce,Registre_faible,Registre_fort,01,00,00,00,position_faible_Rpouce,position_fort_Rpouce,00,00];
[crc16hi_Rpouce,crc16lo_Rpouce]=CRC16(buf_Rpouce);

%pouce / position codeur pouce:13823 valeur arbitraire pour
%ressembler a un poing fermé
buf_pouce=[mot_commande,mot_commande2,Pos_mem_faible_pouce,Pos_mem_fort_pouce,Registre_faible,Registre_fort,01,00,00,00,position_faible_pouce,position_fort_pouce,00,00];
[crc16hi_pouce,crc16lo_pouce]=CRC16(buf_pouce);

%index
buf_index=[mot_commande,mot_commande2,Pos_mem_faible_index,Pos_mem_fort_index,Registre_faible,Registre_fort,01,00,00,00,position_faible_index,position_fort_index,00,00];
[crc16hi_index,crc16lo_index]=CRC16(buf_index);

%majeur
buf_majeur=[mot_commande,mot_commande2,Pos_mem_faible_majeur,Pos_mem_fort_majeur,Registre_faible,Registre_fort,01,00,00,00,position_faible_majeur,position_fort_majeur,00,00];
[crc16hi_majeur,crc16lo_majeur]=CRC16(buf_majeur);

%annulaire
buf_annulaire=[mot_commande,mot_commande2,Pos_mem_faible_annulaire,Pos_mem_fort_annulaire,Registre_faible,Registre_fort,01,00,00,00,position_faible_annulaire,position_fort_annulaire,00,00];
[crc16hi_annulaire,crc16lo_annulaire]=CRC16(buf_annulaire);

%auriculaire
buf_auriculaire=[mot_commande,mot_commande2,Pos_mem_faible_auriculaire,Pos_mem_fort_auriculaire,Registre_faible,Registre_fort,01,00,00,00,position_faible_auriculaire,position_fort_auriculaire,00,00];
[crc16hi_auriculaire,crc16lo_auriculaire]=CRC16(buf_auriculaire);


%-----------------------------ecriture dans la main--------------------------

fwrite(s,[buf_Rpouce,crc16lo_Rpouce,crc16hi_Rpouce]);%<-- rotation pouce
fwrite(s,[buf_index,crc16lo_index,crc16hi_index]);%<--- index
fwrite(s,[buf_majeur,crc16lo_majeur,crc16hi_majeur]);%<--- majeur
fwrite(s,[buf_annulaire,crc16lo_annulaire,crc16hi_annulaire]);%<--- annulaire
fwrite(s,[buf_auriculaire,crc16lo_auriculaire,crc16hi_auriculaire]);%<--- auriculaire
pause(0);%<--- attente pour que le pouce vienne ce mettre au dessu des autres doigts
fwrite(s,[buf_pouce,crc16lo_pouce,crc16hi_pouce]);

% for i=1:48%<--8*6 égale 6 àfois la lecture de 8 valeurs en hexa (8 valeurs par doigt)
%     fread(s,1);%<-- lecture pour ne pas interferer avec les autres lectures du principal
% end

%What if I do this way?
%Ans what if I flush it just before I'm going to read something? That means
%I don't need this line anymore. 
%Update: probably it's better than flush the buffer somewhere. MC's response may
%be slow and buffer may be flushed before all the data arrives.
fread(s,48); 

end %function
