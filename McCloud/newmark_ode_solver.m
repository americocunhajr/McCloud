
% -----------------------------------------------------------------
%  newmark_ode_solver.m
%
%  This function computes the time response of the following
%  initial value problem:
%  
%  M*Uacce + C*Uvelo + K*Udisp = FNL(Udisp,t) for t > 0
%                        Udisp = Udisp0       for t = 0
%                        Uvelo = Uvelo0       for t = 0
%  where:
%  
%  Uacce = d^2 U(t)/dt^2 - acceleration vector in R^N at time t
%  Uvelo = d U(t)/dt     -     velocity vector in R^N at time t
%  Udisp = U(t)          - displacement vector in R^N at time t
%
%
%  Algorithm: 
%  This function uses Newmark sheme for time integration
%  of the equation of motion and Newton-Rapsom iteration 
%  to solve the nonlinear system of equations.
%
%  Reference:
%  Geradin and Cardona
%  Flexible Multibody Dynamics: A Finite Element Approach
%  John Willey & Sons, 2001, page 29
%
%  Input:
%  M          - N x N mass matrix
%  C          - N x N damping matrix
%  K          - N x N stiffness matrix
%  F          - N x Ndt linear external force matrix
%  Udisp0     - displacement initial condition
%  Uvelo0     -     velocity initial condition
%  dt         - time step
%  Ndt        - number of time steps
%  Nx         - number of mesh points
%  Nbasis     - number of basis functions
%  phi        - Nx x Nbasis basis functions matrix
%  nlflag     - nonlinear flag
%  phys_param - physical parameters vector
%
%  Output:
%  Udisp      - N x Ndt displacement matrix
%  Uvelo      - N x Ndt     velocity matrix
%  Uacce      - N x Ndt accelaration matrix
% ----------------------------------------------------------------- 
%  programmer: Americo Barbosa da Cunha Junior
%              americo.cunhajr@gmail.com
%
%  last update: Aug 16, 2012
% -----------------------------------------------------------------

% -----------------------------------------------------------------
function [Udisp,Uvelo,Uacce,iter] = ...
          newmark_ode_solver(M,C,K,F,Udisp0,Uvelo0,...
                             dt,Ndt,Nx,Nbasis,phi,nlflag,phys_param)
    
    % check number of arguments
    if nargin < 13
        error(' Too few inputs.')
    elseif nargin > 13
        error(' Too many inputs.')
    end
    
    % check input arguments
    if ( dt <= 0.0 )
        error('time step must be positive.')
    end
    
    if ( Ndt <= 0.0 )
        error('Ndt must be positive.')
    end
    
    if ( Nx <= 0.0 )
        error('Nx must be positive.')
    end
    
    if ( Nbasis <= 0.0 )
        error('Nbasis must be positive.')
    end
    
    
    % maximum number of iterations
    maxiter = 20;
    
    % error tolerance
    tol = 1.0e-7;
    
    % preallocate memory for work matrices
    Udisp = zeros(Nbasis,Ndt);
    Uvelo = zeros(Nbasis,Ndt);
    Uacce = zeros(Nbasis,Ndt);
    
    % compute nonlinear external force at initial time
    if ( nlflag == 1 )
        FNL = newmark_nonlinear_force(Udisp0,phi,Nx,phys_param);
    else
        FNL = zeros(Nbasis,1);
    end
    
    % compute acceleration at initial time
    Uacce0 = M\(F(:,1) + FNL - C*Uvelo0 - K*Udisp0);
    
    % set initial conditions
    Udisp(:,1) = Udisp0;
    Uvelo(:,1) = Uvelo0;
    Uacce(:,1) = Uacce0;
    
    % Newmark method parameters
    gamma = 1/2;
    beta  = 1/12;
    
    % Newmark method constants
    a0 = (1-gamma)*dt;
    a1 = dt;
    a2 = (1/2-beta)*dt*dt;
    a3 = 1/(beta*dt*dt);
    a4 = gamma/(beta*dt);
    
    
    % loop on time samplings
    for n=1:1:(Ndt-1)
        
        % iteration counter
        iter = 0;
        
        % compute predictor step
        Uacce(:,n+1) = zeros(Nbasis,1);
        Uvelo(:,n+1) = Uvelo(:,n) + a0*Uacce(:,n);
        Udisp(:,n+1) = Udisp(:,n) + a1*Uvelo(:,n) + a2*Uacce(:,n);
        
        % compute nonlinear external force
        if ( nlflag == 1 )
            [FNL,dFNL_dU] = ...
             newmark_nonlinear_force(Udisp(:,n+1),phi,Nx,phys_param);
        else
            FNL     = zeros(Nbasis,1);
            dFNL_dU = zeros(Nbasis,Nbasis);
        end
        
        % compute residual vector
        RV = M*Uacce(:,n+1) + C*Uvelo(:,n+1) + ...
             K*Udisp(:,n+1) - F(:,n+1) - FNL;
        
        % compute residual vector norm
        norm_RV = norm(RV,2);
        
        while ( norm_RV > tol && iter < maxiter )
            
            % update iteration counter
            iter = iter + 1;
            
            % compute effective stiffness matrix
            Keff = K - dFNL_dU + a4*C + a3*M;
            
            % compute iteration correction
            dUdisp = - Keff\RV;
            
            % increment the aproximation
            Uacce(:,n+1) = Uacce(:,n+1) + a3*dUdisp;
            Uvelo(:,n+1) = Uvelo(:,n+1) + a4*dUdisp;
            Udisp(:,n+1) = Udisp(:,n+1) +    dUdisp;
            
            % compute nonlinear external force
            if ( nlflag == 1 )
                [FNL,dFNL_dU] = ...
                 newmark_nonlinear_force(Udisp(:,n+1),phi,Nx,phys_param);
            else
                FNL     = zeros(Nbasis,1);
                dFNL_dU = zeros(Nbasis,Nbasis);
            end
            
            % compute residual vector
            RV = M*Uacce(:,n+1) + C*Uvelo(:,n+1) + ...
                 K*Udisp(:,n+1) - F(:,n+1) - FNL;
            
            % compute residual vector norm
            norm_RV = norm(RV,2);
            
        end
        
    end
    
return
% -----------------------------------------------------------------
