function z = get_density(x,y,density_params)
    if (density_params.gmm_flag == 0)
        z = ones(length(x),1);
    elseif (density_params.gmm_flag == 1)
        z = (1/(2*pi*density_params.sigma1(1)*density_params.sigma1(2))).*(exp(-0.5*(((x-density_params.mu1(1))./density_params.sigma1(1)).^2 + ((y-density_params.mu1(2))./density_params.sigma1(2)).^2)));
    elseif (density_params.gmm_flag == 2)
        z = 0.5*(1/(2*pi*density_params.sigma1(1)*density_params.sigma1(2))).*(exp(-0.5*(((x-density_params.mu1(1))./density_params.sigma1(1)).^2 + ((y-density_params.mu1(2))./density_params.sigma1(2)).^2))) +...
            0.5*(1/(2*pi*density_params.sigma2(1)*density_params.sigma2(2))).*(exp(-0.5*(((x-density_params.mu2(1))./density_params.sigma2(1)).^2 + ((y-density_params.mu2(2))./density_params.sigma2(2)).^2)));
    end
end