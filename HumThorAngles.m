data=imported.data*pi/180;
for i=1:length(data(:,2))
    
Rhum(:,:,i)=rotation(data(i,5),'x')*rotation(data(i,6),'y')*rotation(data(i,7),'z');
Rth(:,:,i)=rotation(data(i,11),'x')*rotation(data(i,12),'y')*rotation(data(i,13),'z');

end
Rhum=Rhum(1:3,1:3,:);
Rth=Rth(1:3,1:3,:);

glob=[1,0,0;0,1,0;0,0,1];

for i=1:length(data(:,2))
hum(:,:,i)=Rhum(:,:,i)*glob(:,:);
th(:,:,i)=Rth(:,:,i)*glob(:,:);
Rhumth(:,:,i)=hum(:,:,i)*th(:,:,i)';
end

[Y1, X, Y2]= angleRotation(Rhumth(:,:,i),'yxy');
