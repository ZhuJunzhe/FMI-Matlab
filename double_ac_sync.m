function [ output_args ] = double_ac_sync( input_args )
%DOUBLE_AC_SYNC Summary of this function goes here
%   Detailed explanation goes here

time=16;
x=ones(1,time);
y=padarray(x',10,'post');
z=padarray(y,160,1,'pre');
[xc,lags]=xcorr(z,y);
acf=fftshift(xc./time);
lags=fftshift(lags);
limit=floor(length(lags)/2);
plot(lags(1:limit),acf(1:limit));

return;
time=32;
x=ones(1,time);
y=padarray(x',100,'post');
z=padarray(y,32,1,'pre');
[xc,lags]=xcorr(z,y);
plot(lags,xc)
return
acf=fftshift(xc./time);
lags=fftshift(lags);
limit=floor(length(lags)/2);
plot(lags(1:limit),acf(1:limit));