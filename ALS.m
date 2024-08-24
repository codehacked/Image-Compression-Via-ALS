function [W, Z, iter] = ALS(A, r, tol)

    % Initialize W and Z
    W = rand(size(A,1), r);
    Z = rand(size(A,2), r);
    
    J_old = norm(A, "fro")^2;
    J = norm(A - W * Z', "fro")^2;
    
    iter = 0;
    % Main loop
    while abs(J - J_old) / J > tol
          
        iter = iter + 1;
    
        %************************************    
        % uncomment for direct implementation    
        %************************************    
%             %         %Update Z
%         Z = A' * W * inv(W' * W);
%         % Update W
%         W = A * Z * inv(Z' * Z);

    
    
        %************************************    
        % comment for direct implementation    
%         %************************************    
%         Update Z
        [Q, R] = qr(W, 0);
        Z = A' * Q * inv(R');
        % Update W
        [Q, R] = qr(Z, 0);
        W = A * Q * inv(R');
% % % %     
    
    
        %************************************    
        % cost function    
        %************************************    
        J_old = J;
        % Compute objective function value
        J = norm(A - W * Z', 'fro')^2;
    end

end