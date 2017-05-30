function R = rotation(angle,axe)

c=cos(angle);
s=sin(angle);


switch axe
    case 'x', R=[1 0 0; 0 c -s; 0, s,c];
    case 'y', R=[c,0,s; 0 1 0;-s,0,c];
    case 'z', R=[c, -s,0; s,c 0; 0 0 1];
end

R = [R zeros(3,1); 0 0 0 1];