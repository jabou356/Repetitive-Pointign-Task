myfig=figure('Name','Mean joint angles', ...
    'Color', 'none', ...
    'NumberTitle', 'off', ...
    'Units', 'centimeters', ...
    'Position', [1.5, 1, 16.5, 22], ...
    'OuterPosition', [0, 0, 18, 24])
    
    myax(1)=subplot(4,5,1);
    myax(2)=subplot(4,5,2);
    myax(3)=subplot(4,5,[3 4]);
    
    myax(4)=subplot(4,5,5);
    myax(5)=subplot(4,5,6);
    myax(6)=subplot(4,5,[7 8]);
    
    myax(7)=subplot(4,5,9);
    myax(8)=subplot(4,5,10);
    myax(9)=subplot(4,5,[11 12]);
    
    myax(10)=subplot(4,5,13);
    myax(11)=subplot(4,5,14);
    myax(12)=subplot(4,5,[15 16]);
    
    myax(13)=subplot(4,5,17);
    myax(14)=subplot(4,5,18);
    myax(15)=subplot(4,5,[19 20]);
    
    for i=[1,2,4,5,7,8,10,11,13,14]
        myax(i)