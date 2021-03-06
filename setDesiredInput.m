function [linVel_L,linVel_R,wristVel_L,wristVel_R,grip_L,grip_R] = setDesiredInput(jamboxx)
% Sets desired linear velocity, wrist joint velocities, and grip positions
% using jamboxx

    x = jamboxx.X;
    air = jamboxx.Air;
    linVel_L = [0;0;0];
    linVel_R = [0;0;0];
    wristVel_L = [];
    wristVel_R = [];
    grip_L = [];
    grip_R = [];
    
    if air > 0.1
        % Left arm
        if (x > 0.882) && (x < 1) % W2+
            wristVel_L = [0;0;1];
        elseif (x > 0.741) && (x < 0.829) % W1+
            wristVel_L = [0;0.7;0];
        elseif (x > 0.593) && (x < 0.687) % W0+
            wristVel_L = [0.7;0;0];
        elseif (x > 0.453) && (x < 0.546) % left
            linVel_L = [0;0.08;0];
        elseif (x > 0.301) && (x < 0.401) % forward
            linVel_L = [0.08;0;0];
        elseif (x > 0.018) && (x < 0.114) % up
            linVel_L = [0;0;0.09];
        elseif (x > 0.163) && (x < 0.263) % open
            grip_L = single(100);
        % Right arm
        elseif (x > -0.972) && (x < -0.877) % W2+
            wristVel_R = [0;0;1];
        elseif (x > -0.833) && (x < -0.734) % W1+
            wristVel_R = [0;0.7;0];
        elseif (x > -0.691) && (x < -0.594) % W0+
            wristVel_R = [0.7;0;0];
        elseif (x > -0.543) && (x < -0.450) % left
            linVel_R = [0;0.08;0];
        elseif (x > -0.405) && (x < -0.305) % forward
            linVel_R = [0.08;0;0];
        elseif (x > -0.117) && (x < -0.033) % up
            linVel_R = [0;0;0.09];
        elseif (x > -0.258) && (x < -0.168) % open
            grip_R = single(100);   
        end        
    elseif air < -0.1
        % Left arm
        if (x > 0.882) && (x < 1) % W2-
            wristVel_L = [0;0;-1];
        elseif (x > 0.741) && (x < 0.829) % W1-
            wristVel_L = [0;-0.7;0];
        elseif (x > 0.593) && (x < 0.687) % W0-
            wristVel_L = [-0.7;0;0];
        elseif (x > 0.453) && (x < 0.546) % right
            linVel_L = [0;-0.08;0];
        elseif (x > 0.301) && (x < 0.401) % backward
            linVel_L = [-0.08;0;0];
        elseif (x > 0.018) && (x < 0.114) % down
            linVel_L = [0;0;-0.09];
        elseif (x > 0.163) && (x < 0.263) % close
            grip_L = single(0);
        % Right arm
        elseif (x > -0.972) && (x < -0.877) % W2-
            wristVel_R = [0;0;-1];
        elseif (x > -0.833) && (x < -0.734) % W1-
            wristVel_R = [0;-0.7;0];
        elseif (x > -0.691) && (x < -0.594) % W0-
            wristVel_R = [-0.7;0;0];
        elseif (x > -0.543) && (x < -0.450) % right
            linVel_R = [0;-0.08;0];
        elseif (x > -0.405) && (x < -0.305) % backward
            linVel_R = [-0.08;0;0];
        elseif (x > -0.117) && (x < -0.033) % down
            linVel_R = [0;0;-0.09];
        elseif (x > -0.258) && (x < -0.168) % close
            grip_R = single(0);   
        end     
    end

end