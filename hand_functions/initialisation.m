function initialisation(s)
% paramètre d'entrée: le port série s 
%
% Objectif: initialiser la main 
%
% méthode :écrit la valeur 1 dans le registre situé
%          à l'adresse 100, en utilisant le code commande "WR" 
%
%

%-----------PARTIE INITIALISATION MESSAGE BOX------------------------------
%barre de chargement vide pour le commencement
box1=waitbar(0,'0%','Name','initialisation...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(box1,'canceling',0)
steps=2650;%<-- MAGIE: testé plusieur fois en metteant une incrémentation dans le while mais 
            %   la valeur est différente à chaque fois
n=0;

%-----------PARTIE INITIALISATION MAIN---------------------
code_ascii_W=hex2dec('57');
code_ascii_R=hex2dec('52');
pos_mem_faible=hex2dec('64');
pos_mem_fort=hex2dec('00');
nb_registre_faible=hex2dec('01');
nb_registre_fort=hex2dec('00');
poids_valeur1_1=hex2dec('01');%  ]
poids_valeur1_2=hex2dec('00');%  } poids de la valeur à
poids_valeur1_3=hex2dec('00');%  } écrire dans le registre
poids_valeur1_4=hex2dec('00');%  ]


buf=[code_ascii_W,code_ascii_R,pos_mem_faible,pos_mem_fort,nb_registre_faible,...
    nb_registre_fort,poids_valeur1_1,poids_valeur1_2,poids_valeur1_3,poids_valeur1_4];

[crc16hi,crc16lo]=CRC16(buf);

fwrite(s,[buf,crc16lo,crc16hi]);

for i=1:8
    fread(s,1);
end
%-------------PARTIE LECTURE DE FIN--------------------------


%lecture du registre de l'initialisation

code_ascii_R=hex2dec('52');
code_ascii_D=hex2dec('44');
pos_mem_faible1=hex2dec('64');
pos_mem_fort1=hex2dec('00');
nb_registre_faible1=hex2dec('01');
nb_registre_fort1=hex2dec('00');
buf2=[code_ascii_R,code_ascii_D,pos_mem_faible1,pos_mem_fort1,nb_registre_faible1,...
    nb_registre_fort1];
[crc16hi_2,crc16lo_2]=CRC16(buf2);


condition=true;%<-----crétaion d'une boucle do while 
while condition
fwrite(s,[buf2,crc16lo_2,crc16hi_2]);

pourcent= floor((n/steps)*100);%<----- Pour affichage sur la fenêtre du pourcentage
if pourcent<= 100
    waitbar(n/steps,box1,sprintf('%d%% ',pourcent));%<-- chargement de la barre et maj du texte
else  waitbar(n/steps,box1,'100% ')
end
if getappdata(box1,'canceling')%<--- bouton cancel de la message box
     
     %----ARRET INITIALISATION EN COUR---   
     poids_valeur2_1=hex2dec('00');%<-- stop initialisation en changeant le poids d'un registre  
     buf=[code_ascii_W,code_ascii_R,pos_mem_faible,pos_mem_fort,nb_registre_faible,...
     nb_registre_fort,poids_valeur2_1,poids_valeur1_2,poids_valeur1_3,poids_valeur1_4];
     [crc16hi,crc16lo]=CRC16(buf);
     
     fwrite(s,[buf,crc16lo,crc16hi]);%<--- appel un registre pour stoper l'initialisation
     %------------------------------------
     
     delete(box1);%<---- ferme la fenêtre de la message box
     n=0;%<-- remet le pourcentage à 0
 end
n=n+1;% incrémentation du pourcentage

    for i=1:12 %lecture des valeurs
       val=fread(s,1);
       
       if i==7 %<---- seul valeur qui est sensé changer (sauf CRC16)
           if val==1;% passage de 0 à 1 pour la valeur du poids faible du mot
               condition =false;%<--- sortie de boucle
               waitbar(n/steps,box1,'terminé');%<-- affiche terminé
               pause(0.2);%<-- pas forcément utile 
               delete(box1);%<-- ferme la message box
           end
       end
    end
    
end

end
