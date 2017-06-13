function R = Cardan2Mat(alpha, beta, gamma)

n=length(alpha);
for i=1:n,
    R(1,1,i) =   cos(beta(i))*cos(gamma(i));
    R(1,2,i) =  -cos(beta(i))*sin(gamma(i));
    R(1,3,i) =   sin(beta(i));
    R(2,1,i) =   cos(alpha(i))*sin(gamma(i))+sin(alpha(i))*sin(beta(i))*cos(gamma(i));
    R(2,2,i) =   cos(alpha(i))*cos(gamma(i))-sin(alpha(i))*sin(beta(i))*sin(gamma(i));
    R(2,3,i) =  -sin(alpha(i))*cos(beta(i));
    R(3,1,i) =   sin(alpha(i))*sin(gamma(i))-cos(alpha(i))*sin(beta(i))*cos(gamma(i));
    R(3,2,i) =   sin(alpha(i))*cos(gamma(i))+cos(alpha(i))*sin(beta(i))*sin(gamma(i));
    R(3,3,i) =   cos(alpha(i))*cos(beta(i));
end
