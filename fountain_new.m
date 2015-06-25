close all;
clear all;

% Initialisierung der verschiedenen Vektoren
k = 2; % Anzahl der Spalten der Generatormatrix
e = 20; % Anzahl der Ersatzspalten
ke=max(k,e)+1;
for x = 1:e+1; XK(x) = x-1; end;
RK  = zeros(1,ke);
RK2 = zeros(1,ke);
RKD = zeros(1,ke);
RKE = zeros(1,ke);

%Reihe der Glieder (1-2**(-x))
for x = ke:-1:1
    RK(ke-x+1) = (1-power(2,(-x)));
end

%Produkterme akkumuliert von oben und von unten
RKD(1) = RK(1);
for x = 2:1:ke
    RKD(x) = RKD(x-1)*RK(x);
end

RKE(1) = 0; RKE(2)=RK(ke);
RK2(1) = 0; RK2(2)=0.5;
for x = 3:1:ke
    RKE(x) = RKE(x-1) * RK(ke+2-x);
    RK2(x) = power(2,(-x+1));
end

% Berechnung des Exponenten
for x = 0:1:e
    exp(x+1) = 0;
    for y = 0:1:min(k,x)
        fak(y+1) = nchoosek(k,y)*nchoosek(x,y);
        exp(x+1) = exp(x+1) + fak(y+1);
    end
end

% Ausgabe zum Test
RK, RKD, RKE, RK2, exp

% Zum Vergleich mit Handrechnungen
test = zeros(1,ke);
test(1) = 1-0.3750;
test(2) = 1-0.6562;
test(3) = 1-0.8203; 
test(4) = 1-0.9082;
test(5) = 1-0.9536; % Manuel's Lösung

% Jetzt rechnen:
for x = 0:1:e
    % Näherungsformel
    FT(x+1)  = (1-RKD(ke-x)); % Invertierbare Untermatrix (nur gültig für k > e --> ke = k+1)
    % Genaue(re) Formel
    % FTM(x+1) = test(x+1); % Manuel
    % FTM(x+1) = (1-RKD(ke-x))+RKD(ke-x)*power(RKE(x+1),exp(x+1)); % Thorsten
    FTM(x+1) = (1-power(2,(-k)))*power(2,(-x)); % Shokrollahi
    % Obere Schranke
    FTU(x+1) = power(2,-(x));
end
 
subplot(1,2,1);
plot(XK,FT, 'b-+','LineWidth',2); hold on;
plot(XK,FTM,'r-s','LineWidth',2);
plot(XK,FTU,'g-*','LineWidth',2);
xlabel('#information symbols k');
ylabel('delta');
axis([0 e 0 1]); axis 'auto y';
grid on;

subplot(1,2,2);
semilogy(XK,FT, 'b-+','LineWidth',2); hold on;
semilogy(XK,FTM,'r-s','LineWidth',2);
semilogy(XK,FTU,'g-*','LineWidth',2);
xlabel('#information symbols k');
ylabel('delta');
axis([0 e 1e-3 1]); axis 'auto y';
grid on;
