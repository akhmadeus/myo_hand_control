function ecriture_courant_all_fingers(val,s)
    for i=0:5
        ecriture_limite_courant(i,val,s);
    end
    % this function is a loop of the function ecriture_limite_courant to
    % change the maximum current allowed in the six motors.