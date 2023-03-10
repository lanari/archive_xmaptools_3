function [Si_T, Al_T, Na_M1, Ca_M1, K_M1, XAb, XAn, XMc, Xsum, SumT, SumM] = StructFctFeldspar(Data,handles)
% -
% XMapTools External Function: Structural formula of feldspars (Ca,Na,K) 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Feldspars>Feld-StrucForm>StructFctFeldspar>Si_T Al_T Na_M1 Ca_M1 K_M1 
%     XAb XAn XMc Xsum SumT SumM>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   8 Oxygens
%
% 
% Created by P. Lanari (Octobre 2011) - Last update 19.08.2018
% Find out more at http://www.xmaptools.com


Si_T = zeros(1,length(Data(:,1)));
Al_T = zeros(1,length(Data(:,1)));
Na_M1 = zeros(1,length(Data(:,1)));
Ca_M1 = zeros(1,length(Data(:,1)));
K_M1 = zeros(1,length(Data(:,1)));
XAb = zeros(1,length(Data(:,1)));
XAn = zeros(1,length(Data(:,1)));
XMc = zeros(1,length(Data(:,1)));
Xsum = zeros(1,length(Data(:,1)));
SumT = zeros(1,length(Data(:,1)));
SumM = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 8; % Oxygens, DO NOT CHANGE !!!


% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass


for i = 1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);
    
    if Analyse(1) > 0.0001 % detection...
        OnCal = 1;
    else
        OnCal = 0;
    end

    TravMat = []; % initialization required... 

    if OnCal
        TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
        TravMat(5) = 0; % Fe2O3
        TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si = lesResults(1);
        Ti = lesResults(2);
        Al = lesResults(3); 
        Fe = lesResults(4)+ lesResults(5);
        Mn = lesResults(6);
        Mg = lesResults(7);
        Ca = lesResults(8); 
        Na = lesResults(9); 
        K = lesResults(10);


        % Structural Formulae (P. Lanari - 2011)
        
   
        Si_T(i) = Si;
        Al_T(i) = Al;
        
        K_M1(i) = K;
        Na_M1(i) = Na;
        Ca_M1(i) = Ca;
        
        % Solid solution model
        XAb(i) = Na/(Na+Ca+K);
        XAn(i) = Ca/(Na+Ca+K);
        XMc(i) = K/(Na+Ca+K);
        
        Xsum(i) = XAb(i)+XAn(i)+XMc(i);

        SumT(i) = Si + Al; % T -sites
        SumM(i) = K + Na + Ca; % M-sites
        

        if Si_T(i) < 0 ||  Al_T(i) < 0 || Na_M1(i) < 0 || Ca_M1(i) < 0 || ...
           K_M1(i) < 0 || XAb(i) < 0 || XAn(i) < 0 || ...
           XMc(i) < 0 || Xsum(i) < 0 
       
            
            Si_T(i) = 0;
            Al_T(i) = 0;
            Na_M1(i) = 0;
            Ca_M1(i) = 0;
            K_M1(i) = 0;
            XAb(i) = 0;
            XAn(i) = 0;
            XMc(i) = 0;
            Xsum(i) = 0;
            SumT(i) = 0;
            SumM(i) = 0;
        end
        
    else
            Si_T(i) = 0;
            Al_T(i) = 0;
            Na_M1(i) = 0;
            Ca_M1(i) = 0;
            K_M1(i) = 0;
            XAb(i) = 0;
            XAn(i) = 0;
            XMc(i) = 0;
            Xsum(i) = 0;
            SumT(i) = 0;
            SumM(i) = 0;
    end
end

XmapWaitBar(1,handles);




return




