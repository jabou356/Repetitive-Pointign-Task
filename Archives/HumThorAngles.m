function [ HumThor ] = HumThorAngles( data )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

glob=[1,0,0;0,1,0;0,0,1];
humchan=[5 6 7];
phumchan=[17 18 19];
thchan=[11 12 13];

for i=1:length(data(:,2))
    
    Rhum(:,:,i)=rotation(data(i,humchan(1)),'x')*rotation(data(i,humchan(2)),'y')*rotation(data(i,humchan(3)),'z');
    Rth(:,:,i)=rotation(data(i,thchan(1)),'x')*rotation(data(i,thchan(2)),'y')*rotation(data(i,thchan(3)),'z');
    Rphum(:,:,i)=rotation(data(i,phumchan(1)),'x')*rotation(data(i,phumchan(2)),'y')*rotation(data(i,phumchan(3)),'z');

end

Rhum=Rhum(1:3,1:3,:);
Rth=Rth(1:3,1:3,:);
Rphum=Rphum(1:3,1:3,:);

for i=1:length(data(:,2))
    hum(:,:,i)=Rhum(:,:,i)*glob(:,:);
    th(:,:,i)=Rth(:,:,i)*glob(:,:);
    phum(:,:,i)=Rphum(:,:,i)*glob(:,:);
    
    PHUMth(:,:,i)=Rth(:,:,i)'*phum(:,:,i);
    HUMphum(:,:,i)=Rphum(:,:,i)'*hum(:,:,i);
    
    Rphumth(:,:,i)=PHUMth(:,:,i)*glob(:,:)';
    Rhumphum(:,:,i)=HUMphum(:,:,i)*glob(:,:)';


[HumThor.Y1(i), HumThor.X(i)]= angleRotation(Rphumth(:,:,i),'yx');
[HumThor.Y2(i)]= angleRotation(Rhumphum(:,:,i),'y');

end

HumThor.Y1=HumThor.Y1*180/pi; HumThor.X=HumThor.X*180/pi; HumThor.Y2=HumThor.Y2*180/pi;

 

end

