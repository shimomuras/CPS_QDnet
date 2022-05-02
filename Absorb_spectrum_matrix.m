function y=Absorb_spectrum_matrix(irr_wavelength,Abs540,Abs580)
ns=10^9;
irr_1=number_conversion(irr_wavelength*ns);

y = [Abs540(irr_1,2) Abs580(irr_1,2)];