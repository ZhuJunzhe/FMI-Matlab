function [ y ] = inc( x )

assignin('caller', inputname(1), x + 1);
y=x+1;