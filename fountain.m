close all;
clear all;

% Initialisierung der verschiedenen Vektoren
k = 50;
for x = 1:k; XK(x) = x-1; end;
RK  = zeros(1,k); 
RK2 = zeros(1,k);
RKD = zeros(1,k);
RKE = zeros(1,k);

%Reihe der Glieder (1-2**(-x))
for x = k:-1:1
    RK(k-x+1) = (1-power(2,(-x)));
end

%Produkterme akkumuliert von oben und von unten
RKD(1) = RK(1);
for x = 2:1:k
    RKD(x) = RKD(x-1)*RK(x);
end

RKE(1) = RK(k);
RK2(1) = 0.5;
for x = 2:1:k
    RKE(x) = RKE(x-1) * RK(k+1-x);
    RK2(x) = power(2,(-x));
end

% Ausgabe zum Test
 RK, RK2, RKD, RKE

% Berechnung (k über e) ohne große Fakultäten
for x = 1:1:k
    expvec(x) = nchoosek(k,x);
end

% Jetzt rechnen:
for x = 1:1:k
    % Restfehler trotz der Permutationen der Ersatzspalten
    %(1-power(RKE(x),expvec(x)))
    
    % Näherungsformel
    FT(x)  = (1-RKD(k+1-x));
    % Genaue Formel
    FTM(x) = (1-RKD(k+1-x))*(1-power(RK2(x),expvec(x)));
    % Obere Schranke
    FTU(x) = power(2,-(x-1));
end

% Number of additional symbols
e=10;

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
axis([0 e 1e-3 1]);
grid on;
