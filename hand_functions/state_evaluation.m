function [state_next,gesture,wait_cocontr,hyst_counter] = state_evaluation(emav,win_update,ch,   noise_threshold,cocontr_hyst,wait_cocontr,activ_hyst, hyst_counter,    state,gesture,n_gestures)

%ToDo:
%1) Replace this strange ~above_th_emav with simple >
%2) Save the state of hyst_counter between function runs

ch1 = ch(1); %intrinsic muscles
ch2 = ch(2); %extrinsic muscles
threshold1 = noise_threshold(1); %noise in first channel
threshold2 = noise_threshold(2); %...

state_next = state;
%hyst_counter = zeros(1,2);

%Possible states: 0 - Resting state, 1 - Flexion, 2 - Extension, 3 - %Co-contraction
switch state
    case 0
    %% RESTING STATE. SIGNALS ARE MONITORED UNTIL ONE OF THEM EXCEEDS THE NOISE THRESHOLD
    for i = (activ_hyst-1):-1:0
        %IT MONITORS BOTH SIGNALS UNTIL ONE OF THEM EXCEEDS ITS OWN THRESHOLD
        hyst_counter(1,1) = hyst_counter(1,1)+1;
        hyst_counter(1,2) = hyst_counter(1,2)+1;
        if(~above_th_emav(emav(end-i,ch1),threshold1))
            hyst_counter(1,1) = 0;
        end
        if(~above_th_emav(emav(end-i,ch2),threshold2))
            hyst_counter(1,2) = 0;
        end
        
        %DEFINE THE NEXT STATE
        if hyst_counter(1,1) >= cocontr_hyst && hyst_counter(1,2) >= cocontr_hyst
            state_next = 3;
            %state_changed_inside_the_batch = 1;
            hyst_counter(1) = 0; hyst_counter(2) = 0;
            break;
        elseif hyst_counter(1,1) >= activ_hyst  %channel 1 active
            state_next = 1;
            hyst_counter(1) = 0; hyst_counter(2) = 0;
            break;
        elseif hyst_counter(1,2) >= activ_hyst %channel 2 active
            state_next = 2;
            hyst_counter(1) = 0; hyst_counter(2) = 0;
            break;
        end %if
    end %for
    
        
    case 1
    %% CHANNEL 1 ACTIVE.  
    for i = (activ_hyst-1):-1:0
        
        %Monitoring the active channel to pass to resting state when
        %desactivated
        hyst_counter(1,1) = hyst_counter(1,1)+1;
        if (~under_th_emav(emav(end-i,ch1),threshold1))
            hyst_counter(1,1) = 0;
        end
        %Pass to resting state if the signal in currently active channel
        % becomes inactive
        if hyst_counter(1,1) >= activ_hyst
            state_next = 0; %resting state
            hyst_counter(1) = 0; hyst_counter(2) = 0;
            break;
        end
        
        %Monitoring the inactive channel to pass to cocontraction when
        %it's activated (currently not used because produces false
        %cocontractions
%         hyst_counter(1,2) = hyst_counter(1,2)+1;
%         if(~above_th_emav(emav(end-i,ch2),threshold2))
%             hyst_counter(1,2) = 0;
%         end 
%         %Pass to co-contraction state if the signal in currently inactive
%         %channel becomes active
%         if hyst_counter(1,2) >= cocontr_hyst
%             state_next = 3; %co-contraction
%             sound(beep,fs_beep);
%             hyst_counter(1) = 0; hyst_counter(2) = 0;
%             break;
%         end
    end
              
    case 2
    %% CHANNEL 2 ACTIVE. 
    
    for i = (activ_hyst-1):-1:0  
        %Monitoring the active channel to pass to resting state when
        %desactivated
        hyst_counter(1,2) = hyst_counter(1,2)+1;
        if(~under_th_emav(emav(end-i,ch2),threshold2))
            hyst_counter(1,2) = 0;
        end
        %Pass to resting state if the signal in currently active channel
        % becomes inactive
        if hyst_counter(1,2) >= activ_hyst
            state_next = 0; %resting state
            hyst_counter(1) = 0; hyst_counter(2) = 0;
            break;
        end
        
%         %Monitoring the inactive channel to pass to cocontraction when
%         %it's activated (currently not used because produces false
%         hyst_counter(1,1) = hyst_counter(1,1)+1;
%         if(~above_th_emav(emav(end-i,ch1),threshold1))
%             hyst_counter(1,1) = 0;
%         end
%         %Pass to co-contraction state if the signal in currently inactive
%         %channel becomes active
%         if hyst_counter(1,1) >= cocontr_hyst
%             state_next = 3; %co-contraction
%             sound(beep,fs_beep);
%             hyst_counter(1) = 0; hyst_counter(2) = 0;
%             break;
%         end
    end        
        
    case 3
    %% CO-CONTRACTION. THE MOTION CHANGES.
    
        for i = (activ_hyst-1):-1:0
        %MONITOR BOTH CHANNELS UNTIL BOTH GO DOWN THE THRESHOLD    
            hyst_counter(1,1) = hyst_counter(1,1)+1;
            hyst_counter(1,2) = hyst_counter(1,2)+1;
            if(~under_th_emav(emav(end-i,ch1),threshold1))
                hyst_counter(1,1) = 0;
            end
            if(~under_th_emav(emav(end-i,ch2),threshold2))
                hyst_counter(1,2) = 0;
            end
            
            if hyst_counter(1,1) >= cocontr_hyst && hyst_counter(1,2) >= cocontr_hyst
                state_next = 0;
                gesture = mod(gesture,n_gestures) + 1;
                hyst_counter(1) = 0; hyst_counter(2) = 0;
                break;
            end
            % First channel passes to zero - go to opening state (2)
            if hyst_counter(1,1) >= activ_hyst
                state_next = 2;
                gesture = mod(gesture,n_gestures) + 1;
                hyst_counter(1) = 0; hyst_counter(2) = 0;
                break;
            end
            % Second channel passes to zero - go to closing state (2)
            if hyst_counter(1,2) >= activ_hyst
                state_next = 1;
                gesture = mod(gesture,n_gestures) + 1;
                hyst_counter(1) = 0; hyst_counter(2) = 0;
                break;
            end
        end
        
end %switch


end %function