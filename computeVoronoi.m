% computeVoronoi     Compute Voronoi diagram and cell centroids in 2D convex polygon 
% Inputs: 
% 1. density_params
%     a) gmm_flag:  Flag to select one of the default density functions
%     b) mu1: 
%                   - Mean of Gaussian density if gmm_flag == 1
%                   - Mean of 1st component in a GMM of 2 proportions if gmm_flag == 2
%     c) mu2: 
%                   - Mean of 2nd component in a GMM of 2 proportions if gmm_flag == 2
%     d) sigma1: 
%                   - Std of Gaussian density if gmm_flag == 1
%                   - Std of 1st component in a GMM of 2 proportions if gmm_flag == 2
%     e) sigma2: 
%                   - Std of 2nd component in a GMM of 2 proportions if gmm_flag == 2
% 2. side_length :  Size of convex polygon (This is for a square, a simplified version for the convex polygon)
% 3. X:             Mx2 matrix containing the X and Y positions of M agents
%
% Outputs:
% 1. XY:            Mx2 matrix containing the updated X and Y positions of M agents 
% 2. centroid_x:    Mx1 vector containing x position of centroids of M Voronoi cells
% 3. centroid_y:    Mx1 vector containing y position of centroids of M Voronoi cells
%
% Author: KongYao, Chee (UPenn, PhD ESE)
% For usage, enquiries and/or permission, contact the author at ckongyao@seas.upenn.edu
% ----------------------------------------------------------------------------------------------------

% Selection of default density functions [INPUT]
density_params.gmm_flag	= 0; % 0: Uniform, 1: Gaussian, 2: GMM of 2 proportions

% Desired density functions with corresponding density parameters [INPUT]
F                   	= @get_density;
Fx                    	= @get_density_x;
Fy                  	= @get_density_y;
density_params.mu1      = [0 0];                                % Mean of the 1st component
density_params.mu2    	= [-2 -2];                              % Mean of the 2nd component	
density_params.sigma1 	= [sqrt(0.9+0*1.5) sqrt(0.5+0*1.5)];    % Covariance of the 1st component
density_params.sigma2 	= [sqrt(0.4) sqrt(0.6)];                % Covariance of the 2nd component

% Parameter for convex polytope/environment [INPUT]
side_length             = 6;

% Positions of agents [INPUT]
X                       = rand(20,2)*2*side_length-side_length;
   
[V, C, XY]              = VoronoiLimit(X(:,1), X(:,2), 'bs_ext', side_length*[1 1; 1 -1; -1 -1; -1 1], 'figure', 'off');
geom                    = zeros(length(C), 4);
sum_total               = zeros(length(C), 1);
sum_total_centroid_x    = zeros(length(C), 1);
sum_total_centroid_y    = zeros(length(C), 1);
centroid_x              = zeros(length(X), 1);
centroid_y              = zeros(length(X), 1);
    
for i=1:length(C)
    Y = V(C{i},:); 
    if (isinf(sum(Y(:))) == 0)
        [geom(i,:), iner, cpmo]         = polygeom(Y(:,1), Y(:,2));
        polyin                          = polyshape(Y(:,1), Y(:,2));
        T                               = triangulation(polyin);        

        for k=1:size(T.ConnectivityList,1)
            xy                          = T.Points(T.ConnectivityList(k,:),:);
            [V1,W]                      = simplexquad(2, xy);
            mass_centroid_triangle_x    = W'*Fx(V1(:,1),V1(:,2), density_params);
            mass_centroid_triangle_y    = W'*Fy(V1(:,1),V1(:,2), density_params);
            mass_triangle               = W'*F(V1(:,1),V1(:,2), density_params);
            sum_total(i)                = sum_total(i) + mass_triangle;
            sum_total_centroid_x(i)     = sum_total_centroid_x(i) + mass_centroid_triangle_x;
            sum_total_centroid_y(i)     = sum_total_centroid_y(i) + mass_centroid_triangle_y;
        end

        % Averaging the sum to get the centroid of each Voronoi cell [OUTPUT]
        centroid_x(i)                   = sum_total_centroid_x(i)/sum_total(i);
        centroid_y(i)                   = sum_total_centroid_y(i)/sum_total(i);
    else
        geom(i,:) = [0 X(i,1) X(i,2) 0];
    end
end    

% Visualization
figure();                   
voronoi(XY(:,1), XY(:,2), 'k'); 
hold on; grid on;            
p1 = plot(XY(:,1), XY(:,2), 'r*');
p2 = plot(centroid_x, centroid_y, 'm*');
plot(side_length*[1 1 -1 -1 1], side_length*[1 -1 -1 1 1], 'k', 'linewidth', 1.0);
axis equal; axis(1.2*side_length*[-1 1 -1 1]); 
xlabel('PosX'); ylabel('PosY');
legend([p1 p2], 'Robots', 'Centroids');

    



