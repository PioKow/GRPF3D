function w  = fun(F,varargin)
%  fun: function definition
%       problem involve concentric cylindrical waveguive
%       filled two various dielectric
%       z = alfa + j Beta
%       f = frequency
%       the function is results from the combination of
%       fields on the boundary of the dielectrics
%       zeroing the determinant involves meeting these conditions
%
% INPUTS
%  F          : function argument F = [alfa, beta, frequency]
%  varargin   : some optional parameters
%
% OUTPUTS
%  w          : function value
%

alpha_n = F(1); %alfa
beta_n = F(2);  %beta
f = F(3);       %frequnecy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 3e+8;              %
mu0 = 4 * pi * 1e-7;   % constants
eps0 = 1e-9 / 36 / pi; %

a = 6.35e-3;           % inner dielectric radius
b = 10.0e-3;           % waveguide radius  (conductor)
eps_r1 = 10;           % relative permittivity first medium (inner)
eps_r2 = 1;            % relative permittivity second medium (outer)
m = 1;                 % angular varability of the mods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

omega = 2*pi*f;
k0 = omega/c;
alpha=alpha_n*k0;
beta=beta_n*k0;
gama=alpha+1j*beta;
eps1=eps0*eps_r1;
eps2=eps0*eps_r2;
mu1=mu0;
mu2=mu0;
kappa1 = sqrt(gama^2 + k0^2*eps_r1);
kappa2 = sqrt(gama^2 + k0^2*eps_r2);

Jm_a1 = besselj(m,kappa1*a);
DJm_a1 = diff_besselj(m,kappa1*a);

Jm_a2 = besselj(m,kappa2*a);
DJm_a2 = diff_besselj(m,kappa2*a);
Ym_a2 = bessely(m,kappa2*a);
DYm_a2 = diff_bessely(m,kappa2*a);

Jm_b2 = besselj(m,kappa2*b);
DJm_b2 = diff_besselj(m,kappa2*b);
Ym_b2 = bessely(m,kappa2*b);
DYm_b2 = diff_bessely(m,kappa2*b);

%creating determinant
w = [
    Jm_a1                         0                              -Jm_a2                       -Ym_a2                       0                                0
    0                             Jm_a1                          0                            0                            -Jm_a2                           -Ym_a2
    gama*m*Jm_a1/(a*kappa1^2)     1j*omega*mu1*DJm_a1/kappa1     -gama*m*Jm_a2/(a*kappa2^2)   -gama*m*Ym_a2/(a*kappa2^2)   -1j*omega*mu2*DJm_a2/kappa2      -1j*omega*mu2*DYm_a2/kappa2
    -1j*omega*eps1*DJm_a1/kappa1  -m*gama*Jm_a1/(a*kappa1^2)     1j*omega*eps2*DJm_a2/kappa2  1j*omega*eps2*DYm_a2/kappa2  m*gama*Jm_a2/(a*kappa2^2)        m*gama*Ym_a2/(a*kappa2^2)
    0                             0                              Jm_b2                        Ym_b2                        0                                0
    0                             0                              gama*m*Jm_b2/(b*kappa2^2)    gama*m*Ym_b2/(b*kappa2^2)    1j*omega*mu2*DJm_b2/kappa2       1j*omega*mu2*DYm_b2/kappa2
    ];

w=det(w)*(gama-1j*k0)^2;

end

function DJm = diff_besselj(m,x)
%determination of the derivative of the first kind Bessel function
    DJm = (besselj(m-1,x)-besselj(m+1,x))/2;
end

function DYm = diff_bessely( m , x )
%determination of the derivative of the second kind Bessel function
    DYm = (bessely(m-1,x)-bessely(m+1,x))/2;
end

