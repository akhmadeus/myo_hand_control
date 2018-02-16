
function ecriture_limite_courant(doigt,coeff,s)% coeff valable entre 0 et 750

% -------------- COEFFICIENT: création d'un mot -----------------

if coeff > 750
    coeff_reel = 750;
elseif coeff < 0
    coeff_reel = 0;
else
    coeff_reel = coeff;
end
coeff_hex=dec2hex(coeff_reel);%<---transformation de la position en hexa
%                         gère la taille du mot en hexa dut au faite que
%                         l'on renverse le mot donc que si le mot est plus
%                         petit que 4 (le max) alors les zeros utiles
%                         serons au début et donc supprimé par matlab
if length(dec2hex(coeff_reel))==8
    coeff_fort3=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_fort2=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));
    coeff_fort=hex2dec(strcat(coeff_hex(5),coeff_hex(6)));
    coeff_faible=hex2dec(strcat(coeff_hex(7),coeff_hex(8)));
    
elseif length(dec2hex(coeff_reel))==7
    coeff_fort3=hex2dec(coeff_hex(1));
    coeff_fort2=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));
    coeff_fort=hex2dec(strcat(coeff_hex(4),coeff_hex(5)));
    coeff_faible=hex2dec(strcat(coeff_hex(6),coeff_hex(7)));

elseif length(dec2hex(coeff_reel))==6
    coeff_fort3=0;
    coeff_fort2=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_fort=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));
    coeff_faible=hex2dec(strcat(coeff_hex(5),coeff_hex(6)));

elseif length(dec2hex(coeff_reel))==5
    coeff_fort3=0;
    coeff_fort2=hex2dec(coeff_hex(1));
    coeff_fort=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));
    coeff_faible=hex2dec(strcat(coeff_hex(4),coeff_hex(5)));
    
elseif length(dec2hex(coeff_reel))==4
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    coeff_faible=hex2dec(strcat(coeff_hex(3),coeff_hex(4)));
                            
elseif length(dec2hex(coeff_reel))==3%<-- si taille du mot est de trois alors le mot de
    %                          poids fort seras la position 3 du mot et '0'
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=hex2dec(coeff_hex(1));
    coeff_faible=hex2dec(strcat(coeff_hex(2),coeff_hex(3)));

elseif  length(dec2hex(coeff_reel))==2%<-- si taille du mot est de deux alors le mot de
    %                          poids fort seras '00'
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=0;
    coeff_faible=hex2dec(strcat(coeff_hex(1),coeff_hex(2)));
    
elseif  length(dec2hex(coeff_reel))==1%<-- si taille du mot est de un alors le mot de
    %                          poids fort seras '00' et celui de poids
    %                          faible sera position 1 du mot et '0'
    coeff_fort3=0;
    coeff_fort2=0;
    coeff_fort=0;
    coeff_faible=hex2dec(coeff_hex(1));
end

     
            


%------------------------choix du doigt----------------------------------------

%valeurs en hexa recuperer par la formule dans le pdf protocole
%registre 8: COEF_P

if doigt==0,%rotation pouce
    Pos_mem_faible=hex2dec('EA');%<--- poids faible de la premiere position memoire
    Pos_mem_fort=hex2dec('03');%<--- poids fort de la premiere position memoire
    
elseif doigt==1,%pouce
    Pos_mem_faible=hex2dec('D2');
    Pos_mem_fort=hex2dec('07');
    
elseif doigt==2,%index
    Pos_mem_faible=hex2dec('BA');
    Pos_mem_fort=hex2dec('0B');
    
elseif doigt==3,%majeur
    Pos_mem_faible=hex2dec('A2');
    Pos_mem_fort=hex2dec('0F');
    
elseif doigt==4,%annulaire
    Pos_mem_faible=hex2dec('8A');
    Pos_mem_fort=hex2dec('13');
    
elseif doigt==5,%auriculaire
    Pos_mem_faible=hex2dec('72');
    Pos_mem_fort=hex2dec('17');
    
end

%-------------------------------------------------------------------
flushinput(s);
mot_commande=hex2dec('57');%<--- W
mot_commande2=hex2dec('52');%<--- R
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

%CRC16 calcul
buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort,coeff_faible,coeff_fort,coeff_fort2,coeff_fort3];
[crc16hi,crc16lo]=CRC16(buf);

fwrite(s,[buf,crc16lo,crc16hi]);%Ecriture dans le registre
fread(s,8);

end



