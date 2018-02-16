function [P,I,D, current_limit] = lecture_coeffs(s)
%Prints out parameters of the hand (PID, current)

%Mots de commande pour lecture et position du registre
%-------------------------------------------------------------------
mot_commande=hex2dec('52');%<--- R
mot_commande2=hex2dec('44');%<--- D
registre_faible=hex2dec('01');
registre_fort=hex2dec('00');

w_len = 12; %Word length defined by protocol
w_s = 7; %Data starting position in word
w_e = 10; %Data end position
to_take = w_s:w_e;
fs = repmat('%02X', 1, 4);


%------------------------choix du doigt----------------------------------------

%valeurs en hexa recuperer par la formule dans le pdf protocole
%registre 9: COEF_I
for i=1:3
    if i==1
        Pos_mem_faible=hex2dec('C0');
        Pos_mem_fort=hex2dec('0B');
    elseif i==2
        Pos_mem_faible=hex2dec('C1');
        Pos_mem_fort=hex2dec('0B');
    elseif i==3
        Pos_mem_faible=hex2dec('C2');
        Pos_mem_fort=hex2dec('0B');
    end
    
%CRC16 calcul
    buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
    [crc16hi,crc16lo]=CRC16(buf);

    fwrite(s,[buf,crc16lo,crc16hi]);

    response = fread(s,w_len);
 %Lecture et affichage des valeurs P,I et D
    coeff_hex = sprintf(fs,response(to_take(end:-1:1)));
    coeff=hex2dec(coeff_hex);
    if i==1
        P = coeff;
        affichage =['coefficient P = ',num2str(coeff)];
        disp(affichage);
    elseif i==2
        I = coeff;
        affichage = ['coefficient I = ',num2str(coeff)];
        disp(affichage);
    else
        D = coeff;
        affichage =['coefficient D = ',num2str(coeff)];
        disp(affichage);
    end 
  flushinput(s);  
end 

Pos_mem_faible=hex2dec('BA');
Pos_mem_fort=hex2dec('0B');

buf=[mot_commande,mot_commande2,Pos_mem_faible,...
    Pos_mem_fort,registre_faible,registre_fort];
    [crc16hi,crc16lo]=CRC16(buf);

    fwrite(s,[buf,crc16lo,crc16hi]);
    pause(1);
    response = fread(s,w_len);
%Lecture et affichage de la limite de courant    
    coeff_hex = sprintf(fs,response(to_take(end:-1:1)));
    coeff=hex2dec(coeff_hex);
    current_limit = coeff;
    affichage =['Limite courant = ',num2str(coeff)];
        disp(affichage);
return;

    