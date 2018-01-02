function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
%% 
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%%  cost function

K = num_labels;
for j = 1 : m
    yy=zeros(1,num_labels);
    yy(y(j))=1;
    y2(j,:)=yy;
end

X = [ones(m,1) X];
a1 = X';
z2 = Theta1 * a1;
a2 = sigmoid(z2);
a2 = [ones(1,m) ; a2];
z3 = Theta2 * a2;
a3 = sigmoid(z3);
h = a3';
for i = 1:m
    for k=1:K
         J = J + (1/m)*(-y2(i,k)*log(h(i,k))-(1-y2(i,k))*log(1-h(i,k)));
    end
end

t1 = 0;
for j = 1:hidden_layer_size
    for k=2:input_layer_size+1
        t1=t1+(Theta1(j,k))^2;
    end
end
t2 = 0;
for j = 1:num_labels
    for k=2:hidden_layer_size+1
       t2=t2+(Theta2(j,k))^2; 
    end
end

J = J + (lambda/(2*m))*(t1+t2);

%% grad
for t = 1:m
    delta3(:,t) = (a3(:,t)-y2(t,:)');
end
    g = sigmoidGradient(z2);
    delta2 = Theta2(:,2:end)' * delta3 .* g;
    Delta2 = delta3 * a2';
    Delta1 = delta2 * a1';
    D1 = Delta1(:,1)/m;
    D11 = Delta1(:,2:end)/m + lambda*Theta1(:,2:end)/m ;
    D2 = Delta2(:,1)/m;
    D22 = Delta2(:,2:end)/m + lambda*Theta2(:,2:end)/m ;
    Theta2_grad = [D2 D22];
    Theta1_grad = [D1 D11];
% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end