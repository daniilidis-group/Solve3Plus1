function [E,S] = SolveConstrained3ptClosed(q,qp)

a11 = -1-qp(1,1)*q(1,1);
a12 = qp(2,1)*q(1,1);
a13 = -q(1,1)+qp(1,1);
a14 = -qp(2,1);
a15 = q(2,1);
a16 = -qp(1,1)*q(2,1);

a21 = -1-qp(1,2)*q(1,2);
a22 = qp(2,2)*q(1,2);
a23 = -q(1,2)+qp(1,2);
a24 = -qp(2,2);
a25 = q(2,2);
a26 = -qp(1,2)*q(2,2);

a31 = -1-qp(1,3)*q(1,3);
a32 = qp(2,3)*q(1,3);
a33 = -q(1,3)+qp(1,3);
a34 = -qp(2,3);
a35 = q(2,3);
a36 = -qp(1,3)*q(2,3);

g1 = a31*a14*a22+a34*a12*a21-a34*a22*a11-a32*a14*a21-a31*a12*a24+a32*a24*a11;
g2 = a33*a14*a22+a34*a12*a23+a32*a24*a13-a34*a22*a13-a33*a12*a24-a32*a14*a23;
g3 = -a34*a11*a25+a31*a14*a25+a34*a15*a21-a31*a24*a15+a36*a22*a11+a35*a24*a11-a36*a12*a21-a31*a22*a16+a31*a12*a26-a35*a14*a21-a32*a11*a26+a32*a16*a21;
g4 = -a33*a22*a16+a34*a15*a23-a34*a11*a26+a33*a12*a26+a34*a16*a21+a31*a14*a26-a31*a24*a16-a32*a13*a26-a32*a15*a21+a32*a16*a23+a32*a11*a25+a31*a22*a15-a36*a14*a21-a36*a12*a23+a36*a22*a13+a36*a24*a11-a34*a13*a25-a35*a14*a23+a35*a12*a21-a35*a22*a11+a35*a24*a13+a33*a14*a25-a33*a24*a15-a31*a12*a25;
g5 = -a36*a14*a23+a36*a24*a13-a34*a13*a26+a35*a12*a23-a33*a24*a16-a35*a22*a13+a33*a22*a15+a33*a14*a26-a32*a15*a23-a33*a12*a25+a34*a16*a23+a32*a13*a25;
g6 = a36*a11*a25-a35*a11*a26-a36*a21*a15+a35*a16*a21-a31*a16*a25+a31*a15*a26;
g7 = -a36*a23*a15+a33*a15*a26+a35*a16*a23+a36*a13*a25-a33*a16*a25-a35*a13*a26;

H = [(-2*g3*g5+g3^2+g5^2+g4^2), ...
    (2*g7*g4-2*g6*g5+2*g2*g4+2*g6*g3-2*g1*g5+2*g1*g3), ...
    (2*g2*g7+2*g3*g5+g1^2+g2^2+g7^2+g6^2+2*g6*g1-2*g5^2-g4^2),...
    (-2*g7*g4+2*g1*g5+2*g6*g5-2*g2*g4),...
    -2*g2*g7-g7^2+g5^2-g2^2];

% solve the 4th order poly:
y = roots(H);

% kill off imaginary roots:
y = y(imag(y)==0 );

z = -(g6*y+g1*y+g3*y.^2-g5*y.^2+g5)./(g2+g7+g4*y);
d = (a22*a11-a12*a21)*y.^2+((-a14*a21+a22*a13+a24*a11-a12*a23).*z+a11*a25-a15*a21).*y+(a24*a13-a14*a23)*z.^2+(a13*a25-a15*a23)*z;

% kill off zero denominators:
nz = d~=0 & (g2+g7+g4*y) ~= 0;

y = y( nz );
z = z( nz );
d = d( nz );

w = -((-a14*a22+a12*a24)*y.^2+(a15*a24+a16*a22-a14*a25-a12*a26)*y+(-a14*a22+a12*a24)*z.^2+(-a14*a26+a12*a25-a15*a22+a16*a24)*z-a15*a26+a16*a25)./d;
x = -((a21*a14-a11*a24)*y.^2+((-a21*a12+a23*a14+a11*a22-a13*a24)*z+a11*a26-a21*a16).*y+(a13*a22-a23*a12)*z.^2+(a13*a26-a23*a16)*z)./d;
E = [w';x';y';z'];


