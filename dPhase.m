function DPh = dPhase(f1,f2)
%  dPhase : calculate the phases difference between two complex function values
%
% INPUTS
%  f1     : complex function value
%  f2     : complex function value
%
% OUTPUTS
%  DPh    : phases difference
%

temp = (abs(real(f1))==0) & (abs(imag(f1))==0);
f1(temp) = NaN;
f1(isinf(f1)) = NaN;

temp = (abs(real(f2))==0) & (abs(imag(f2))==0);
f2(temp) = NaN;
f2(isinf(f2)) = NaN;

DPh=angle(f2)-angle(f1);

DPh(isnan(DPh)) = pi;
temp = DPh>pi;
DPh(temp) = DPh(temp)-2*pi;

temp = DPh<-pi;
DPh(temp) = DPh(temp)+2*pi;

end

