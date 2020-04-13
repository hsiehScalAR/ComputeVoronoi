function z = get_density_y(x,y,density_params) 
    if (density_params.gmm_flag == 0)
        z = y;
    elseif (density_params.gmm_flag == 1)
        z = y.*(1/(2*pi*density_params.sigma1(1)*density_params.sigma1(2))).*(exp(-0.5*(((x-density_params.mu1(1))./density_params.sigma1(1)).^2 + ((y-density_params.mu1(2))./density_params.sigma1(2)).^2)));
    elseif (density_params.gmm_flag ==2)
        z = y.*0.5.*(1/(2*pi*density_params.sigma1(1)*density_params.sigma1(2))).*(exp(-0.5*(((x-density_params.mu1(1))./density_params.sigma1(1)).^2 + ((y-density_params.mu1(2))./density_params.sigma1(2)).^2))) +...
            y.*0.5.*(1/(2*pi*density_params.sigma2(1)*density_params.sigma2(2))).*(exp(-0.5*(((x-density_params.mu2(1))./density_params.sigma2(1)).^2 + ((y-density_params.mu2(2))./density_params.sigma2(2)).^2)));
    end
end